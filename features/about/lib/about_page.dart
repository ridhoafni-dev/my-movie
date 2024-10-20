import 'package:flutter/material.dart';
import 'package:styles/colors.dart';

export 'about_page.dart';

class AboutPage extends StatelessWidget {

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 82.0),
                color: kRichBlack,
                child: const Text(
                  "My Movie merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh project aplikasi untuk kelas Menhjadi Flutter Developer Ekspert",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              )),
            ],
          ),
          SafeArea(
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back)))
        ],
      ),
    );
  }
}
