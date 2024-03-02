import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_anyfield/helper/databasehelper.dart';
import 'package:flutter_anyfield/helper/sharedpreferences.dart';
import 'package:flutter_anyfield/login_page.dart';
import 'package:flutter_anyfield/style/style.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    DataSharedPreferences().readString("username").then((value) {
      DataBaseHelper.getWhere("user", "username = '$value'").then((value) {
        _username.text = value[0]['username'];
        _name.text = value[0]['name'];
        _phone.text = value[0]['phone'];
        _email.text = value[0]['email'];
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout dari Aplikasi?"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        DataSharedPreferences().clearData();
                        Get.offAll(() => const LoginPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.power_settings_new,
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _username,
              enabled: false,
              decoration: Style().dekorasiInput(
                hint: "username",
                icon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _name,
              enabled: false,
              decoration: Style().dekorasiInput(
                hint: "nama",
                icon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _email,
              enabled: false,
              decoration: Style().dekorasiInput(
                hint: "email",
                icon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _phone,
              enabled: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: Style().dekorasiInput(
                hint: "phone",
                icon: const Icon(Icons.phone),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
