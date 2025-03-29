import 'package:flutter/material.dart';
import 'package:tutorly/app/exports.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Dashboard());
  }

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  // pages for each tab
  static final List<Widget> _widgetOptions = <Widget>[
    const Placeholder(), // Placeholder of Home
    const Placeholder(), // Placeholder of Chat
    const Placeholder(), // Placeholder of Chat
    const Placeholder(), // Placeholder of Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      appBar: DashboardAppbarBeta(),
      body: Stack(
        children: [
          // Background image covering the entire screen.
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                alignment: Alignment.bottomCenter,
                image: AssetImage('assets/images/app/upper-bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Your current body wrapped in SafeArea.
          SafeArea(child: _widgetOptions[_selectedIndex]),
        ],
      ),
      // <<<< Rounded off Bottom Navigation Bar >>>>
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.only(bottom: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.black,
                splashFactory: NoSplash.splashFactory, // Disables ripple effect
                highlightColor: Colors.transparent, // Removes the highlight
              ),
              child: BottomNavigationBar(
                showUnselectedLabels: true,
                elevation: 20,
                enableFeedback: true,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month),
                    label: 'Sessions',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.mark_unread_chat_alt),
                    label: 'Chat',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.portrait_outlined),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Theme.of(context).primaryColorDark,
                unselectedItemColor: Theme.of(context).indicatorColor,
                onTap: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
