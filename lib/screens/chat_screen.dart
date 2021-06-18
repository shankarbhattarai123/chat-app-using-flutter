import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, i) => Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "This works!",
              style: TextStyle(color: Colors.black),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Firebase.initializeApp();

          final instance = FirebaseFirestore.instance;
          instance
              .collection('chat/FzTTGbU4TM2wOlHJb3iK/messages')
              .snapshots()
              .listen((data) {
            print("data.text");
          });
        },
      ),
    );
  }
}
