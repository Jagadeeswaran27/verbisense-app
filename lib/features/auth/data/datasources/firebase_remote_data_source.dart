abstract class FirebaseRemoteDataSource {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

// class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource{
//   final 
// }