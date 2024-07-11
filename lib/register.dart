// Mengimpor paket-paket yang diperlukan untuk aplikasi Flutter
import 'dart:convert'; // Untuk konversi data JSON
import 'package:flutter/material.dart'; // Untuk membuat elemen UI
import 'package:http/http.dart' as http; // Untuk membuat permintaan HTTP
import 'package:uas_rama/main.dart'; // Mengimpor layar utama

// Widget Register adalah StatefulWidget yang akan memiliki state
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState(); // Membuat state untuk Register
}

// State untuk Register
class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk form
  final usernameController = TextEditingController(); // Mengontrol input teks untuk username
  final passwordController = TextEditingController(); // Mengontrol input teks untuk password
  final confirmPasswordController = TextEditingController(); // Mengontrol input teks untuk konfirmasi password

  // Fungsi untuk mendaftarkan akun baru
  Future<void> _register() async {
    // Validasi jika password dan konfirmasi password tidak cocok
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password salah')),
      );
      return;
    }

    try {
      // Mengirim permintaan HTTP POST untuk mendaftarkan akun
      final response = await http.post(
        Uri.parse("http://mobilecomputing.my.id/api_rama/catatan/register.php"),
        body: {
          "username": usernameController.text,
          "password": passwordController.text,
        },
      );

      var data = jsonDecode(response.body); // Mengurai respons JSON
      if (data == 'success') {
        // Menampilkan dialog sukses
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registrasi Berhasil'),
              content: Text('Akun Anda telah berhasil dibuat.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()), // Navigasi ke layar utama
                    );
                  },
                ),
              ],
            );
          },
        );
      } else if (data == 'error') {
        // Menampilkan snackbar gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi gagal. Silakan coba lagi.')),
        );
      } else if (data == 'data_not_complete') {
        // Menampilkan snackbar data tidak lengkap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data tidak lengkap. Mohon isi semua field.')),
        );
      } else {
        // Menampilkan snackbar kesalahan tidak diketahui
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan yang tidak diketahui.')),
        );
      }
    } catch (e) {
      print(e); // Menangani kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan koneksi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'), // Judul AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding di sekitar kontainer
          child: Form(
            key: _formKey, // Kunci form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Penjajaran elemen ke kiri dan kanan
              children: [
                TextFormField(
                  controller: usernameController, // Mengontrol input teks untuk username
                  decoration: InputDecoration(labelText: 'Username'), // Label teks untuk username
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username wajib di isi'; // Validasi input kosong
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16), // Memberikan jarak vertikal
                TextFormField(
                  controller: passwordController, // Mengontrol input teks untuk password
                  decoration: InputDecoration(labelText: 'Password'), // Label teks untuk password
                  obscureText: true, // Menyembunyikan teks input untuk password
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password harus di isi'; // Validasi input kosong
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16), // Memberikan jarak vertikal
                TextFormField(
                  controller: confirmPasswordController, // Mengontrol input teks untuk konfirmasi password
                  decoration: InputDecoration(labelText: 'Konfirmasi Password'), // Label teks untuk konfirmasi password
                  obscureText: true, // Menyembunyikan teks input untuk konfirmasi password
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon konfirmasi password'; // Validasi input kosong
                    }
                    if (value != passwordController.text) {
                      return 'Password tidak cocok'; // Validasi jika password tidak cocok
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24), // Memberikan jarak vertikal
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _register(); // Memanggil fungsi _register saat tombol ditekan
                    }
                  },
                  child: Text('Register'), // Teks pada tombol
                ),
                SizedBox(height: 16), // Memberikan jarak vertikal
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Menavigasi kembali ke layar sebelumnya
                  },
                  child: Text('Sudah punya akun? Login'), // Teks pada tombol
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
