import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.blueGrey[800],
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
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            // TODO: 'Column' here should be changed to 'ListView'
            // why? on dialog pop-up, keyboard shifts foreground content; bottom btns - up
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            // TODO: go to next screen to add plaintext, encrypt, etc
                          },
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
                                const HomeScrDialog(),
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
  const HomeScrDialog({super.key});

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
        'Receiver\'s phone number',
        style: GoogleFonts.orbitron(
          color: Colors.blueGrey[800],
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      content: TextField(
        keyboardType: TextInputType.phone,
        controller: myController,
        cursorColor: Colors.blueGrey,
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
                  // call api passing entered phone no as payload
                  print('phone no entered!');
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
