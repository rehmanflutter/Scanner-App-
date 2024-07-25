import 'dart:async';
import 'package:document_scanner/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:flutter_sliding_toast/flutter_sliding_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:motion/motion.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ScanDocumentScreen extends StatefulWidget {
  ScanDocumentScreen({Key? key}) : super(key: key);

  @override
  State<ScanDocumentScreen> createState() => _ScanDocumentScreenState();
}

class _ScanDocumentScreenState extends State<ScanDocumentScreen> {
  final controllertext = TextEditingController();

  dynamic _scannedDocuments = 'Failed';
  Future<void> scanDocument() async {
    dynamic scannedDocuments;
    try {
      scannedDocuments = await FlutterDocScanner().getScanDocuments() ??
          'Unknown platform documents';
    } on PlatformException {
      scannedDocuments = 'Failed';
    }
    print(scannedDocuments.toString());
    if (!mounted) return;
    setState(() {
      _scannedDocuments = scannedDocuments;
    });
  }

  // Future<void> scanDocumentUri() async {
  //   dynamic scannedDocuments;
  //   try {
  //     scannedDocuments = await FlutterDocScanner().getScanDocumentsUri() ??
  //         'Unknown platform documents';
  //   } on PlatformException {
  //     scannedDocuments = 'Failed to get scanned documents.';
  //   }
  //   print(scannedDocuments.toString());
  //   if (!mounted) return;
  //   setState(() {
  //     _scannedDocuments = scannedDocuments;
  //   });
  // }

  Future<void> saveScannedDocument() async {
    if (_scannedDocuments != null &&
        _scannedDocuments is Map &&
        _scannedDocuments.containsKey('pdfUri')) {
      try {
        // Request permission to save to the gallery
        var status = await Permission.storage.request();
        if (status.isGranted) {
          String pdfUri = _scannedDocuments['pdfUri'];
          File pdfFile = File(pdfUri.replaceFirst('file://', ''));
          Uint8List bytes = await pdfFile.readAsBytes();

          final result = await ImageGallerySaver.saveFile(
            pdfFile.path,
            name: controllertext.text.isNotEmpty
                ? controllertext.text
                : "ScannedDocumentRehman",
            isReturnPathOfIOS: true,
          );
          print("File saved to gallery: $result");
        } else {
          print("Permission denied to save to gallery.");
        }
      } catch (e) {
        print("Error saving file: $e");
      }
    } else {
      print("No scanned document available to save.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xffDFAC5D),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 80,
          backgroundColor: Color(0xffDFAC5D),
          title: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset(Images.diamant)),
                  Icon(
                    Icons.keyboard_double_arrow_left,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GradientText(
                    'Document Scanner',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                    gradientType: GradientType.radial,
                    radius: 4.5,
                    colors: [
                      Colors.amber,
                      Colors.red,
                      Color.fromARGB(255, 232, 213, 246),

                      // Colors.white,
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.keyboard_double_arrow_right,
                    color: Colors.blue,
                  ),
                  SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset(Images.diamant)),
                ],
              ),
            ),
          ),
        ),

        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Images.shado), fit: BoxFit.cover),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: //_scannedDocuments != null ||
                  _scannedDocuments != 'Failed'
                      ? Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  // color: Colors.amber,
                                  image: DecorationImage(
                                      image: AssetImage(Images.circular),
                                      fit: BoxFit.fill)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: Image.asset(Images.diamant)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 2,
                                        ),
                                        SvgPicture.asset(
                                          Images.pdfPic,
                                          height: 100,
                                          width: 100,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'My DS.pdf',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Container(
                                              width: 220,
                                              //  color: Colors.amber,
                                              child: Text(
                                                ' PDF file you requested. You can download the file by clicking the button below',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            GestureDetector(
                              onTap: () {
                                showPopUp(context);
                                //   saveScannedDocument();
                              },
                              child: Motion(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  width: 260,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      //  begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xffe0c3fc),
                                        Color(0xff8ec5fc),
                                        // Color(0xff243949),
                                        // Color(0xff517fa4),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: GradientText(
                                      'Save Document to Gallery',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500),
                                      gradientType: GradientType.radial,
                                      radius: 4.5,
                                      colors: [
                                        //  Color.fromARGB(255, 232, 213, 246),
                                        // Colors.white,
                                        // Colors.white,
                                        Colors.green,
                                        Colors.red,
                                        // Color.fromARGB(255, 232, 213, 246),
                                        // Colors.white,
                                      ],
                                    ),

                                    // Text("Save Document to Gallery")
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                toastBox();
                                // scanDocument();
                                // controllertext.clear();
                                _scannedDocuments = 'Failed';
                              },
                              child: Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    //  begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xffed6ea0),
                                      Color(0xffec8c69),
                                      // Color(0xff243949),
                                      // Color(0xff517fa4),
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GradientText(
                                      'Scan New Documents',
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500),
                                      gradientType: GradientType.radial,
                                      radius: 4.5,
                                      colors: [
                                        Colors.white,
                                        Colors.white,
                                        // Colors.green,
                                        // Colors.red,
                                        // Color.fromARGB(255, 232, 213, 246),
                                        // Colors.white,
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )

                      //

                      //

                      //
                      //      1st Show
                      //
                      //

                      : Column(
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            Image.asset(Images.searching),
                            SizedBox(
                              height: 20,
                            ),
                            // Text("No Documents Scanned"),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                scanDocument();
                              },
                              child: Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    //  begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xffed6ea0),
                                      Color(0xffec8c69),
                                      // Color(0xff243949),
                                      // Color(0xff517fa4),
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GradientText(
                                      'Scan New Documents',
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500),
                                      gradientType: GradientType.radial,
                                      radius: 4.5,
                                      colors: [
                                        //  Color.fromARGB(255, 232, 213, 246),
                                        Colors.white,
                                        Colors.white,
                                        // Colors.green,
                                        // Colors.red,
                                        // Color.fromARGB(255, 232, 213, 246),
                                        // Colors.white,
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ),
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom: 16.0),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 8.0),
        //         child: ElevatedButton(
        //           onPressed: () {
        //             scanDocument();
        //           },
        //           child: const Text("Scan Documents"),
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 8.0),
        //         child: Motion(
        //           child: ElevatedButton(
        //             onPressed: () {
        //               scanDocumentUri();
        //             },
        //             child: const Text("Get Scan Documents URI"),
        //           ),
        //         ),
        //       ),
        //       // Padding(
        //       //   padding: const EdgeInsets.symmetric(vertical: 8.0),
        //       //   child: ElevatedButton(
        //       //     onPressed: () {
        //       //       saveScannedDocument();
        //       //     },
        //       //     child: const Text("Save Document to Gallery"),
        //       //   ),
        //       // ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  ///
  ///
  ///
  ///   Toast  Show
  ///
  ///
  void toastBox() {
    SlidingToast.show(
      context,
      title: const Text(
        "Hi there!  PDF file you requested. 😎 download the file Successful",
        style: TextStyle(),
      ),
      trailing: const Icon(Icons.person, color: Colors.deepPurple),
      toastSetting: const ToastSetting(
        animationDuration: Duration(seconds: 1),
        displayDuration: Duration(seconds: 2),
        toastStartPosition: ToastPosition.bottom,
        toastAlignment: Alignment.topCenter,
      ),
    );
  }

  ///
  ///
  ///
  ///   Bottom Sheet  Show
  ///
  ///
  void showPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: SvgPicture.asset(Images.pdfPic)),
              SizedBox(
                height: 15,
              ),

              SizedBox(
                height: 10,
              ),
              Text(
                'Enter a Name for this file',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade400),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400)),
                child: TextField(
                  controller: controllertext,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add pdf name',
                      prefixText: '    '

                      ///  prefixIcon: Icon(Icons.file_open_outlined)
                      ),
                ),
              ),
              Image.asset(Images.Line1),
              SizedBox(
                height: 15,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  toastBox();
                  saveScannedDocument();
                  // scanDocument();
                  // controllertext.clear();
                  // _scannedDocuments = 'Failed';
                  Timer(
                    Duration(seconds: 4),
                    () {
                      setState(() {});
                      _scannedDocuments = 'Failed';
                    },
                  );
                },
                child: Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        //  begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffed6ea0),
                          Color(0xffec8c69),
                          // Color(0xff243949),
                          // Color(0xff517fa4),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),

              //  Divider(color: Colors.grey.,)
            ],
          ),
        );
      },
    );
  }
}
                                //   saveScannedDocument();
