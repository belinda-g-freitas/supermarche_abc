import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:supermarche_abc/main.dart';
import 'package:flutter/material.dart';
import 'package:supermarche_abc/pages/qr_code_scan.dart';
//import 'package:supermarche_abc/settings/settings.dart';
//import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Principal extends StatefulWidget {
  Principal({Key? key, this.userLanguage, this.themeName}) : super(key: key);

  final userLanguage, themeName;
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    final _kTabs = <Tab>[
      Tab(text: 'TAB n°1'),
      Tab(text: 'TAB n°2'),
      Tab(text: 'TAB n°3'),
    ];
    final _kTabPages = <Widget>[
      Center(
        child: Text('TAB 1'),
      ),
      Center(
        child: Text('TAB 2'),
      ),
      Center(
        child: Text('TAB 3'),
      ),
    ];

    return DefaultTabController(
      length: _kTabs.length,
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          appBar: AppBar(
            title: Text(MyApp.appName),
            //backgroundColor: Colors.green[700],
            //leading: BackButton(),
            //flexibleSpace: FlexibleSpaceBar(title: Text('Dazzle'),),
            actions: [
              IconButton(
                icon: Icon(Icons.qr_code, color: Colors.white),
                tooltip: 'Scanner le code QR de l\'utilisateur',
                onPressed: () => QRCodeScan(),
              ),
              PopupMenuButton(
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<dynamic>>[
                  PopupMenuItem(
                    //value: 'Option 1",
                    child: Text('Option 1'),
                  ),
                  PopupMenuItem(
                    child: Text('Option 2'),
                  ),
                  PopupMenuItem(
                    child: Text('Option 3'),
                  ),
                  PopupMenuItem(
                    child: Text('Option 4'),
                  )
                ],
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: _kTabs,
              indicatorWeight: 3,
              indicatorColor: Colors.yellow,
            ),
          ),
          body: TabBarView(
            children: _kTabPages,
          ),
          drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green[700],
                ),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: ClipOval(
                        //borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'images/img_avatar3.png',
                          fit: BoxFit.cover,
                          height: 90.0,
                          width: 90.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                //leading: Icon(Icons.palette),
                title: Text('Settings', style: TextStyle(fontSize: 15)),
                onTap: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(
                        userLanguage: widget.userLanguage.toString(),
                        themeName: widget.themeName.toString(),
                      ),
                    ),
                  );*/
                },
              ),
              ListTile(
                //leading: Icon(Icons.equalizer),
                title: Text('Page 2', style: TextStyle(fontSize: 15)),
                onTap: () {},
              ),
              ListTile(
                //leading: Icon(Icons.alarm),
                title: Text('Page 3', style: TextStyle(fontSize: 15)),
                onTap: () {},
              ),
            ]),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Settings(
                        userLanguage: widget.userLanguage.toString(),
                        themeName: widget.themeName.toString(),
                      ),
                ),
              ),*/
            },
            backgroundColor: Colors.green[700],
            child: Icon(Icons.settings),
          ),
        ),
      ),
    );
  }
}
