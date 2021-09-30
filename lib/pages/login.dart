import 'package:supermarche_abc/pages/principal.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key? key, this.title, this.userLanguage, this.themeName})
      : super(key: key);

  final title, userLanguage, themeName;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //appBar: AppBar(title: Text(widget.title),),
        body: Container(
          color: Colors.white70,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  ClipOval(
                    //borderRadius: BorderRadius.circular(100.0),
                    child: Image.asset(
                      'images/img_avatar6.png',
                      fit: BoxFit.cover,
                      height: 160.0,
                      width: 160.0,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: TextFormField(
                      autocorrect: false,
                      //autofocus: true,
                      decoration: new InputDecoration(
                        prefixIcon: Icon(
                          Icons.account_circle_sharp,
                          color: Colors.blueGrey,
                        ),
                        labelText: 'User name',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          borderSide: new BorderSide(
                            color: Color(0xFF546E7A),
                          ),
                        ),
                      ),
                      validator: (val) {
                        if (val!.length < 0) {
                          return "Username cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Color(0xFF546E7A), fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 7.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
                        if (val!.length == 0) {
                          return "Password cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style:
                          TextStyle(color: Colors.blueGrey[600], fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Principal(
                                  userLanguage: widget.userLanguage,
                                  themeName: widget.themeName)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors
                                .green[700], //Color.fromRGBO(26, 53, 153, 0.5),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Center(
                          child: Text(
                            'NEXT',
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
      ),
    );
  }
}
