import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

import '../components/usertile.dart';
import '../services/auth/auth_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //chat & auth servicea

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  //build users list except for the logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text('Error');
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading....');
        }

        //return list
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //single tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display alll except the current user
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          //navigate to chat page
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  recieverEmail: userData['email'],
                  recieverID: userData['uid'],
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
