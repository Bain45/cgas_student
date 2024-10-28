import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatelessWidget {
  final String documentId;
  final String action;

  QrCodePage({required this.documentId, required this.action});

  @override
  Widget build(BuildContext context) {
    const String key = "cgas@2024";
    final String qrData = '{"documentId": "$documentId", "key": "$key", "action": "$action"}';

    // Create a QrPainter directly
    final QrPainter qrPainter = QrPainter(
      data: qrData,
      version: QrVersions.auto,
      gapless: true,
      dataModuleStyle: QrDataModuleStyle(
        color: Colors.black,
      )
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_rounded, color: const Color.fromARGB(255, 196, 171, 255),)),
        backgroundColor: Color.fromARGB(255, 4, 20, 44),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            
            colors: [Color.fromARGB(255, 4, 20, 44), const Color.fromARGB(255, 69, 36, 128)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                    'Scan to $action',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 196, 171, 255),
                    ),
                  ),
                  SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: CustomPaint(
                size: Size(200, 200),
                painter: qrPainter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
