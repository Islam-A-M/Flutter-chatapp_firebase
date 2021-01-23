import 'dart:io';

import 'package:chatapp/widgets/snackbar.dart';

import '../pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }
enum ErrorMode { Email, Password }

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      File userImageFile, bool isLogin) submitAuthForm;
  final bool isLoading;
  AuthForm(this.submitAuthForm, this.isLoading) : super();

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  ErrorMode _errorMode;
  var errorMessage;
  AnimationController _controller;
  // Animation<Size> _heightAnimation; //for AnimatedBuilder
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  static const double formhighetSingup = 470;
  static const double formhighetSingin = 300.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    //for AnimatedBuilder
    /*    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 280), end: Size(double.infinity, 340))
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceInOut,
      ),
    ); */ //for AnimatedBuilder
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    /*  _heightAnimation.addListener(() {
      setState(() {});
    }); */
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'username': '',
  };
  File _userImageFile;
  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text('An Error occurred'),
                content: Text(message),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay')),
                ]));
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  Future<void> _submit() async {
    _errorMode = null;
    errorMessage = null;
    FocusScope.of(context).unfocus();
    if (_authMode == AuthMode.Signup && _userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar('Please pick an image.', Icon(Icons.error), null));
      return;
    }
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    //print(_authData['email']);
    widget.submitAuthForm(
        _authData['email'].trim(),
        _authData['password'].trim(),
        _authData['username'].trim(),
        _userImageFile,
        _authMode == AuthMode.Login);
  }

  void _switchAuthMode() {
    _formKey.currentState.reset();

    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Center(
      child: Card(
          margin: EdgeInsets.all(20),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            height: _authMode == AuthMode.Signup
                ? formhighetSingup
                : formhighetSingin,
            //  height: _heightAnimation.value.height,
            constraints:
                //_authMode == AuthMode.Signup ? 320 : 260
                // _heightAnimation.value.height
                BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup
                        ? formhighetSingup
                        : formhighetSingin),
            width: deviceSize.width * 0.75,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  height: _authMode == AuthMode.Signup
                      ? formhighetSingup
                      : formhighetSingin,
                  //  height: _heightAnimation.value.height,
                  constraints:
                      //_authMode == AuthMode.Signup ? 320 : 260
                      // _heightAnimation.value.height
                      BoxConstraints(
                          minHeight: _authMode == AuthMode.Signup
                              ? formhighetSingup
                              : formhighetSingin),
                  width: deviceSize.width * 0.75,
                  padding: EdgeInsets.all(16.0),
                  //child: child,
                  //),
                  child: SingleChildScrollView(
                    //  scrollDirection: Axis.vertical,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_authMode == AuthMode.Signup)
                            UserImagePicker(_pickedImage),
                          TextFormField(
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                InputDecoration(labelText: 'Email address'),
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Invalid email!';
                              }
                              if (_errorMode == ErrorMode.Email) {
                                return errorMessage;
                              }
                              return null;
                              //  return null;
                            },
                            onSaved: (value) {
                              _authData['email'] = value;
                            },
                          ),
                          AnimatedContainer(
                            constraints: BoxConstraints(
                                minHeight:
                                    _authMode == AuthMode.Signup ? 60 : 0,
                                maxHeight:
                                    _authMode == AuthMode.Signup ? 120 : 0),
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child:
                                  /* SlideTransition(
                            position: _slideAnimation,
                            child: */
                                  TextFormField(
                                autocorrect: true,
                                textCapitalization: TextCapitalization.words,
                                enableSuggestions: false,
                                decoration:
                                    InputDecoration(labelText: 'Username'),
                                validator: _authMode == AuthMode.Signup
                                    ? (value) {
                                        if (value.isEmpty || value.length < 4) {
                                          return 'You must enter a username';
                                        }
                                        if (_errorMode == ErrorMode.Password) {
                                          return errorMessage;
                                        }
                                        return null;
                                      }
                                    : null,
                                onSaved: (value) {
                                  _authData['username'] = value;
                                },
                              ),
                            ),
                            /* ), */
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'Password'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 5) {
                                return 'Password is too short!';
                              }
                              if (_errorMode == ErrorMode.Password) {
                                return errorMessage;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['password'] = value;
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          if (widget.isLoading) CircularProgressIndicator(),
                          if (!widget.isLoading)
                            RaisedButton(
                              child: Text(_authMode == AuthMode.Login
                                  ? 'LOGIN'
                                  : 'SIGN UP'),
                              onPressed: _submit,
                            ),
                          if (!widget.isLoading)
                            FlatButton(
                              textColor: Theme.of(context).primaryColor,
                              child: Text(
                                  '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                              onPressed: _switchAuthMode,
                            )
                        ],
                      ),
                    ),
                  )),
            ),
          )),
    );
  }
}
