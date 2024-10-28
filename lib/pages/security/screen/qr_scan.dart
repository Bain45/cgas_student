import 'package:cgas_official/pages/security/screen/qr_result.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  @override
  _QrScannerPageState createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool isProcessing = false; // Flag to control multiple scans

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
        backgroundColor: Color.fromARGB(255, 4, 20, 44),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: MobileScanner(
        onDetect: (BarcodeCapture barcodeCapture) {
          final String? rawValue = barcodeCapture.barcodes.first.rawValue;

          // Check if a valid QR code was detected and not already processing
          if (rawValue != null && !isProcessing) {
            // Check if the QR code contains the expected key
            if (rawValue.contains('key')) {
              setState(() {
                isProcessing = true; // Set flag to true
              });

              // Navigate to the result page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(result: rawValue),
                ),
              ).then((_) {
                // Reset the flag when navigating back
                setState(() {
                  isProcessing = false;
                });
              });
            } else {
              // Show an alert if the key is not found
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Invalid QR Code. Key not found.'),
                ),
              );
            }
          }
        },
      ),
    );
  }
}


