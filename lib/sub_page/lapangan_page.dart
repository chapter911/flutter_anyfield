import 'package:flutter/material.dart';
import 'package:flutter_anyfield/helper/databasehelper.dart';
import 'package:flutter_anyfield/sub_page/sewa_page.dart';
import 'package:get/get.dart';

class LapanganPage extends StatefulWidget {
  const LapanganPage({super.key});

  @override
  State<LapanganPage> createState() => _LapanganPageState();
}

class _LapanganPageState extends State<LapanganPage> {
  var _kategori = "";
  final List<Widget> _wLapangan = [];

  @override
  void initState() {
    super.initState();
    _kategori = Get.arguments['kategori'];
    DataBaseHelper.getWhere("lapangan", "kategori = '$_kategori'")
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        _wLapangan.add(InkWell(
          onTap: () {
            Get.to(() => const SewaPage(), arguments: value[i]['id_lapangan']);
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 10,
            child: Row(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${value[i]['nama_lapangan']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("${value[i]['alamat']}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Lapangan"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: _wLapangan),
      ),
    );
  }
}
