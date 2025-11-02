import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/utils/helper.dart';
import 'package:verbisense/features/drawer/data/models/history_model.dart';

abstract class FirebaseDrawerRemoteDataSource {
  Future<List<String>> getUploadedFiles();
  Future<List<HistoryModel>> getChatHistory();
  Future<String> uploadFile(File file);
  Future<void> deleteFile(String fileName);
}

class FirebaseDrawerRemoteDataSourceImpl
    implements FirebaseDrawerRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  FirebaseDrawerRemoteDataSourceImpl(
    this.firebaseAuth,
    this._firestore,
    this._firebaseStorage,
  );

  @override
  Future<List<String>> getUploadedFiles() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user == null) {
        throw const ServerException('User not authenticated');
      }
      Reference filesRef = _firebaseStorage.ref().child(
        'uploads/${user.uid}/',
      );
      ListResult filesList = await filesRef.listAll();

      List<String> fileUrls = await Future.wait(
        filesList.items.map((itemRef) => itemRef.getDownloadURL()).toList(),
      );

      return fileUrls;
    } catch (e) {
      throw const ServerException('Failed to retrieve files');
    }
  }

  @override
  Future<List<HistoryModel>> getChatHistory() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user == null) {
        throw const ServerException('User not authenticated');
      }
      String currentDate = formatDateAsString();

      CollectionReference userChatsRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats');

      Query descendingChatsQuery = userChatsRef.orderBy(
        'timestamp',
        descending: true,
      );

      QuerySnapshot querySnapshot = await descendingChatsQuery.get();

      List<HistoryModel?> nullableChatHistories = await Future.wait(
        querySnapshot.docs.take(4).where((doc) => doc.id != currentDate).map((
          doc,
        ) async {
          CollectionReference messagesRef = userChatsRef
              .doc(doc.id)
              .collection('messages');

          QuerySnapshot messagesSnapshot = await messagesRef
              .orderBy('timestamp', descending: true)
              .get();

          if (messagesSnapshot.docs.isNotEmpty) {
            String? heading1 = messagesSnapshot.docs.first.get('heading1');
            return HistoryModel(cid: doc.id, heading1: heading1);
          }
          return null;
        }).toList(),
      );

      List<HistoryModel> chatHistories = nullableChatHistories
          .where((history) => history != null)
          .cast<HistoryModel>()
          .toList();

      return chatHistories;
    } catch (e) {
      throw const ServerException('Failed to retrieve chat history');
    }
  }

  @override
  Future<String> uploadFile(File file) async {
    try {
      User? user = firebaseAuth.currentUser;
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
      throw const ServerException('File upload failed');
    }
  }

  @override
  Future<void> deleteFile(String fileName) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      String filePath = 'uploads/${user.uid}/$fileName';
      Reference fileRef = _firebaseStorage.ref().child(filePath);
      await fileRef.delete();
    } catch (e) {
      throw const ServerException('File deletion failed');
    }
  }
}
