import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScr(),
    );
  }
}

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
                            //
                            print('send pressed');
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
                          onPressed: () {
                            //
                            print('received pressed');
                          },
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
