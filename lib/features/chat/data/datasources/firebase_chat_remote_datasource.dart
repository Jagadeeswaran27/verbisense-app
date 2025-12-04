import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/error/firebase_error_code.dart';
import 'package:verbisense/core/resources/strings/firebase_error_strings.dart';
import 'package:verbisense/core/utils/helper.dart';
import 'package:verbisense/features/drawer/data/models/chat_model.dart';

abstract class FirebaseChatRemoteDataSource {
  Future<List<ChatModel>> getChatData(String? date);
}

class FirebaseChatRemoteDataSourceImpl implements FirebaseChatRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirebaseChatRemoteDataSourceImpl(
    this._firestore,
    this._firebaseAuth,
  );

  static String getFirebaseError(FirebaseException e) {
    final errorCode = FirebaseErrorCodeX.fromCode(e.code);
    if (errorCode != null) {
      return errorCode.message;
    } else {
      return e.message ?? FirebaseErrorStrings.unknownFirebaseError;
    }
  }

  @override
  Future<List<ChatModel>> getChatData(String? date) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const ServerException('User not authenticated');
      }

      String todayDate = formatDateAsString();
      String queryDate = date ?? todayDate;

      CollectionReference messagesCollectionRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(queryDate)
          .collection('messages');

      Query query = messagesCollectionRef.orderBy(
        'timestamp',
        descending: false,
      );

      QuerySnapshot querySnapshot = await query.get();

      List<ChatModel> chatData = querySnapshot.docs.map((doc) {
        return ChatModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return chatData;
    } on FirebaseException catch (e) {
      String errorMessage = getFirebaseError(e);
      throw ServerException(errorMessage);
    } catch (e) {
      throw ServerException('Failed to fetch chat data: $e');
    }
  }
}
