import 'package:flutter/material.dart';
import 'package:flutter_anyfield/sub_page/sewa_page.dart';
import 'package:get/get.dart';

class LapanganPage extends StatefulWidget {
  const LapanganPage({super.key});

  @override
  State<LapanganPage> createState() => _LapanganPageState();
}

class _LapanganPageState extends State<LapanganPage> {
  String _gambar = "app_logo.png";

  final List<Widget> _wLapangan = [];

  @override
  void initState() {
    super.initState();
    _gambar = Get.arguments['gambar'];
    for (int i = 0; i < 4; i++) {
      _wLapangan.add(
        InkWell(
          onTap: () {
            Get.to(() => const SewaPage());
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 2,
                  child: Image.asset(
                    "assets/$_gambar",
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Lapangan ${i + 1}\nJl. xxx no 123",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Lapangan"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (1),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: _wLapangan,
        ),
      ),
    );
  }
}
