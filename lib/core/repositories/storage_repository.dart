import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({FirebaseStorage? firebaseStorage})
    : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns the download URL.
  ///
  /// [userId] is the ID of the user uploading the file.
  /// [filePath] is the local path to the file to be uploaded.
  Future<String> uploadFile(String userId, String filePath) async {
    if (filePath.isEmpty) {
      // Return an empty string or throw an error if the filePath is empty
      // This indicates that no file was selected or provided.
      return '';
    }
    try {
      final file = File(filePath);
      // Extract the file name from the path
      final fileName = filePath.split('/').last;

      // Define the storage path, e.g., users/{userId}/uploads/{fileName}
      // You can customize this path structure as needed.
      final ref = _firebaseStorage
          .ref()
          .child('users')
          .child(userId)
          .child('uploads')
          .child(fileName);

      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      // It's good practice to log the error or handle it appropriately
      print('Firebase Storage Error (uploadFile): ${e.code} - ${e.message}');
      throw Exception('Error uploading file: ${e.message}');
    } catch (e) {
      print('Unexpected error during file upload (uploadFile): $e');
      throw Exception('An unexpected error occurred during file upload.');
    }
  }
}
