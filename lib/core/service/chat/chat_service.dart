import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:verbisense/model/chat_model.dart';
import 'package:verbisense/utils/helper.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<List<String>?> getFiles() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      Reference filesRef = _firebaseStorage.ref().child('uploads/${user.uid}/');
      ListResult filesList = await filesRef.listAll();

      List<String> fileUrls = await Future.wait(
        filesList.items.map((itemRef) => itemRef.getDownloadURL()).toList(),
      );

      return fileUrls;
    } catch (e) {
      print('Error fetching files: $e');
      return null;
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      String filePath = 'uploads/${user.uid}/${file.path.split('/').last}';
      Reference fileRef = _firebaseStorage.ref().child(filePath);
      UploadTask uploadTask = fileRef.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> deleteFile(String fileName) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      String filePath = 'uploads/${user.uid}/$fileName';
      Reference fileRef = _firebaseStorage.ref().child(filePath);
      await fileRef.delete();
      return true;
    } catch (e) {
      print("Error deleting file: $e");
      return false;
    }
  }

  Future<List<ChatModel>> getChatData(String? date) async {
    User? user = _firebaseAuth.currentUser;

    if (user == null) return [];

    try {
      String formattedDate = formatDateAsString();

      CollectionReference userChatsRef =
          _firestore.collection('users').doc(user.uid).collection('chats');
      DocumentReference dateDocRef = userChatsRef.doc(date ?? formattedDate);
      CollectionReference messagesCollectionRef =
          dateDocRef.collection('messages');

      Query query =
          messagesCollectionRef.orderBy('timestamp', descending: false);

      QuerySnapshot querySnapshot = await query.get();

      List<ChatModel> messages = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return ChatModel(
          query: data['query'] ?? '',
          heading1: data['heading1'],
          heading2: List<String>.from(data['heading2'] ?? []),
          keyTakeaways: data['key_takeaways'] ?? '',
          points: Points.fromJson(data['points'] ?? {}),
          example: List<String>.from(data['example'] ?? []),
          summary: data['summary'] ?? '',
          error: data['error'] ?? '',
        );
      }).toList();

      return messages;
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  Future<List<Map<String, String>>?> getHistory() async {
    User? user = _firebaseAuth.currentUser;

    if (user == null) return null;
    String date = formatDateAsString();
    try {
      CollectionReference userChatsRef =
          _firestore.collection('users').doc(user.uid).collection('chats');
      Query chatsQuery = userChatsRef.orderBy('timestamp', descending: true);
      QuerySnapshot querySnapshot = await chatsQuery.get();

      List<Map<String, String>> chats = await Future.wait(
        querySnapshot.docs
            .where((doc) => doc.id != date)
            .take(4)
            .map((doc) async {
          CollectionReference messagesRef = _firestore
              .collection('users')
              .doc(user.uid)
              .collection('chats')
              .doc(doc.id)
              .collection('messages');

          Query messagesQuery = messagesRef.orderBy('timestamp');
          QuerySnapshot messagesSnapshot = await messagesQuery.get();

          String heading1 = messagesSnapshot.docs.isNotEmpty &&
                  (messagesSnapshot.docs.first.data()
                          as Map<String, dynamic>)['heading1'] !=
                      null
              ? (messagesSnapshot.docs.first.data()
                  as Map<String, dynamic>)['heading1']
              : 'Greeting';

          return {doc.id: heading1};
        }).toList(),
      );

      return chats;
    } catch (e) {
      print('Error fetching user chats: $e');
      return null;
    }
  }

  Future<ChatModel?> sendMessage(
      String query, List<String> files, String? date) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return null;
      }

      final response = await http.post(
        Uri.parse('${dotenv.env['BACKEND_URL']}/chat'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'query': query,
          'files': files,
          'userId': user.uid,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        final chatData = ChatModel.fromJson(data);
        final savedInFireStore = await _saveInFireStore(chatData, date);
        if (savedInFireStore) {
          return chatData;
        }
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> _saveInFireStore(ChatModel chatData, String? date) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return false;

      final formattedDate = date ?? DateTime.now().toIso8601String();
      final userChatsRef =
          _firestore.collection('users').doc(user.uid).collection('chats');
      final dateDocRef = userChatsRef.doc(formattedDate);

      final docSnapshot = await dateDocRef.get();
      if (!docSnapshot.exists) {
        await dateDocRef.set({'timestamp': FieldValue.serverTimestamp()});
      }

      final messagesRef = dateDocRef.collection('messages');
      final chatDataWithTimestamp = chatData.toJson()
        ..['timestamp'] = FieldValue.serverTimestamp();

      await messagesRef.add(chatDataWithTimestamp);
      return true;
    } catch (e) {
      print("Error writing document: $e");
      return false;
    }
  }
}
