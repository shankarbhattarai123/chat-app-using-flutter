import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser;
  var _enteredmessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Chat screen"),
        actions: [
          FlatButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout),
              label: Text("sign out"))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 230,
              height: MediaQuery.of(context).size.height - 10,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat/FzTTGbU4TM2wOlHJb3iK/messages')
                    .snapshots(),
                builder: (ctx, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final documents = streamSnapshot.data.docs;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (ctx, index) => Row(
                      mainAxisAlignment: documents[index]['userId'] == user.uid
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    documents[index]['userId'] == user.uid
                                        ? BorderRadius.circular(10)
                                        : BorderRadius.circular(20),
                                color: documents[index]['userId'] == user.uid
                                    ? Colors.purple
                                    : Colors.grey,
                              ),
                              padding: EdgeInsets.only(
                                  left: 14, right: 14, top: 10, bottom: 10),
                              child: Text(
                                documents[index]['text'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _enteredmessage = value;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: _enteredmessage.trim().isEmpty
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();
                                  FirebaseFirestore.instance
                                      .collection(
                                          'chat/FzTTGbU4TM2wOlHJb3iK/messages')
                                      .add({
                                    'text': _enteredmessage,
                                    'createdAt': Timestamp.now(),
                                    'userId': user.uid,
                                  });
                                  setState(() {
                                    _enteredmessage = '';
                                  });
                                },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: Colors.blue,
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
