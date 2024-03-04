import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_anyfield/helper/databasehelper.dart';
import 'package:flutter_anyfield/helper/sharedpreferences.dart';
import 'package:flutter_anyfield/page/dashboard_page.dart';
import 'package:flutter_anyfield/style/style.dart';
import 'package:get/get.dart';

class SewaPage extends StatefulWidget {
  const SewaPage({super.key});

  @override
  State<SewaPage> createState() => _SewaPageState();
}

class _SewaPageState extends State<SewaPage> {
  var _idLapangan = 0;
  var username = "";
  final TextEditingController _lapangan = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _tanggal = TextEditingController();
  final TextEditingController _jam = TextEditingController();
  final TextEditingController _durasi = TextEditingController();

  List<String> items = ['BANK BRI', 'BANK BCA', 'BANK MANDIRI', 'BANK BNI'];
  String _selectedItem = 'BANK BRI';

  @override
  void initState() {
    super.initState();
    DataSharedPreferences().readString("username").then((value) {
      username = value!;
    });
    DataBaseHelper.getWhere("lapangan", "id_lapangan = ${Get.arguments}")
        .then((value) {
      _idLapangan = value[0]['id_lapangan'];
      _lapangan.text = value[0]['nama_lapangan'];
      _alamat.text = value[0]['alamat'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sewa Lapangan"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _lapangan,
              enabled: false,
              decoration: Style().dekorasiInput(
                hint: "Nama Lapangan",
                icon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _alamat,
              enabled: false,
              decoration: Style().dekorasiInput(
                hint: "Alamat",
                icon: const Icon(Icons.gps_fixed),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _tanggal,
              onTap: () {
                showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025))
                    .then((value) {
                  if (value != null) {
                    var tahun =
                        value.year < 10 ? "0${value.year}" : "${value.year}";
                    var bulan =
                        value.month < 10 ? "0${value.month}" : "${value.month}";
                    var tanggal =
                        value.day < 10 ? "0${value.day}" : "${value.day}";
                    _tanggal.text = "$tahun-$bulan-$tanggal";
                    setState(() {});
                  }
                });
              },
              decoration: Style().dekorasiInput(
                hint: "Tanggal",
                icon: const Icon(Icons.calendar_month),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _jam,
              onTap: () {
                showTimePicker(context: context, initialTime: TimeOfDay.now())
                    .then((value) {
                  if (value != null) {
                    var jam = value.hour < 10
                        ? "0${value.hour}:00"
                        : "${value.hour}:00";
                    _jam.text = jam;
                    setState(() {});
                  }
                });
              },
              decoration: Style().dekorasiInput(
                hint: "Jam",
                icon: const Icon(Icons.timelapse),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _durasi,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: Style().dekorasiInput(
                hint: "Durasi (jam)",
                icon: const Icon(Icons.timelapse),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedItem,
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedItem = val.toString();
                  });
                },
                hint: const Text('Select an item'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Center(
                child: Text("Sewa Lapangan?"),
              ),
              content: Text(
                  "Harap transfer ke:\nrekening : ${Random().nextInt(4294967295)}"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_tanggal.text.isEmpty ||
                        _jam.text.isEmpty ||
                        _durasi.text.isEmpty) {
                      Get.snackbar("Maaf", "Harap Lengkapi Data Anda");
                    } else {
                      var jam = int.parse(_jam.text.replaceAll(":00", ""));
                      DataBaseHelper.getWhere("booking",
                              "id_lapangan = $_idLapangan AND tanggal = ${_tanggal.text} AND '$jam' BETWEEN jam_mulai AND jam_akhir")
                          .then((value) {
                        if (value.isNotEmpty) {
                          Get.snackbar(
                            "Maaf",
                            "Jadwal yang anda Pilih Bentrok dengan jadwal Lain",
                          );
                        } else {
                          DataBaseHelper.insert("booking", {
                            "id_lapangan": _idLapangan,
                            "tanggal": _tanggal.text,
                            "jam_mulai": jam,
                            "jam_akhir": jam + int.parse(_durasi.text),
                            "createdby": username
                          });
                          Get.offAll(() => const DashboardPage());
                        }
                      });
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Sewa"),
                ),
              ],
            ),
          );
        },
        child: const Icon(
          Icons.save,
        ),
      ),
    );
  }
}
