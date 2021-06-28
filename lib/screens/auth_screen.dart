import 'package:flutter/material.dart';
// import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  FirebaseAuth auth = FirebaseAuth.instance;
  var _username = '';
  var _email = '';
  var _password = '';
  var _islogin = true;
  void _onsubmitform() async {
    if (_islogin) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          'username': _username.toString(),
          'email': _email.toString(),
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void _saveForm() {
    final bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      _onsubmitform();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
        backgroundColor: Colors.red.shade500,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: ValueKey("email"),
                validator: (value) {
                  if (value.trim().length < 3 || !value.contains('@')) {
                    return 'This field requires a minimum of 3 characters and @';
                  }

                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
                decoration: InputDecoration(
                    labelText: 'Enter Email id',
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              if (!_islogin)
                TextFormField(
                  key: ValueKey("username"),
                  validator: (value) {
                    if (value.trim().length < 6) {
                      return 'This field requires a minimum of 6';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _username = value;
                  },
                  decoration: InputDecoration(
                      labelText: 'Enter Username',
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.blue),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.red),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                key: ValueKey("password"),
                obscureText: true,
                validator: (value) {
                  if (value.trim().length < 7) {
                    return 'This field requires a minimum of 7 characters';
                  }

                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
                decoration: InputDecoration(
                    labelText: 'Enter your password',
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _islogin = !_islogin;
                  });
                },
                child: Text(
                  _islogin
                      ? "Register a new account"
                      : 'I already have a account',
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        _saveForm();
                      },
                      child: Text(
                        _islogin ? 'Login' : 'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
