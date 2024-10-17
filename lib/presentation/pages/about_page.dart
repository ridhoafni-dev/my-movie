import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_movie/common/constans.dart';

class AboutPage extends StatelessWidget {
  static const ROUTE_NAME = 'about-page';

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
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 82.0),
                color: kMikadoYellow,
                child: const Text(
                  "My Movie merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh project aplikasi untuk kelas Menhjadi Flutter Developer Ekspert",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              )),
            ],
          ),
          SafeArea(
              child: IconButton(
                  onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)))
        ],
      ),
    );
  }
}
