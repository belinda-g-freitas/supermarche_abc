import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supermarche_abc/pages/login.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  Register({Key? key, this.themeName, this.userLanguage}) : super(key: key);

  final userLanguage, themeName;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var _profilePic;
  final _picker = ImagePicker();

  Future _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() => _profilePic = File(pickedFile!.path));
  }

  Future _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() => _profilePic = File(pickedFile!.path));
  }

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Color(0xFF21BFBD),
        //appBar: AppBar(title: Text(widget.title),),
        body: Container(
          color: Colors.white70,
          width: MediaQuery.of(context).size.width,
          //child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30.0),
                Column(
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
                                color: Colors.teal[300],
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
                SizedBox(height: 20.0),
                Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.redAccent[700],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25.0),
                Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Container(
                      height: 55,
                      child: TextFormField(
                        autocorrect: false,
                        decoration: new InputDecoration(
                          prefixIcon: Icon(
                            Icons.account_circle_sharp,
                            color: Colors.blueGrey,
                          ),
                          labelText: 'Username',
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            borderSide:
                                new BorderSide(color: Color(0xFF546E7A)),
                          ),
                        ),
                        validator: (val) {
                          if (val!.length < 5) {
                            return "Must contains at least 5 characters";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        keyboardType: TextInputType.name,
                        style: new TextStyle(
                            color: Colors.blueGrey[600], fontSize: 18),
                      ),
                    )),
                SizedBox(height: 7.0),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Container(
                    height: 55,
                    child: TextFormField(
                      //autofocus: true,
                      decoration: new InputDecoration(
                        prefixIcon: Icon(
                          Icons.alternate_email,
                          color: Colors.blueGrey,
                        ),
                        labelText: 'Email address',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          borderSide: new BorderSide(
                            color: Color(0xFF546E7A),
                          ),
                        ),
                      ),
                      validator: (val) {
                        final RegExp mailExp = RegExp('[A-Za-z@.]');
                        if (val!.isEmpty) {
                          return "Email is required";
                        } else if (val.length < 12) {
                          return "Incorrect input";
                        } else if (!mailExp.hasMatch(val)) {
                          return "Incorrect input";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                          color: Colors.blueGrey[600], fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 7.0),
                Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Container(
                      height: 55,
                      child: TextFormField(
                        autocorrect: false,
                        decoration: new InputDecoration(
                            prefixIcon: Icon(
                              Icons.https,
                              color: Colors.blueGrey,
                            ),
                            labelText: 'Password',
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                                borderSide:
                                    new BorderSide(color: Color(0xFF546E7A)))),
                        validator: (val) {
                          if (val!.length < 8) {
                            return "Must contains at least 8 characters";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        style: new TextStyle(
                            color: Color(0xFF546E7A), fontSize: 18),
                      ),
                    )),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors
                            .orange[900], //Color.fromRGBO(26, 53, 153, 0.5),
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
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Divider(thickness: 17, color: Colors.black38,),
                    Text(
                      '-------------------------------   or login with   -------------------------------',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    //Divider(thickness: 7, color: Colors.black38,),
                  ],
                ),
                SizedBox(height: 3.0),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      color: Colors.blue[700],
                      child: FaIcon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.white,
                        size: 15,
                      ),
                      onPressed: () {},
                      elevation: 2,
                      shape: CircleBorder(),
                    ),
                    MaterialButton(
                      color: Colors.red[700],
                      child: FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                        size: 14,
                      ),
                      onPressed: () {},
                      elevation: 2,
                      shape: CircleBorder(),
                    ),
                  ],
                ),
                SizedBox(height: 2.0),
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
                                builder: (context) => Login(
                                    userLanguage: widget.userLanguage,
                                    themeName: widget.themeName)));
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
                SizedBox(height: 20.0),
              ],
            ),
          ),
          //),
        ),
      ),
    );
  }
}
