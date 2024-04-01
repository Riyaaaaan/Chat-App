import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_ios_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import '../themes/theme_provider.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;
  const ChatPage({
    super.key,
    required this.recieverEmail,
    required this.recieverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //pop function
  void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  //focus node
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    _messageController.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat & auth services
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  //send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.recieverID, _messageController.text);

      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.recieverEmail),
        // backgroundColor: Colors.transparent,
        // foregroundColor: Colors.grey,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IosButton(onPressed: () => pop(context)),
      ),
      body: Column(
        children: [
          //display msg

          Expanded(child: _buildMessageList()),

          //user input
          _buildUserInput(isDarkMode),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.recieverID, senderID),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text('Error');
        }

        //loadiing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        //list
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is cuurent user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    //left for other user
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser)
        ],
      ),
    );
  }

  //build message input
  Widget _buildUserInput(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              hintText: 'Type a message',
              obscureText: false,
              controller: _messageController,
              focusNode: myFocusNode,
            ),
          ),
          // send button
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.blue : Colors.black,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
