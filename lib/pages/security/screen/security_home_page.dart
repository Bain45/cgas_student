import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SecurityHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String scanResult = await FlutterBarcodeScanner.scanBarcode(
              '#ff6666', // Line color
              'Cancel',  // Cancel button text
              true,      // Show flash icon
              ScanMode.QR,
            );
            
            if (scanResult != '-1') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanResultPage(scanResult: scanResult),
                ),
              );
            }
          },
          child: Text('Open QR Code Scanner'),
        ),
      ),
    );
  }
}

class ScanResultPage extends StatelessWidget {
  final String scanResult;

  ScanResultPage({required this.scanResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Result'),
      ),
      body: Center(
        child: Text(
          'Scan Result: $scanResult',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
