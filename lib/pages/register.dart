//import 'dart:io';
import 'dart:async';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:supermarche_abc/pages/login.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  Register({Key? key, this.userCount}) : super(key: key);

  final userCount;
  //final FirebaseApp app;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.reference();
  late TextEditingController _usernameFieldController = TextEditingController(),
      _emailFieldController = TextEditingController(),
      _passwordFieldController = TextEditingController();
  late StreamSubscription _userStream;
  late var list = [], wichOne = '';
  late int totalUser = 0;

  //var _profilePic;
  //final _picker = ImagePicker();

  /* Future _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() => _profilePic = File(pickedFile!.path));
  } */

  /* Future _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() => _profilePic = File(pickedFile!.path));
  } */

  /*Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if(response.isEmpty){
      return;
    }
    if(response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
          _handleVideo(response.file);
        } else {
          _handleImage(response.file);
        }
      });
    } else {
      _handleError(response.exception);
    }
  }*/

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
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    _usernameFieldController.dispose();
    super.dispose();
  }

  void _activateListeners() {
    _userStream = _database.child('users').onValue.listen((event) {
      //final data = Map<String, dynamic>.from(event.snapshot.value);
      setState(() {
        totalUser = event.snapshot.value.length;
        list = event.snapshot.value.values.toList();
      });
      //print(User.fromDB(data.values));
      //print(json.decode(event.snapshot.value.values));
      //print(jsonDecode(data.values.toString()));
    }, onError: (Object o) {
      final DatabaseError error = o as DatabaseError;
      print('Error: ${error.code} ${error.message}');
    });
  }

  List userExist() {
    bool check = false;
    var email, password, s;
    for (var item in list) {
      if (item.toString().contains(
          RegExp('username: ${_usernameFieldController.text}+(,|})'))) {
        check = true;
      }
      if (check == true) {
        s = item.toString().substring(item.toString().indexOf('email: ') + 7);
        email = s.substring(0, s.indexOf(RegExp('[,}]')));
        s = item
            .toString()
            .substring(item.toString().indexOf('password: ') + 10);
        password = s.substring(0, s.indexOf(RegExp('[,}]')));
        wichOne = 'nom d\'utilisateur';
        break;
      } else if (check == false) {
        if (item
            .toString()
            .contains(RegExp('email: ${_emailFieldController.text}+(,|})'))) {
          check = true;
          wichOne = 'email';
        }
      }
    }
    //print('$check, $email, $password ${_usernameFieldController.text}');
    return [check, email, password, wichOne];
  }

  /*bool emailExist() {
    bool check = false;
    for (var item in list) {
      if (item
          .toString()
          .contains('email: ' + _emailFieldController.text + ',')) {
        check = true;
      }
    }
    //print('pwd $check');
    return check;
  }*/

  @override
  Widget build(BuildContext context) {
    final user = _database.child('users/user${totalUser + 1}');

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //SizedBox(height: 10.0),
                  /* Column(
                        children: [
                          Container(
                            //height: 200,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => SimpleDialog(
                                        title: Text('Profile picture'),
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  Text("From camera"),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.photo_camera_outlined,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(context, 1)),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text("From gallery"),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.photo_library_outlined,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context, 2),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ).then((returnVal) {
                                      if (returnVal != null) {
                                        returnVal == 1
                                            ? _pickImageFromCamera()
                                            : _pickImageFromGallery();
                                      }
                                    });
                                  },
                                  child: ClipOval(
                                    child: this._profilePic == null
                                        ? Image.asset(
                                            'images/img_avatar6.png',
                                            fit: BoxFit.cover,
                                            height: 170.0,
                                            width: 170.0,
                                          )
                                        : Image.file(
                                            this._profilePic,
                                            fit: BoxFit.cover,
                                            height: 170.0,
                                            width: 170.0,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  right: 3,
                                  bottom: 1.5,
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.teal[900],
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.photo_camera,
                                          color: Colors.white,
                                        ),
                                        tooltip: "Choose profile picture",
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                SimpleDialog(
                                              title: Text('Profile picture'),
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pop(context, 1),
                                                      child: Column(
                                                        children: [
                                                          Text("From camera"),
                                                          Icon(
                                                            Icons
                                                                .photo_camera_outlined,
                                                            color: Colors.red,
                                                          ),
                                                          //IconButton(icon: Icon(Icons.photo_camera_outlined, color: Colors.red,), onPressed: () => Navigator.pop(context, 1)),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pop(context, 2),
                                                      child: Column(
                                                        children: [
                                                          Text("From gallery"),
                                                          Icon(
                                                            Icons
                                                                .photo_library_outlined,
                                                            color: Colors.red,
                                                          ),
                                                          //IconButton(icon: Icon(Icons.photo_library_outlined, color: Colors.red,), onPressed: () => Navigator.pop(context, 2)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ).then((returnVal) {
                                            if (returnVal != null) {
                                              returnVal == 1
                                                  ? _pickImageFromCamera()
                                                  : _pickImageFromGallery();
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0), */
                  Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.redAccent[700],
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Container(
                      height: 55,
                      child: TextFormField(
                        controller: _usernameFieldController,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person, //account_circle_sharp,
                            color: Colors.blueGrey,
                          ),
                          labelText: 'Nom d\'utilisateur',
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Color(0xFF546E7A)),
                          ),
                        ),
                        validator: (value) {
                          final RegExp exp = RegExp(r'^[A-Za-z]+$');
                          if (value?.isEmpty ?? false) {
                            return "Nom d\'utilisateur requis";
                          }
                          if (!exp.hasMatch(value!)) {
                            return 'Des lettres seulement';
                          }
                          if (value.length < 5) {
                            return 'Doit contenir au moins 5 charactères';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                            color: Colors.blueGrey[600], fontSize: 18),
                      ),
                    ),
                  ),
                  //SizedBox(height: 7.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Container(
                      height: 55,
                      child: TextFormField(
                        controller: _emailFieldController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.alternate_email,
                            color: Colors.blueGrey,
                          ),
                          labelText: 'Email',
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color: Color(0xFF546E7A),
                            ),
                          ),
                        ),
                        validator: (value) {
                          final RegExp mailExp = RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                          //RegExp('[A-Za-z@.]'); '/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/'
                          if (value!.isEmpty) {
                            return "Email requis";
                          } else if (!mailExp.hasMatch(value)) {
                            return "Entrée incorrecte";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            color: Colors.blueGrey[600], fontSize: 18),
                      ),
                    ),
                  ),
                  //SizedBox(height: 7.0),
                  Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: Container(
                        height: 55,
                        child: TextFormField(
                          controller: _passwordFieldController,
                          autocorrect: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.https,
                              color: Colors.blueGrey,
                            ),
                            labelText: 'Mot de passe',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                color: Color(0xFF546E7A),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length < 8) {
                              return "Doit contenir au moins 8 charactères";
                            }
                            return null;
                          },
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          style:
                              TextStyle(color: Color(0xFF546E7A), fontSize: 18),
                        ),
                      )),
                  //SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () async {
                      try {
                        if (await ConnectivityWrapper.instance.isConnected) {
                          var _data = userExist();
                          //var _eM = emailExist();
                          if (_data[0] == true &&
                              _emailFieldController.text == _data[1]) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ce compte existe déjà'),
                              ),
                            );
                          } else if (_data[0] == true ||
                              _emailFieldController.text == _data[1]) {
                            if (_data[0] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Ce $wichOne est déjà utilisé'),
                                ),
                              );
                            }
                            if (_emailFieldController.text == _data[1]) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ce email est déjà utilisé'),
                                ),
                              );
                            }
                          } else if (_data[0] == false &&
                              _emailFieldController.text != _data[1] &&
                              _formKey.currentState!.validate()) {
                            await user /* .push() */ .set({
                              'username': _usernameFieldController.text,
                              'email': _emailFieldController.text,
                              'password': _passwordFieldController.text,
                              'amount': 10000,
                            });
                            //print('User registered successfully');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Echec. Aucun accès internet'),
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
                            color: Colors.orange[
                                900], //Color.fromRGBO(26, 53, 153, 0.5),
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Center(
                          child: Text(
                            'SIGN UP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //SizedBox(height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?  ',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 17.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 17.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
