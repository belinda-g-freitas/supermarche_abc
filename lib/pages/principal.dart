//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:supermarche_abc/pages/qrCodeScan.dart';

class Principal extends StatefulWidget {
  Principal({Key? key, this.userEmail, this.userName, this.userAmount, this.userScanned, this.userId})
      : super(key: key);

  final userEmail, userName, userAmount, userScanned, userId;
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final _formKey = GlobalKey<FormState>();
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //final RegExp _pattern = RegExp('[0-9.]');
  late TextEditingController _amountFieldController = TextEditingController();
  late String qrScanResult;

  void _customDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,//Color(0xFF0D47A1),
            width: 2.25,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          children: [
            ListTile(title: Text('Valider l\'achat du client', style: TextStyle(fontSize: 18),)),
            Form(
              key: _formKey,
              child: TextFormField(
                //autofocus: true,
                style: TextStyle(fontSize: 20),
                controller: _amountFieldController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: Colors.red,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  labelText: 'Entrez le montant total à payer',
                  labelStyle: TextStyle(fontSize: 18),
                ),
                inputFormatters: [
                  //FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                ],
                validator: (value) {
                  if (num.parse(value!) < 1/*  || num.parse(value) > 10000 */) {
                    return 'Montant incorrect';
                  }
                  /* if (num.parse(value) > num.parse(widget.userAmount)) {
                    return 'Le client n\'a plus que ${widget.userAmount} FCFA sur son compte.';
                  } */
                  return null;
                },
              ),
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Annuler', style: TextStyle(fontSize: 18, color: Colors.blue),)),
                TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    /* qrScanResult = await  */ Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRCodeScan(
                          totalPrice: _amountFieldController.text,
                          userAmount: widget.userAmount,
                          userEmail: widget.userEmail,
                          userName: widget.userName,
                          userId: widget.userId,
                        ),
                      ),
                    );
                    //print('*****'+qrScanResult);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Entrez un nombre valide'),
                      ),
                    );
                  }
                },
                child: Text('Scanner', style: TextStyle(fontSize: 18, color: Colors.red),)),
              ],
            ),
            //SizedBox(height: 25)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final _kTabs = <Tab>[
      Tab(text: 'TAB n°1'),
      Tab(text: 'TAB n°2'),
      Tab(text: 'TAB n°3'),
    ];
    final _kTabPages = <Widget>[
      Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Text('TAB 1'),
      ),
      Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Text('TAB 2'),
      ),
      Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Text('TAB 3'),
      ),
    ];

    return DefaultTabController(
      length: _kTabs.length,
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          //key: this._scaffoldKey,
          appBar: AppBar(
            title: Text(/* MyApp.appName */ 'ABC Supermaket'),
            //backgroundColor: Colors.green[700],
            //leading: BackButton(),
            //flexibleSpace: FlexibleSpaceBar(title: Text('Dazzle'),),
            actions: [
              IconButton(
                icon: Icon(Icons.qr_code, color: Colors.white),
                tooltip: 'Afficher votre code QR',
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => QRCodeScan(),),);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => SimpleDialog(
                            title: Center(child: Text('Votre QR code')),
                            children: [
                              QrImage(
                                data: 'user'+widget.userId.toString() + ' ' + widget.userAmount,
                                version: QrVersions.auto,
                                size: 250,
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 0.0),
                              )
                            ],
                          ));
                },
              ),
              /*PopupMenuButton(
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
              ),*/
            ],
            /*bottom: TabBar(
              isScrollable: true,
              tabs: _kTabs,
              indicatorWeight: 3,
              indicatorColor: Colors.yellow,
            ),*/
          ),
          body: Container(),
          /* TabBarView(
            children: _kTabPages,
          ), */
          drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Colors.blueGrey //Colors.green[700],
                        ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /*Column(
                      children: [
                        ClipOval(
                          //borderRadius: BorderRadius.circular(50.0),
                          child: Image.asset(
                            'images/img_avatar3.png',
                            fit: BoxFit.cover,
                            height: 90.0,
                            width: 90.0,
                          ),
                        ),
                      ],
                    ),*/
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 7),
                        Text(
                          widget.userEmail,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Solde total: ' + widget.userAmount.toString() + ' FCFA',
                          style: TextStyle(fontSize: 18, color: Colors.white)
                        )
                      ],
                    )
                  ],
                ),
              ),
              (widget.userName == 'supermarche')
                ? ListTile(
                  leading: Icon(Icons.qr_code_2),
                  title:
                      Text('Scanner le code QR', style: TextStyle(fontSize: 15)),
                  onTap: () => _customDialog(),
                )
                : ListTile(leading: Icon(Icons.sentiment_satisfied_alt, color: Colors.red,), title: Text('BIENVENUE', style: TextStyle(fontSize: 18),)),
              /* ListTile(
                //leading: Icon(Icons.equalizer),
                title: Text('Page 2', style: TextStyle(fontSize: 15)),
                onTap: () {},
              ),
              ListTile(
                //leading: Icon(Icons.alarm),
                title: Text('Page 3', style: TextStyle(fontSize: 15)),
                onTap: () {},
              ), */
            ]),
          ),
          floatingActionButton: (widget.userName == 'supermarche')
            ? FloatingActionButton(
              child: Icon(Icons.qr_code_2, color: Colors.white),
              tooltip: 'Scanner le code QR de l\'utilisateur',
              onPressed: () => _customDialog(),
              //backgroundColor: Colors.green[700],
            )
            : null,
        ),
      ),
    );
  }
}
