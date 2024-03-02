import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_anyfield/helper/databasehelper.dart';
import 'package:flutter_anyfield/login_page.dart';
import 'package:flutter_anyfield/style/style.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmation = TextEditingController();

  @override
  void initState() {
    super.initState();
    _username.text = "tes";
    _name.text = "tes";
    _phone.text = "081234567890";
    _email.text = "tes@gmail.com";
    _password.text = "12345";
    _confirmation.text = "12345";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _username,
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
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: Style().dekorasiInput(
                hint: "phone",
                icon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: Style().dekorasiInput(
                hint: "password",
                icon: const Icon(Icons.vpn_key),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _confirmation,
              obscureText: true,
              decoration: Style().dekorasiInput(
                hint: "konfirmasi password",
                icon: const Icon(Icons.vpn_key),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_username.text.isEmpty ||
              _name.text.isEmpty ||
              _email.text.isEmpty ||
              !_phone.text.isPhoneNumber) {
            Get.snackbar("Maaf", "Harap Lengkapi Data Anda");
          } else if (_password.text.length < 5) {
            Get.snackbar("Maaf", "Minimal Password 5 Karakter");
          } else if (_password.text != _confirmation.text) {
            Get.snackbar("Maaf", "Password dan konfirmasi tidak sama");
          } else {
            DataBaseHelper.getWhere("user", "username = '${_username.text}'")
                .then((value) {
              if (value.isEmpty) {
                DataBaseHelper.insert("user", {
                  "username": _username.text,
                  "password": _password.text,
                  "name": _name.text,
                  "phone": _phone.text,
                  "email": _email.text
                }).then((value) {
                  Get.snackbar("Berhasil", "User Telah berhasil di daftarkan");
                  Get.offAll(() => const LoginPage());
                });
              } else {
                Get.snackbar("Maaf", "username telah digunakan");
              }
            });
          }
        },
        child: const Icon(
          Icons.save,
        ),
      ),
    );
  }
}
