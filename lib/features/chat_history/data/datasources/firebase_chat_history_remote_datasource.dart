import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/utils/helper.dart';
import 'package:verbisense/features/chat_history/data/models/history_model.dart';

abstract class FirebaseChatHistoryRemoteDatasource {
  Future<List<HistoryModel>> getChatHistory();
}

class FirebaseChatHistoryRemoteDatasourceImpl
    implements FirebaseChatHistoryRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirebaseChatHistoryRemoteDatasourceImpl(
    this.firebaseAuth,
    this.firestore,
  );
  @override
  Future<List<HistoryModel>> getChatHistory() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user == null) {
        throw const ServerException('User not authenticated');
      }
      String currentDate = formatDateAsString();

      CollectionReference userChatsRef = firestore
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
}
