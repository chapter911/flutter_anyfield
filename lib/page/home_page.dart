import 'package:flutter/material.dart';
import 'package:flutter_anyfield/helper/databasehelper.dart';
import 'package:flutter_anyfield/sub_page/lapangan_page.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _wLapangan = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Lapangan"),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: _wLapangan)),
    );
  }

  void getData() {
    DataBaseHelper.customQuery(
            "SELECT kategori FROM lapangan GROUP BY kategori")
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        _wLapangan.add(
          InkWell(
            onTap: () {
              Get.to(
                () => const LapanganPage(),
                arguments: {"kategori": value[i]['kategori']},
              );
            },
            child: Card(
              elevation: 10,
              clipBehavior: Clip.antiAlias,
              color: Colors.green[900],
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/${value[i]['kategori']}.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            value[i]['kategori'].toString().toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      setState(() {});
    });
  }
}
