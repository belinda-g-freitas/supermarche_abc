import 'dart:async';
import 'dart:io';
import 'dart:developer';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:supermarche_abc/pages/principal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRCodeScan extends StatefulWidget {
  QRCodeScan(
      {Key? key,
      this.totalPrice,
      this.userEmail,
      this.userName,
      this.userAmount,
      this.userId})
      : super(key: key);

  final totalPrice, userEmail, userName, userAmount, userId;
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCodeScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  IconData def1 = Icons.flip_camera_ios;
  IconData def2 = Icons.flash_on;
  bool _isOn = false;
  final _database = FirebaseDatabase.instance.reference();
  late StreamSubscription _userStream;
  late double amount = 0.0, prix = 0.0;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

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
    controller?.dispose();
    super.dispose();
  }

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } // else if (Platform.isIOS) {
    controller!.resumeCamera();
    //}
  }

  void _activateListeners() {
    _userStream = _database
        .child('users/user${widget.userId}/amount')
        .onValue
        .listen((event) {
      setState(() {
        prix = double.parse(event.snapshot.value.toString());
      });
      _userStream.cancel();
      print('PRIX:' + prix.toString());
    }, onError: (Object o) {
      final DatabaseError error = o as DatabaseError;
      print('Error: ${error.code} ${error.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    //var r = (result != null) ? Text('Barcode Type: ${describeEnum(result.format)} Data: ${result.code}') :

    return Scaffold(
      key: _scaffoldMessengerKey,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              //flex: 5,
              child: _buildQrView(context),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            child: Icon(
              def1,
              color: Colors.white,
            ),
            onPressed: () async {
              await controller?.flipCamera();
            },
          ),
          FloatingActionButton(
            child: Icon(
              def2,
              color: Colors.white,
            ),
            onPressed: () async {
              await controller?.toggleFlash();
              _isOn = (_isOn == true) ? _isOn = false : _isOn = true;
              setState(() {
                def2 = (_isOn == true) ? Icons.flash_on : Icons.flash_off;
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 280.0
        : 500.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Color(0xFFE65100),
        borderRadius: 7,
        borderLength: 30,
        borderWidth: 8,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (result?.code != null) {
        var r = result!.code.split(' ');
        var user = r[0];
        amount = double.parse(r[1]);
        //print('amount ' + amount.toString());
        var vendeur = _database.child('users/user${widget.userId}/');
        final client = _database.child('users/$user/');
        //print(widget.totalPrice.runtimeType);

        if (await ConnectivityWrapper.instance.isConnected) {
          if (double.parse(widget.totalPrice.toString()) < amount) {
            //await vendeur.onChildChanged.
            vendeur.update({
              'amount': double.parse(widget.totalPrice.toString()) + prix,
            });
            client.update({
              'amount': amount - double.parse(widget.totalPrice.toString())
            }).whenComplete(() {
              print('SUCCESS');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Principal(
                    userEmail: widget.userEmail,
                    userName: widget.userName,
                    userAmount:
                        double.parse(widget.totalPrice.toString()) + prix,
                    userScanned: r[0],
                    userId: widget.userId,
                  ),
                ),
                (route) => false,
              );
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  'Le client n\'a plus que ${amount.toString()} FCFA sur son compte',
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
            );
            //ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.white,
              duration: Duration(seconds: 4),
              content: Text(AppLocalizations.of(context)!.alreadyHaveAccount,
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
          );
        }
        //ScaffoldMessenger.of(context).removeCurrentSnackBar();
        //ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //Navigator.pop(context, result!.code);
      }
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.permissionDenied)),
      );
    }
  }
}
