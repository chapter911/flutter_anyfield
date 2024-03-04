import 'package:flutter/material.dart';
import 'package:flutter_anyfield/helper/databasehelper.dart';
import 'package:flutter_anyfield/helper/sharedpreferences.dart';
import 'package:flutter_anyfield/style/style.dart';
import 'package:get/get.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _tanggal = TextEditingController();

  List<Widget> _history = [];

  List<String> items = ['Semua', 'Badminton', 'Bola', 'Futsal', 'Tenis'];
  String _selectedItem = 'Semua';
  var username = "";

  @override
  void initState() {
    super.initState();
    _tanggal.text = DateTime.now().toString().substring(0, 10);
    DataSharedPreferences().readString("username").then((value) {
      username = value!;
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pesanan Lapangan"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _tanggal,
              readOnly: true,
              onTap: () {
                showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025))
                    .then((value) {
                  if (value != null) {
                    _tanggal.text = value.toString().substring(0, 10);
                    getData();
                  }
                });
              },
              decoration: Style().dekorasiInput(
                hint: "Tanggal",
                icon: const Icon(
                  Icons.calendar_month,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: double.maxFinite,
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
                  getData();
                },
                hint: const Text('Select an item'),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              child: Column(
                children: _history,
              ),
            )
          ],
        ),
      ),
    );
  }

  void getData() {
    _history = [];
    setState(() {});
    var where = "";
    if (_selectedItem != "Semua") {
      where =
          " AND LOWER(lapangan.kategori) = '${_selectedItem.toLowerCase()}' ";
    }
    DataBaseHelper.customQuery("""
            SELECT
              lapangan.nama_lapangan,
              lapangan.kategori,
              booking.id,
              booking.tanggal,
              booking.jam_mulai,
              booking.jam_akhir,
              booking.createdby
            FROM booking
            LEFT JOIN lapangan
            ON booking.id_lapangan = lapangan.id_lapangan
            WHERE booking.tanggal = '${_tanggal.text}' $where
            """).then((value) {
      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          _history.add(
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 10,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          if (value[i]['createdby'] == username) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Hapus Pesanan Anda?"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey),
                                    child: const Text("Batal"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      DataBaseHelper.deleteWhere(
                                              "booking", "id=?", value[i]['id'])
                                          .then((value) {
                                        _history = [];
                                        setState(() {});
                                        getData();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: const Text("Hapus"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            Get.snackbar("Maaf",
                                "Anda tidak dapat menghapus pesanan orang lain");
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Image.asset(
                      "assets/${value[i]['kategori']}.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 4,
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value[i]['nama_lapangan'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${value[i]['tanggal']} ${value[i]['jam_mulai'] < 10 ? '0' : ''}${value[i]['jam_mulai']}:00 s/d ${value[i]['jam_akhir'] < 10 ? '0' : ''}${value[i]['jam_akhir']}:00",
                          ),
                          Text("Dipesan oleh : ${value[i]['createdby']}"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        setState(() {});
      } else {
        Get.snackbar(
            "Maaf", "Tidak Ada Pesanan Lapangan Pada tanggal yang di pilih");
        setState(() {});
      }
    });
  }
}
