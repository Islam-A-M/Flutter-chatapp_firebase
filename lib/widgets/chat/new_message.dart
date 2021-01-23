import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  NewMessage({Key key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _sendMessageInputController = new TextEditingController();
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('chat').add({
      'text': _sendMessageInputController.text,
      'createdAt': Timestamp.now(),
      'userId': user.uid
    });
    _sendMessageInputController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    var _isNotNull = false;
    _sendMessageInputController.addListener(() {
      if (_sendMessageInputController.text.trim().isNotEmpty && !_isNotNull) {
        _isNotNull = true;
        print('performance');
        setState(() {});
      } else if (_sendMessageInputController.text.trim().isEmpty) {
        _isNotNull = false;

        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _sendMessageInputController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            controller: _sendMessageInputController,
            decoration: InputDecoration(labelText: 'Send a message...'),
            /*           onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            }, */
          )),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: _sendMessageInputController.text.trim().isEmpty
                ? null
                : _sendMessage,
          ),
        ],
      ),
    );
  }
}
