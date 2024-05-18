import 'dart:html';

import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:partner_admin_portal/widgets/result_screen.dart';


const bgColor = Color(0xfffafafa);
class BarcodeScannerWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AppBarcodeScannerWidgetState();
  }
}

class _AppBarcodeScannerWidgetState extends State<BarcodeScannerWidget> {

  bool isScanCompleted = false;

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Place the QR code in the area",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Scanning will be started automatically",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String code = await FlutterBarcodeScanner.scanBarcode(
                      '#ff6666', // Your desired color for the scan overlay
                      'Cancel', // The text for the cancel button
                      true, // Use the flash feature
                      ScanMode.QR, // Specify the scan mode (QR code)
                    );

                    if (code != '-1') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                            code: code,
                            closeScreen: closeScreen,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Scan QR Code'),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Restaurant Details",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}