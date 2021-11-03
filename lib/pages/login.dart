import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:supermarche_abc/pages/principal.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.reference();
  late TextEditingController _usernameFieldController = TextEditingController(),
      _passwordFieldController = TextEditingController();
  late StreamSubscription _userStream;
  late var list = [];

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  @override
  void deactivate() {
    _userStream.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    _passwordFieldController.dispose();
    _usernameFieldController.dispose();
    super.dispose();
  }

  void _activateListeners() {
    _userStream = _database.child('users').onValue.listen((event) {
      //final data = new Map<String, dynamic>.from(event.snapshot.value);
      setState(() {
        list = event.snapshot.value.values.toList();
      });
    }, onError: (Object o) {
      final DatabaseError error = o as DatabaseError;
      print('Error: ${error.code} ${error.message}');
    });
  }

  List userExist() {
    bool check = false;
    var email, password, amount, userId, s, i = 0;
    print(list);
    for (var item in list) {
      i += 1;
      if (item.toString().contains(
          RegExp('username: ${_usernameFieldController.text}+(,|})'))) {
        check = true;
      }
      if (check == true) {
        userId = i;
        //userId = list.asMap();
        s = item.toString().substring(item.toString().indexOf('email: ') + 7);
        email = s.substring(0, s.indexOf(RegExp('[,}]')));
        s = item
            .toString()
            .substring(item.toString().indexOf('password: ') + 10);
        password = s.substring(0, s.indexOf(RegExp('[,}]')));
        s = item.toString().substring(item.toString().indexOf('amount: ') + 8);
        amount = s.substring(0, s.indexOf(RegExp('[,}]')));
        break;
      }
    }
    print('$check, $email, $amount, $userId');
    return [check, email, password, amount, userId];
  }

  /*bool passwordExist() {
    bool check = false;
    for (var item in list) {
      if (item.toString().contains(_passwordFieldController.text)) {
        check = true;
      }
    }
    print('pwd $check');
    return check;
  }*/

  @override
  Widget build(BuildContext context) {
    //final user = _database.child('users');
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30.0),
                Text(
                  AppLocalizations.of(context)!.login,
                  style: TextStyle(
                      color: Colors.orange[900],
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 25.0, right: 25.0),
                  child: TextFormField(
                    controller: _usernameFieldController,
                    autocorrect: false,
                    //autofocus: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person, //account_circle_sharp,
                        color: Colors.blueGrey,
                      ),
                      labelText: AppLocalizations.of(context)!.username,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Color(0xFF546E7A),
                        ),
                      ),
                    ),
                    validator: (value) {
                      final RegExp exp = RegExp(r'^[A-Za-z0-9]+$');
                      if (value?.isEmpty ?? false) {
                        return AppLocalizations.of(context)!.usernameRequired;
                      }
                      if (!exp.hasMatch(value!)) {
                        return AppLocalizations.of(context)!.incorrectUsername;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Color(0xFF546E7A), fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, left: 25.0, right: 25.0, bottom: 30),
                  child: TextFormField(
                    controller: _passwordFieldController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.https,
                        color: Colors.blueGrey,
                      ),
                      labelText: AppLocalizations.of(context)!.password,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Color(0xFF546E7A),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return AppLocalizations.of(context)!.passwordRequired;
                      }
                      return null;
                    },
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(color: Colors.blueGrey[600], fontSize: 18),
                  ),
                ),
                SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () async {
                    try {
                      // await user.update({})
                      //_activateListeners();
                      if (await ConnectivityWrapper.instance.isConnected) {
                        var _data = userExist();
                        if (_data[0] == true &&
                            _data[2] == _passwordFieldController.text &&
                            _formKey.currentState!.validate()) {
                          //print('User logged in successfully');
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Principal(
                                userEmail: _data[1],
                                userName: _usernameFieldController.text,
                                userAmount: _data[3],
                                userId: _data[4],
                              ),
                            ),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .incorrectEntryLogin),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!.noInternetAccess),
                          ),
                        );
                      }
                    } catch (e) {
                      print('THERE WAS THIS ERROR $e');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors
                              .orange[900], //Color.fromRGBO(26, 53, 153, 0.5),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .loginButton
                              .toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                /*SizedBox(height: 2.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Divider(),
                          Text('Or login with'),
                          Divider(),
                        ],
                      ),
                      SizedBox(height: 3.0),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        children: [
                          MaterialButton(
                            child: FaIcon(FontAwesomeIcons.facebook),
                            onPressed: () {},
                            elevation: 2,
                            shape: CircleBorder(),
                          ),
                          MaterialButton(
                            child: FaIcon(FontAwesomeIcons.google),
                            onPressed: () {},
                            elevation: 2,
                            shape: CircleBorder(),
                          ),
                        ],
                      )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
