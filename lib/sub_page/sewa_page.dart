import 'package:flutter/material.dart';
import 'package:flutter_anyfield/style/style.dart';
import 'package:get/get.dart';

class SewaPage extends StatefulWidget {
  const SewaPage({super.key});

  @override
  State<SewaPage> createState() => _SewaPageState();
}

class _SewaPageState extends State<SewaPage> {
  final TextEditingController _lapangan = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _tanggal = TextEditingController();
  final TextEditingController _jam = TextEditingController();

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
              enabled: false,
              decoration: Style().dekorasiInput(
                hint: "Lapangan 1",
                icon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              enabled: false,
              decoration: Style().dekorasiInput(
                hint: "Jl. ",
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
                  if (!value.isNull) {
                    _tanggal.text =
                        "${value?.year} - ${value?.month} - ${value?.day}";
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
                  if (!value.isNull) {
                    _jam.text = value.toString();
                    setState(() {});
                  }
                });
              },
              decoration: Style().dekorasiInput(
                hint: "Jam",
                icon: const Icon(Icons.timelapse),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
