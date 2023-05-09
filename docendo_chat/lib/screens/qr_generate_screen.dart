import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerateScreen extends StatefulWidget {
  const QRGenerateScreen({super.key});

  @override
  State<QRGenerateScreen> createState() => _QRGenerateScreenState();
}

class _QRGenerateScreenState extends State<QRGenerateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: QrImage(
          data: (FirebaseAuth.instance.currentUser?.email).toString(),
          version: QrVersions.auto,
          foregroundColor: Colors.black,
          embeddedImage:
              const AssetImage('assets/images/docendo_ellipse_logo.png'),
          embeddedImageStyle: QrEmbeddedImageStyle(size: const Size(40, 40)),
        ),
      ),
    );
  }
}
