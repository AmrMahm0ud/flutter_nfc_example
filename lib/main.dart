import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

/// Global flag if NFC is avalible
bool isNfcAvalible = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for the line below
  isNfcAvalible = await NfcManager.instance.isAvailable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter NFC Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  IsoDep? isoDep;
  NfcTag? nfcTag;

  @override
  void initState() {
    NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        if (Platform.isIOS) {
          Iso7816? iso7816 = Iso7816.from(tag);
          MiFare? miFare = MiFare.from(tag);
          print(iso7816.toString());
          print(miFare.toString());
        } else {
          isoDep = IsoDep.from(tag);
          nfcTag = tag;
          setState(() {});

          // Uint8List result = await isoDep!.transceive(data: isoDep.historicalBytes!);
          // String payloadAsString = String.fromCharCodes(result);
          // print(payloadAsString);
          //
          // print(result);

          print(tag.data);
          print(tag.handle);
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [Text(nfcTag?.data.toString() ?? "")],
      ),
    );
  }
}
