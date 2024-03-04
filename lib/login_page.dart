import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_anyfield/helper/databasehelper.dart';
import 'package:flutter_anyfield/page/dashboard_page.dart';
import 'package:flutter_anyfield/helper/sharedpreferences.dart';
import 'package:flutter_anyfield/register_page.dart';
import 'package:flutter_anyfield/style/style.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _showLogin = false;

  @override
  void initState() {
    super.initState();
    cekLapangan();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      DataSharedPreferences().checkData("username").then((value) {
        if (value) {
          Get.offAll(() => const DashboardPage());
        } else {
          _showLogin = true;
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/app_logo.png',
              scale: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "ANYFIELD",
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            _showLogin
                ? SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _username,
                          decoration: Style().dekorasiInput(
                            hint: "username",
                            icon: const Icon(Icons.person),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _password,
                          obscureText: true,
                          decoration: Style().dekorasiInput(
                            hint: "pasword",
                            icon: const Icon(Icons.vpn_key),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              DataBaseHelper.getWhere("user",
                                      "username = '${_username.text}' AND password = '${_password.text}'")
                                  .then((value) {
                                if (value.isNotEmpty) {
                                  DataSharedPreferences()
                                      .saveString("username", _username.text);
                                  Get.offAll(() => const DashboardPage());
                                } else {
                                  Get.snackbar(
                                      "Maaf", "username / password anda salah");
                                }
                              });
                            },
                            child: const Text("LOGIN"),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const RegisterPage());
                          },
                          child: const Text(
                            "Tidak Punya Akun?\nDaftar",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : const CupertinoActivityIndicator()
          ],
        ),
      ),
    );
  }

  void cekLapangan() {
    DataBaseHelper.getAll("lapangan").then((value) {
      if (value.isEmpty) {
        String query = """
            INSERT INTO lapangan (nama_lapangan, kategori, alamat, nomor_telepon, url_gambar) VALUES
            ('Stadion Utama Gelora Bung Karno', 'bola', 'Jl. Pintu Senayan Utama, Gelora Bung Karno, Senayan, Kota Jakarta Selatan', '+62 21 5790 0900', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Stadion_Gelora_Bung_Karno.jpg/1200px-Stadion_Gelora_Bung_Karno.jpg'),
            ('Stadion Gelora Sriwijaya', 'bola', 'Jl. Jakabaring, Palembang, Sumatera Selatan', '+62 711 360 222', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Stadion_Gelora_Sriwijaya.jpg/1200px-Stadion_Gelora_Sriwijaya.jpg'),
            ('Stadion Si Jalak Harupat', 'bola', 'Jl. Soreang-Pasir Koja, Soreang, Kabupaten Bandung, Jawa Barat', '+62 22 594 0400', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Stadion_Si_Jalak_Harupat_2013.jpg/1200px-Stadion_Si_Jalak_Harupat_2013.jpg'),
            ('Stadion Manahan', 'bola', 'Jl. Adi Sucipto No.1, Manahan, Banjarsari, Surakarta, Jawa Tengah', '+62 271 734 111', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Stadion_Manahan_2019.jpg/1200px-Stadion_Manahan_2019.jpg'),
            ('Planet Futsal', 'futsal', 'Jl. R.A. Kartini No.12, Kebayoran Baru, Kota Jakarta Selatan', '+62 21 727 9898', 'https://www.planetfutsal.com/wp-content/uploads/2018/03/Planet-Futsal-Kebon-Melati-Jakarta.jpg'),
            ('Arena Futsal Depok', 'futsal', 'Jl. Margonda Raya No.10, Depok, Jawa Barat', '+62 21 7788 9999', 'https://www.arenasoccer.co.id/wp-content/uploads/2019/07/Arena-Futsal-Depok-1.jpg'),
            ('Galaxy Tirtamas Club', 'futsal', 'Jl. Boulevard Barat Raya FY 2/1, Kelapa Gading Barat, Kelapa Gading, Kota Jakarta Utara', '+62 21 458 59999', 'https://www.galaxytirtamasclub.com/wp-content/uploads/2018/01/Galaxy-Tirtamas-Club-Futsal-Field.jpg'),
            ('Futsal Court Senayan City', 'futsal', 'Jl. Asia Afrika No.8, Senayan, Kota Jakarta Selatan', '+62 21 579 59999', 'https://www.scbd.co.id/wp-content/uploads/2018/05/Futsal-Court-Senayan-City.jpg'),
            ('Pusdiklat PBSI Cipayung', 'badminton', 'Jl. Raya Hankam No.1, Cipayung, Jakarta Timur', '+62 21 840 0666', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Pusdiklat_PBSI_Cipayung.jpg/1200px-Pusdiklat_PBSI_Cipayung.jpg'),
            ('GOR Bulutangkis Sudirman', 'badminton', 'Jl. Senayan, Gelora Bung Karno, Senayan, Kota Jakarta Selatan', '+62 21 579 0090', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Stadion_Gelora_Bung_Karno.jpg/1200px-Stadion_Gelora_Bung_Karno.jpg'),
            ('GOR Badminton Djarum', 'badminton', 'Jl. Jend. Basuki Rachmat No.1, Kudus, Jawa Tengah', '+62 291 438 888', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/GOR_Djarum_Kudus.jpg/1200px-GOR_Djarum_Kudus.jpg'),
            ('Stadion Badminton PBSI Candra Wijaya', 'badminton', 'Jl. Pajajaran No.17, Bandung, Jawa Barat', '+62 22 250 0888', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Stadion_Badminton_Candra_Wijaya.jpg/1200px-Stadion_Badminton_Candra_Wijaya.jpg'),
            ('Gelora Tennis Senayan', 'tenis', 'Jl. Pintu Senayan Utama, Gelora Bung Karno, Senayan, Kota Jakarta Selatan', '+62 21 579 0090', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Stadion_Gelora_Bung_Karno.jpg/1200px-Stadion_Gelora_Bung_Karno.jpg'),
            ('Tennis Court Hotel Mulia Senayan', 'tenis', 'Jl. Asia Afrika No.8, Senayan, Kota Jakarta Selatan', '+62 21 579 59999', 'https://www.scbd.co.id/wp-content/uploads/2018/05/Tennis-Court-Hotel-Mulia-Senayan.jpg'),
            ('Lapangan Tenis Rawamangun', 'tenis', 'Jl. Pemuda No.17, Rawamangun, Pulo Gadung, Kota Jakarta Timur', '+62 21 470 6666', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Lapangan_Tenis_Rawamangun.jpg/1200px-Lapangan_Tenis_Rawamangun.jpg'),
            ('Tennis Center Club Med Bali', 'tenis', 'Jl. Nusa Dua No.1, Benoa, Kuta Selatan, Kabupaten Badung, Bali', '+62 361 771 111', 'https://www.clubmed.co.id/wp-content/uploads/2018/01/Tennis-Center-Club-Med-Bali.jpg')
          """;
        DataBaseHelper.customQuery(query);
      }
    });
  }
}
