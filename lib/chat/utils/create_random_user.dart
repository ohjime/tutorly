import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

Future<void> createRandomUser() async {
  final userCredential = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
        email: Faker().internet.email(),
        password: 'password',
      );

  await FirebaseChatCore.instance.createUserInFirestore(
    types.User(
      id: userCredential.user!.uid,
      firstName: Faker().person.firstName(),
      lastName: Faker().person.lastName(),
      imageUrl: Faker().image.loremPicsum(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      lastSeen: DateTime.now().millisecondsSinceEpoch,
      metadata: null,
      role: null,
    ),
  );
}
