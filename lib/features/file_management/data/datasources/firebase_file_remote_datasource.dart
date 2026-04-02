import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:verbisense/core/error/exceptions.dart';

abstract class FirebaseFileRemoteDatasource {
  Future<List<String>> getUploadedFiles();
  Future<String> uploadFile(File file);
  Future<void> deleteFile(String fileName);
}

class FirebaseFileRemoteDatasourceImpl implements FirebaseFileRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage _firebaseStorage;

  FirebaseFileRemoteDatasourceImpl(
    this.firebaseAuth,
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
