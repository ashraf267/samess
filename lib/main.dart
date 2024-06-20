import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueGrey[900],
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.blueGrey[300],
          selectionHandleColor: Colors.blueGrey[600],
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScr(),
    );
  }
}

// TODO: HomeScr could be a stateless widget
class HomeScr extends StatefulWidget {
  const HomeScr({super.key});

  @override
  State<HomeScr> createState() => _HomeScrState();
}

class _HomeScrState extends State<HomeScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 13,
            right: 13,
            top: 30,
          ),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height - 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 500,
                  child: Column(
                    children: [
                      Icon(
                        Icons.mail_lock_sharp,
                        color: Colors.blueGrey[300],
                        size: 90,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'SAMESS',
                        style: GoogleFonts.orbitron(
                          color: Colors.blueGrey[300],
                          fontWeight: FontWeight.w500,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const HomeScrDialog(
                            title: 'Sender\'s phone number',
                            dialogForSender: true,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                          shape: const BeveledRectangleBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Icon(
                          Icons.send_sharp,
                          color: Colors.blueGrey[400],
                          size: 45,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const HomeScrDialog(
                            title: 'Receiver\'s phone number',
                            dialogForSender: false,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                          shape: const BeveledRectangleBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Icon(
                          Icons.mark_email_unread_sharp,
                          color: Colors.blueGrey[400],
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScrDialog extends StatefulWidget {
  final String title;
  final bool dialogForSender; // true for 'Sender'; false for 'Receiver'
  const HomeScrDialog({
    super.key,
    required this.title,
    required this.dialogForSender,
  });

  @override
  State<HomeScrDialog> createState() => _HomeScrDialogState();
}

class _HomeScrDialogState extends State<HomeScrDialog> {
  final myController = TextEditingController();
  bool dialogBtnEnable = false;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[100],
      title: Text(
        widget.title,
      ),
      titleTextStyle: GoogleFonts.ubuntu(
        color: Colors.blueGrey[800],
        fontSize: 21,
        fontWeight: FontWeight.w400,
      ),
      content: TextField(
        keyboardType: TextInputType.phone,
        controller: myController,
        maxLength: 11,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueGrey,
            ),
          ),
        ),
        onChanged: (value) {
          // for docu sake, this method below also works (same as the latter)
          // if (myController.text.isNotEmpty) {
          //   setState(() {
          //     dialogBtnEnable = true;
          //   });
          // } else {
          //   setState(() {
          //     dialogBtnEnable = false;
          //   });
          // }
          if (value.isEmpty || value.length < 11) {
            setState(() {
              dialogBtnEnable = false;
            });
          } else {
            setState(() {
              dialogBtnEnable = true;
            });
          }
        },
      ),
      shape: const BeveledRectangleBorder(),
      actions: [
        TextButton(
          onPressed: (dialogBtnEnable)
              ? () {
                  Navigator.pop(context);
                  if (widget.dialogForSender) {
                    // sender btn pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SenderScr(
                          senderPhoneNo: myController.text,
                        ),
                      ),
                    );
                  } else {
                    // receiver btn pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => RecvScr(
                          recvPhoneNo: myController.text,
                        ),
                      ),
                    );
                  }
                }
              : null,
          style: TextButton.styleFrom(
            backgroundColor: Colors.blueGrey[800],
            shape: const BeveledRectangleBorder(),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: Icon(
            Icons.check_sharp,
            color: Colors.blueGrey[200],
            size: 25,
          ),
        ),
      ],
    );
  }
}

class SenderScr extends StatefulWidget {
  final String senderPhoneNo;
  const SenderScr({
    super.key,
    required this.senderPhoneNo,
  });

  @override
  State<SenderScr> createState() => _SenderScrState();
}

class _SenderScrState extends State<SenderScr> {
  bool canSend = false; // enable or disable the 'Send' btn
  bool isLoading = false; // circular loading indicator icon
  final _ptController = TextEditingController();
  final _ctController = TextEditingController();
  final _pNoController = TextEditingController();
  final _keyGenController = TextEditingController();
  IconData? lockIcon = Icons.lock_open_sharp;

  static String encKey = ""; // encryption key
  final iv = encrypt.IV.fromLength(16);

  void _encryptData() {
    String plaintext = _ptController.text;
    if (encKey.isNotEmpty) {
      final key = encrypt.Key.fromBase64(encKey);

      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      // encrypt
      final encrypted = encrypter.encrypt(plaintext, iv: iv);

      setState(() {
        _ctController.text = encrypted.base64;
      });
      print('ciphertext: ${encrypted.base64}');
      print('iv= ${iv.base64}');
    }
  }

  void mySnackbar({required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: GoogleFonts.ubuntu(
            fontSize: 17,
            color: Colors.blueGrey[50],
          ),
        ),
        backgroundColor: Colors.blueGrey[800],
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      ),
    );
  }

  // call api for sender to send msg
  Future<void> _callCreateMsg() async {
    final reqBody = {
      'sender': widget.senderPhoneNo,
      'receiver': _pNoController.text,
      'text': _ctController.text,
      'iv': iv.base64
    };
    try {
      final res = await http.post(
        Uri.parse('https://samess.onrender.com/create_message'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(reqBody),
      );

      if (res.statusCode == 200) {
        // api call successful
        print('statusCode= ${res.statusCode}');

        final resBody = jsonDecode(res.body);
        print('res body= $resBody');
      } else {
        throw Exception('failed to post created msg');
      }
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    super.initState();
    print('sender no: ${widget.senderPhoneNo}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // leading
        leading: Icon(
          Icons.person,
          color: Colors.blueGrey[200],
          size: 30,
        ),

        // title
        title: Text(
          // '09134596317',
          widget.senderPhoneNo,
        ),
        titleTextStyle: GoogleFonts.ubuntu(
          fontSize: 21,
        ),
        titleSpacing: 1,

        // actions
        // TODO: add a lock icon to encrypt; lock_open init null
        // only encrypt when the pt and key is not empty
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 6,
            ),
            child: IconButton(
              // onPressed: (alreadyEnc) ? () {
              //   // TODO: check if plaintext field and keygen field are not empty
              //   if (_ptController.text.isNotEmpty &&
              //       _keyGenController.text.isNotEmpty) {
              //     // TODO: do aes encryption
              //     print('text encrypted succ!');

              //     // TODO: change icon to lock
              //     setState(() {
              //       lockIcon = Icons.lock_outline_sharp;
              //       alreadyEnc = true;
              //       // TODO: enable 'Send' btn
              //       canSend = true;
              //     });
              //   } else {
              //     // TODO: show snackbar that says 'Add a text and generate key to encrypt'
              //     print('Add a text and generate key to encrypt');
              //   }
              // } : null,
              onPressed: () {
                // TODO: check if plaintext field and keygen field are not empty
                if (_ptController.text.isNotEmpty &&
                    _keyGenController.text.isNotEmpty &&
                    _pNoController.text.isNotEmpty) {
                  // TODO: do aes encryption
                  try {
                    _encryptData();
                    mySnackbar(content: 'Plaintext encrypted successfully!');
                    print('aes enc succ!');
                  } catch (e) {
                    print('Unable to encrypt plaintext');
                  }
                  print('text encrypted successfully!');

                  // TODO: change icon to lock
                  setState(() {
                    lockIcon = Icons.lock_outline_sharp;
                    // enable 'Send' btn
                    canSend = true;
                  });
                } else {
                  // TODO: show snackbar that says 'Add a text and generate key to encrypt'
                  mySnackbar(
                      content:
                          'Add a text, receiver number, and generate a key to encrypt');
                  print('Add a text and generate key to encrypt');
                }
              },
              icon: Icon(
                // Icons.lock_open_sharp,
                lockIcon,
              ),
              iconSize: 33,
              color: Colors.blueGrey[200],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height - 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // plaintext
              // custom label
              Text(
                'Plaintext',
                style: TextStyle(
                  color: Colors.blueGrey[600],
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 190,
                child: TextField(
                  controller: _ptController,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 2.5,
                      ),
                    ),
                    border: const UnderlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),

              // TODO: add a read-only textfield for key gen. And an icon btn beside it to init the action
              SizedBox(
                height: 125,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        // set controller to an empty str, and set state when 'keyGen' btn is pressed
                        controller: _keyGenController,
                        decoration: InputDecoration(
                          labelText: 'Generate Key',
                          labelStyle: TextStyle(
                            color: Colors.blueGrey[800],
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // kenGen icon btn
                    IconButton(
                      onPressed: () {
                        // gen random, unique key
                        String generatedKey;
                        try {
                          generatedKey = encrypt.Key.fromLength(16).base64;
                          if (generatedKey.isNotEmpty) {
                            // test: print gen key
                            print('key succ gen= $generatedKey');
                            setState(() {
                              _keyGenController.text = generatedKey;
                              // reset its field to show the newly gen key
                              encKey = generatedKey;
                            });
                          }
                        } catch (e) {
                          print('cannot gen key; $e');
                        }
                      },
                      icon: Icon(
                        Icons.key_sharp,
                        color: Colors.blueGrey[200],
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),

              // phone no
              // TODO: beside the guy, add a select from contacts icon btn, which is disabled on textfield not empty
              // TODO: do some copy and paste magic here...
              SizedBox(
                height: 125,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pNoController,
                        keyboardType: TextInputType.phone,
                        maxLength:
                            11, // TODO: change the color of this guy to be more visible
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          letterSpacing: 5,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Receiver\'s Phone Number',
                          labelStyle: TextStyle(
                            color: Colors.blueGrey[800],
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade200,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade200,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // contacts icon btn
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(
                    //     Icons.contacts_sharp,
                    //     color: Colors.blueGrey[200],
                    //     size: 30,
                    //   ),
                    // ),
                  ],
                ),
              ),

              Divider(
                color: Colors.blueGrey[800],
                height: 20,
              ),
              // ciphertext
              Text(
                'Ciphertext',
                style: TextStyle(
                  color: Colors.blueGrey[600],
                  fontSize: 18,
                ),
                ),
              SizedBox(
                height: 130,
                child: TextField(
                  controller: _ctController,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  keyboardType: TextInputType.none,
                  readOnly: true,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 2.5,
                      ),
                    ),
                    border: const UnderlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),

              // send btn
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: TextButton(
                  onPressed: (canSend)
                      ? () async {
                          if (!(widget.senderPhoneNo == _pNoController.text)) {
                            print('loading...');
                            setState(() {
                              isLoading = true;
                            });
                            await _callCreateMsg().then((value) => setState(() {
                                  isLoading = false;
                                  canSend = false;
                                }));
                            // await Future.delayed(const Duration(seconds: 5));
                            // setState(() {
                            //   isLoading = false;
                            // });
                            mySnackbar(content: 'Encrypted message sent!');
                            setState(() {
                              canSend = true;
                            });
                            print('samess: enc msg sent!');
                          } else {
                            // reject; can't send sms to self
                            mySnackbar(
                                content:
                                    'Not allowed! Can\'t send sms to self');
                          }
                        }
                      : null,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    shape: const BeveledRectangleBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    disabledForegroundColor: Colors.red,
                  ),
                  child: (isLoading)
                      ? CircularProgressIndicator(
                          color: Colors.blueGrey[100],
                        )
                      : Text(
                          'Send',
                          style: GoogleFonts.orbitron(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey[100], // disabled to 400
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecvScr extends StatefulWidget {
  final String recvPhoneNo;
  const RecvScr({
    super.key,
    required this.recvPhoneNo,
  });

  @override
  State<RecvScr> createState() => _RecvScrState();
}

class _RecvScrState extends State<RecvScr> {
  bool fetchPressed = false;
  bool isFetching = false;
  // List<Map<String, String>> fetchedMsg = [];
  dynamic fetchedMsg = [];

  void mySnackbar({required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: GoogleFonts.ubuntu(
            fontSize: 17,
            color: Colors.blueGrey[50],
          ),
        ),
        backgroundColor: Colors.blueGrey[800],
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      ),
    );
  }

  Future<void> _callGetMessage() async {
    try {
      final res = await http.get(Uri.parse(
          'https://samess.onrender.com/get_message/${widget.recvPhoneNo}'));
      if (res.statusCode == 200) {
        // api call successful
        print('statusCode= ${res.statusCode}');
        final data = jsonDecode(res.body);
        print('res= $data');

        // call setState
        setState(() {
          fetchedMsg = data;
        });
        print('fetchedMsg...');
        print('fetchedMsg= $fetchedMsg');
      } else {
        print('statusCode= ${res.statusCode}');
        throw Exception('failed to fetch messages');
      }
    } catch (e) {
      //
    }
  }

  // demo code
  final res = [
    {
      'sender': '08064290042',
      'receiver': '09134596317',
      'text': 'a12sd34fukuipfioiopoitjjkekheh'
    },
    {
      'sender': '08064290042',
      'receiver': '08064290045',
      'text': 'well well well'
    },
    {
      'sender': '08163890420',
      'receiver': '09134596317',
      'text': 'well well well'
    },
  ];
  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // leading
        leading: Icon(
          Icons.person,
          color: Colors.blueGrey[200],
          size: 30,
        ),

        // title
        title: Text(
          // '09134596317',
          widget.recvPhoneNo,
        ),
        titleTextStyle: GoogleFonts.ubuntu(
          fontSize: 21,
        ),
        titleSpacing: 1,

        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 6,
            ),
            child: IconButton(
              onPressed: () async {
                setState(() {
                  fetchPressed = true;
                  isFetching = true;
                });
                await _callGetMessage();
                setState(() {
                  isFetching = false;
                });
                print(
                    'https://samess.onrender.com/get_message/${widget.recvPhoneNo}');
              },
              icon: (isFetching)
                  ? CircularProgressIndicator(
                      color: Colors.blueGrey[100],
                    )
                  : Icon(Icons.refresh_sharp,
                      color: Colors.blueGrey[200], size: 35),
            ),
          ),
        ],
      ),
      body: (fetchPressed)
          ? ListView.builder(
              padding: const EdgeInsets.all(10),
              // TODO: replace res with fetchedMsg
              itemCount: fetchedMsg.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => DecryptMsgScr(
                                    senderNo: '${fetchedMsg[index]['sender']}',
                                    ciphertext: '${fetchedMsg[index]['text']}',
                                    encIV: '${fetchedMsg[index]['iv']}',
                                    msgID:
                                        int.parse('${fetchedMsg[index]['id']}'),
                                  )));
                    },
                    contentPadding: const EdgeInsets.only(
                      left: 10,
                      top: 5,
                      right: 10,
                      bottom: 5,
                    ),
                    tileColor: Colors.blueGrey[800],
                    leading: const Icon(
                      Icons.message_sharp,
                      size: 45,
                    ),
                    iconColor: Colors.blueGrey[100],
                    title: Text('${fetchedMsg[index]['sender']}'),
                    titleTextStyle: TextStyle(
                      color: Colors.blueGrey[50],
                      fontSize: 17,
                    ),
                    trailing: const Icon(
                      Icons.lock_outline_sharp,
                      size: 28,
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Icon(
                Icons.messenger_outline_sharp,
                size: 160,
                color: Colors.blueGrey[800],
              ),
            ),
      // body: ListView.builder(
      //     itemCount: 5,
      //     itemBuilder: (context, i) {
      //       return const ListTile(
      //         title: Text('item[s]'),
      //       );
      //     }),
      // body:  Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      //   child: Column(
      //     children: [
      //       ListTile(
      //         contentPadding: const EdgeInsets.only(left: 10, top: 5, right: 0, bottom: 5,),
      //         tileColor: Colors.blueGrey[800],
      //         leading: const Icon(Icons.message_sharp, size: 45,),
      //         iconColor: Colors.blueGrey[100],
      //         title: const Text('09039418988'),
      //         titleTextStyle:  TextStyle(
      //           color: Colors.blueGrey[50],
      //           fontSize: 17,
      //         ),
      //         trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.lock_outline_sharp, size: 28,)),
      //       ),
      //       const SizedBox(height: 5,),
      //       ListTile(
      //         contentPadding: const EdgeInsets.only(left: 10, top: 5, right: 0, bottom: 5,),
      //         tileColor: Colors.blueGrey[800],
      //         leading: const Icon(Icons.message_sharp, size: 45,),
      //         iconColor: Colors.blueGrey[100],
      //         title: const Text('09039418988'),
      //         titleTextStyle:  TextStyle(
      //           color: Colors.blueGrey[50],
      //           fontSize: 17,
      //         ),
      //         trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.lock_outline_sharp, size: 28,)),
      //       ),
      //       const SizedBox(height: 5,),
      //       ListTile(
      //         contentPadding: const EdgeInsets.only(left: 10, top: 5, right: 0, bottom: 5,),
      //         tileColor: Colors.blueGrey[800],
      //         leading: const Icon(Icons.message_sharp, size: 45,),
      //         iconColor: Colors.blueGrey[100],
      //         title: const Text('09039418988'),
      //         titleTextStyle:  TextStyle(
      //           color: Colors.blueGrey[50],
      //           fontSize: 17,
      //         ),
      //         trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.lock_outline_sharp, size: 28,)),
      //       ),
      //     ],
      //   ),
      // ),
      // body: ListView.builder(itemCount: res.length, itemBuilder: (context, index) {
      //   return ListTile(
      //     title: Text('${res[index]['sender']}'),
      //   );
      // }),
    );
  }
}

class DecryptMsgScr extends StatefulWidget {
  final String senderNo;
  final String ciphertext;
  final String encIV;
  final int msgID;

  const DecryptMsgScr(
      {super.key,
      required this.senderNo,
      required this.ciphertext,
      required this.encIV,
      required this.msgID});

  @override
  State<DecryptMsgScr> createState() => _DecryptMsgScrState();
}

class _DecryptMsgScrState extends State<DecryptMsgScr> {
  final _keyController = TextEditingController();
  final _ptController = TextEditingController();
  IconData? lockIcon = Icons.lock_outline_sharp;

  void mySnackbar({required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: GoogleFonts.ubuntu(
            fontSize: 17,
            color: Colors.blueGrey[50],
          ),
        ),
        backgroundColor: Colors.blueGrey[800],
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      ),
    );
  }

  void _decryptData() {
    final decrypter = encrypt.Encrypter(encrypt.AES(
      encrypt.Key.fromBase64(_keyController.text),
      mode: encrypt.AESMode.cbc,
    ));

    // decrypt
    final decrypted = decrypter.decrypt(
      encrypt.Encrypted.fromBase64(widget.ciphertext),
      iv: encrypt.IV.fromBase64(widget.encIV),
    );

    setState(() {
      _ptController.text = decrypted;
    });
    print('decrypted= $decrypted');
  }

  Future<void> _updateMsgStatus() async {
    final res = await http.get(
        Uri.parse('https://samess.onrender.com/status_seen/${widget.msgID}'));

    if (res.statusCode == 200) {
      // api call succ; msg status updated
      print('msgStatus statusCode= ${res.statusCode}');
    } else {
      throw Exception('Cannot update message status after decryption!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // leading
        leading: IconButton(
          onPressed: () {
            return Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.blueGrey[200],
            size: 30,
          ),
        ),

        // title
        title: Text(widget.senderNo),
        titleTextStyle: GoogleFonts.ubuntu(
          fontSize: 21,
        ),
        titleSpacing: 1,

        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 6,
            ),
            child: IconButton(
              onPressed: () async {
                if (_keyController.text.isNotEmpty) {
                  // do decryption
                  print('decrypting...');
                  _decryptData();
                  print('ct decrypted succ!');
                  // reset lock icon
                  setState(() {
                    lockIcon = Icons.lock_open_sharp;
                  });
                  if (_ptController.text.isNotEmpty) {
                    // call api to update msg status to seen
                    await _updateMsgStatus();
                    mySnackbar(content: 'Message status: seen :)');
                  }
                } else {
                  mySnackbar(content: 'Add key to decrypt!');
                }
              },
              icon: Icon(
                lockIcon,
              ),
              iconSize: 33,
              color: Colors.blueGrey[200],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height - 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // input pre-agreed key to decrypt
              SizedBox(
                height: 125,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _keyController,
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Decryption Key',
                          labelStyle: TextStyle(
                            color: Colors.blueGrey[800],
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade200,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade200,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ciphertext
              Text(
                'Ciphertext',
                style: TextStyle(
                  color: Colors.blueGrey[600],
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 150,
                child: TextField(
                  // TODO: add controller
                  controller: TextEditingController(text: widget.ciphertext),
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  keyboardType: TextInputType.none,
                  readOnly: true,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    focusedBorder: const UnderlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 2.5,
                      ),
                    ),
                    border: const UnderlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.blueGrey[800],
                height: 15,
              ),
              // decrypted text; plaintext
              Text(
                'Plaintext',
                style: TextStyle(
                  color: Colors.blueGrey[600],
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 300,
                child: TextField(
                  controller: _ptController,
                  keyboardType: TextInputType.none,
                  readOnly: true,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueGrey[100],
                    focusedBorder: const UnderlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 2.5,
                      ),
                    ),
                    border: const UnderlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),

              // // TODO: add a read-only textfield for key gen. And an icon btn beside it to init the action
              // SizedBox(
              //   height: 125,
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: TextField(
              //           onTapOutside: (event) =>
              //               FocusScope.of(context).unfocus(),
              //           keyboardType: TextInputType.none,
              //           readOnly: true,
              //           style: const TextStyle(
              //             fontSize: 17,
              //             color: Colors.white,
              //           ),
              //           // set controller to an empty str, and set state when 'keyGen' btn is pressed
              //           controller: _keyGenController,
              //           decoration: InputDecoration(
              //             enabledBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.zero,
              //               borderSide: BorderSide(
              //                 color: Colors.blueGrey.shade800,
              //               ),
              //             ),
              //             focusedBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.zero,
              //               borderSide: BorderSide(
              //                 color: Colors.blueGrey.shade800,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       // kenGen icon btn
              //       IconButton(
              //         onPressed: () {
              //           // gen random, unique key
              //           String generatedKey;
              //           try {
              //             generatedKey = encrypt.Key.fromLength(16).base64;
              //             if (generatedKey.isNotEmpty) {
              //               // test: print gen key
              //               print('key succ gen= $generatedKey');
              //               setState(() {
              //                 _keyGenController.text = generatedKey;
              //                 // reset its field to show the newly gen key
              //                 encKey = generatedKey;
              //               });
              //             }
              //           } catch (e) {
              //             print('cannot gen key; $e');
              //           }
              //         },
              //         icon: Icon(
              //           Icons.key_sharp,
              //           color: Colors.blueGrey[200],
              //           size: 30,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Divider(
              //   color: Colors.blueGrey[800],
              //   height: 20,
              // ),
              // // ciphertext
              // SizedBox(
              //   height: 130,
              //   child: TextField(
              //     controller: _ctController,
              //     onTapOutside: (event) => FocusScope.of(context).unfocus(),
              //     keyboardType: TextInputType.none,
              //     readOnly: true,
              //     maxLines: null,
              //     expands: true,
              //     style: const TextStyle(
              //       fontSize: 17,
              //       color: Colors.black,
              //     ),
              //     decoration: InputDecoration(
              //       filled: true,
              //       fillColor: Colors.blueGrey[100],
              //       focusedBorder: const UnderlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.blueGrey,
              //           width: 2.5,
              //         ),
              //       ),
              //       border: const UnderlineInputBorder(
              //         borderRadius: BorderRadius.zero,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
