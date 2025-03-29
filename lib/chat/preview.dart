import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:tutorly/chat/exports.dart';
import '../../shared/repositories/_export.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  void initState() {
    super.initState();
    _login();
  }

  Future<void> _login() async {
    await context.read<AuthenticationRepository>().logInWithEmailAndPassword(
      email: 'ohjime@icloud.com',
      password: 'password',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChatPreview(); // Replace with your desired widget
  }
}

class ChatPreview extends StatelessWidget {
  const ChatPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Storybook(
      initialStory: 'Screens/ChatTab',
      stories: [
        Story(
          name: 'Screens/ChatTab',
          description: 'Chat room screen with messages.',
          builder: (context) {
            return ChatTab();
          },
        ),
        Story(
          name: 'Widgets/UserSearchBar',
          description: ' Search bar for users.',
          builder: (context) {
            return ChatSearchBar();
          },
        ),
      ],
    );
  }
}
