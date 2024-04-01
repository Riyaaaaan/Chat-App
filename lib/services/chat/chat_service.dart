import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through individual user
        final user = doc.data();
        //return user
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String recieverID, message) async {
    //get current user
    final currentUserID = _auth.currentUser!.uid;
    final currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      recieverID: recieverID,
      message: message,
      timestamp: timestamp,
    );

    //chat room id for 2 users
    List<String> ids = [currentUserID, recieverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    //add message to db
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //get message

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //chat room id for 2 users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
