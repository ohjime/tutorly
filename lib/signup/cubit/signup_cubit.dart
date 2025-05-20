import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tutorly/core/core.dart' as core;

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    core.AuthenticationRepository? authenticationRepository,
    core.StorageRepository? storageRepository,
    core.TutorRepository? tutorRepository,
    core.StudentRepository? studentRepository,
    core.UserRepository? userRepository,
  }) : _authenticationRepository =
           authenticationRepository ?? core.AuthenticationRepository(),
       _storageRepository = storageRepository ?? core.StorageRepository(),
       _userRepository = userRepository ?? core.UserRepository(),
       _tutorRepository = tutorRepository ?? core.TutorRepository(),
       _studentRepository = studentRepository ?? core.StudentRepository(),
       super(SignupState.initial());

  final core.AuthenticationRepository _authenticationRepository;
  final core.UserRepository _userRepository;
  final core.StorageRepository _storageRepository;
  final core.TutorRepository _tutorRepository;
  final core.StudentRepository _studentRepository;

  void selectRole(core.UserRole role) {
    emit(
      state.copyWith(
        user: state.user.copyWith(role: role),
        tutor: role == core.UserRole.tutor ? state.tutor : core.Tutor.empty,
        student:
            role == core.UserRole.student ? state.student : core.Student.empty,
      ),
    );
  }

  void updateUser(Map<String, dynamic> userData) {
    final updatedUser = state.user.copyWith(
      name: userData['name'] ?? state.user.name,
      email: userData['email'] ?? state.user.email,
      imageUrl: userData['imageUrl'] ?? state.user.imageUrl,
      coverUrl: userData['coverUrl'] ?? state.user.coverUrl,
      schedule: userData['schedule'] ?? state.user.schedule,
    );
    emit(state.copyWith(user: updatedUser));
  }

  void updateTutor(Map<String, dynamic> tutorData) {
    final updatedTutor = state.tutor.copyWith(
      headline: tutorData['headline'] ?? state.tutor.headline,
      bio: tutorData['bio'] ?? state.tutor.bio,
      courses: tutorData['courses'] ?? state.tutor.courses,
      academicCredentials:
          tutorData['academicCredentials'] ?? state.tutor.academicCredentials,
    );
    emit(state.copyWith(tutor: updatedTutor));
  }

  void updateStudent(Map<String, dynamic> studentData) {
    final updatedStudent = state.student.copyWith(
      headline: studentData['headline'] ?? state.student.headline,
      bio: studentData['bio'] ?? state.student.bio,
      courses: studentData['courses'] ?? state.student.courses,
      gradeLevel: studentData['gradeLevel'] ?? state.student.gradeLevel,
      educationInstitute:
          studentData['educationInstitute'] ?? state.student.educationInstitute,
    );
    emit(state.copyWith(student: updatedStudent));
  }

  /// Submit the completed signup form with email and password
  Future<void> submit(Map<String, dynamic> authData) async {
    try {
      emit(state.copyWith(status: SignupStatus.loading));
      // Sign up with the authentication repository
      await _authenticationRepository.signUp(
        email: authData['email'] as String,
        password: authData['password'] as String,
      );
      // Get the user email after Google sign-in
      final credential = _authenticationRepository.currentCredential;
      if (credential != core.AuthCredential.empty) {
        // Update the user with email
        final updatedUser = state.user.copyWith(email: credential.email);
        emit(state.copyWith(user: updatedUser));
        // Save the user data
        await _postAuthenticationProcess(
          credential,
        ); // Call _postAuthenticationProcess
        emit(state.copyWith(status: SignupStatus.success));
      } else {
        // raise an exception if the credential is empty
        throw Exception('Failed to retrieve credentials after sign up.');
      }
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.failure, error: e.toString()));
    }
  }

  /// Submit the signup form using Google authentication
  Future<void> submitWithGoogle() async {
    try {
      emit(state.copyWith(status: SignupStatus.loading));
      // Sign in with Google
      await _authenticationRepository.logInWithGoogle();
      // Get the user email after Google sign-in
      final credential = _authenticationRepository.currentCredential;
      if (credential != core.AuthCredential.empty) {
        await _postAuthenticationProcess(
          credential,
        ); // Call _postAuthenticationProcess
        emit(state.copyWith(status: SignupStatus.success));
      } else {
        // Handle case where credential is empty after Google sign in
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            error: 'Failed to retrieve credentials after Google sign in.',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.failure, error: e.toString()));
    }
  }

  Future<void> _postAuthenticationProcess(
    core.AuthCredential credential,
  ) async {
    emit(state.copyWith(user: state.user.copyWith(email: credential.email)));
    // Get the current authenticated user ID from the authRepository
    final uid = _authenticationRepository.currentCredential.id;
    // save local path imageUrl and coverUrl to Cloud Storage
    final imageUrl = await _storageRepository.uploadFile(
      uid,
      state.user.imageUrl ?? '', // Handle null imageUrl
    );
    final coverUrl = await _storageRepository.uploadFile(
      uid,
      state.user.coverUrl ?? '', // Handle null coverUrl
    );
    // Save the user to Firestore
    await _userRepository.createUser(
      uid,
      state.user.copyWith(imageUrl: imageUrl, coverUrl: coverUrl),
    );
    // save the user role data
    if (state.user.role == core.UserRole.tutor) {
      _tutorRepository.createTutor(uid, state.tutor);
    } else if (state.user.role == core.UserRole.student) {
      _studentRepository.createStudent(uid, state.student);
    }
  }
}
