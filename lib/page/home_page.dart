import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_anyfield/sub_page/lapangan_page.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _lapangan = [
    "Sepak Bola",
    "Futsal",
    "Badminton",
    "Tenis",
    "Basket"
  ];

  final List<String> _gambar = [
    "bola.jpg",
    "futsal.jpg",
    "badminton.jpg",
    "tennis.jpeg",
    "basket.jpg"
  ];

  final List<Widget> _wLapangan = [];

  @override
  void initState() {
    super.initState();
    getLapangan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (1 / 0.7),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: _wLapangan,
        ),
      ),
    );
  }

  void getLapangan() {
    for (int i = 0; i < _lapangan.length; i++) {
      _wLapangan.add(
        InkWell(
          onTap: () {
            Get.to(
              () => const LapanganPage(),
              arguments: {
                "lapangan": _lapangan[i],
                "gambar": _gambar[i],
              },
            );
          },
          child: Card(
            elevation: 10,
            clipBehavior: Clip.antiAlias,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 2,
                    child: Image.asset(
                      "assets/${_gambar[i]}",
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Expanded(
                      child: Container(
                        color: Colors.green[800],
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            _lapangan[i],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    setState(() {});
  }
}
