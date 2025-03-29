import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:tutorly/schedule/exports.dart';
import 'package:tutorly/shared/exports.dart';

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
      plugins: [
        ThemeModePlugin(initialTheme: ThemeMode.light),
        DeviceFramePlugin(
          initialData: (
            isFrameVisible: true,
            device: Devices.ios.iPhone13Mini,
            orientation: Orientation.portrait,
          ),
        ),
      ],
      initialStory: 'Screens/ScheduleForm',
      stories: [
        Story(
          name: 'Screens/ScheduleForm',
          description: 'Quick schedule form for simple schedule options',
          builder: (context) {
            return ScheduleForm();
          },
        ),
        Story(
          name: 'Widgets/QuickScheduleForm',
          description: 'Quick schedule form for simple schedule options',
          builder: (context) {
            return QuickScheduleList();
          },
        ),
        Story(
          name: 'Widgets/QuickWeekdayButton',
          description: 'A Segmented Button for quick time selection',
          builder: (context) {
            return QuickWeekdayButton(
              weekday: 'Tuesday',
              onSelectionChanged: (selection) {
                // Handle selection changes here
                print('Selected times: $selection');
              },
            );
          },
        ),
      ],
    );
  }
}
