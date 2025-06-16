import 'package:chat_app/pages/SelectContactPage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/pages/chat_list_page.dart';
import 'package:chat_app/pages/settings_page.dart';

class WhatsAppHomePage extends StatefulWidget {
  static String id = 'WhatsAppHomePage';

  @override
  State<WhatsAppHomePage> createState() => _WhatsAppHomePageState();
}

class _WhatsAppHomePageState extends State<WhatsAppHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String email;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    email = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('WhatsApp'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Chats'),
            Tab(text: 'Status'),
            Tab(text: 'Calls'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatListPage(),
          ComingSoonPage(title: 'Status'),
          ComingSoonPage(title: 'Calls'),
          SettingsPage(currentUserEmail: email),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              backgroundColor: Colors.teal,
              child: Icon(Icons.chat),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectContactPage(currentUserEmail: email),
                  ),
                );
              },
            )
          : null,
    );
  }
}

class ComingSoonPage extends StatelessWidget {
  final String title;

  const ComingSoonPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title\nComing Soon...',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, color: Colors.grey),
      ),
    );
  }
}
