import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class BarcodeScan extends StatefulWidget {
  BarcodeScan({Key? key, this.title}) : super(key: key);

  String? title;
  @override
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  String textCenter = "Scan";
  String? result;
  bool visibiltyResult = false;

  Future openScan() async {
    try {
      // ignore: prefer_const_constructors
      var scanOptions = ScanOptions(
        useCamera: 0,
        android: const AndroidOptions(useAutoFocus: true),
      );
      var scanResult = await BarcodeScanner.scan(options: scanOptions);
      ScanResult scanner = scanResult;
      setState(() {
        result = scanner.rawContent;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          BarcodeScanner.scan();
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Exception:" + e.toString());
    }
  }

  void _onShareWith(BuildContext context) async {
    await Share.share(result!);
  }

  void _launchURL() async {
    bool uriControl = Uri.tryParse(result!)!.hasAbsolutePath;
    if (uriControl) {
      if (!await launch(result!)) throw 'Could not launch $result';
    } else {
      setState(() {
        visibiltyResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title!),
      ),
      body: returnedContainerOrText,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openScan(),
        label: const Text(
          "Camera",
        ),
        icon: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget get returnedContainerOrText {
    return Center(
      child: result == null
          ? Container()
          // ignore: prefer_const_constructors
          : clickHere(),
    );
  }

  Widget clickHere() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: !visibiltyResult,
          child: ElevatedButton(
            onPressed: () => _launchURL(),
            child: const Text(
              "OPEN",
              style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 40,
              ),
            ),
          ),
        ),
        Visibility(
            visible: visibiltyResult,
            child: Text(
              result!,
              style: const TextStyle(
                fontSize: 32,
              ),
            )),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _onShareWith(context),
          child: const Text(
            "Share",
            style: TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 40,
            ),
          ),
        ),
      ],
    );
  }
}
