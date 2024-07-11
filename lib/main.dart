// Mengimpor paket-paket yang diperlukan untuk aplikasi Flutter
import 'dart:convert'; // Untuk konversi data JSON
import 'package:flutter/material.dart'; // Untuk membuat elemen UI
import 'package:http/http.dart' as http; // Untuk membuat permintaan HTTP
import 'package:uas_rama/home.dart'; // Mengimpor layar Home
import 'package:uas_rama/register.dart'; // Mengimpor layar Register

// Fungsi utama yang merupakan titik masuk aplikasi
void main() {
  runApp(const MyApp()); // Menjalankan widget MyApp
}

// MyApp adalah StatelessWidget, yang merupakan akar dari aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Metode build untuk membangun UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Catatan')), // Menampilkan judul di AppBar
        ),
        body: const MyProject(), // Menampilkan widget MyProject di body
      ),
    );
  }
}

// MyProject adalah StatefulWidget yang akan memiliki state
class MyProject extends StatefulWidget {
  const MyProject({super.key});

  @override
  State<MyProject> createState() => _MyProjectState();
}

// State untuk MyProject
class _MyProjectState extends State<MyProject> {

  // Menginisialisasi TextEditingController untuk mengontrol input teks
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Fungsi untuk melakukan login
  Future<void> _login() async {
    // URL endpoint untuk API login
    var url = Uri.parse("http://mobilecomputing.my.id/api_rama/catatan/login.php");
    // Mengirimkan permintaan POST ke API dengan username dan password
    var response = await http.post(url, body: {
      "username": usernameController.text,
      "password": passwordController.text
    });

    // Menguraikan respons dari server
    var datauser = jsonDecode(response.body);

    // Jika respons tidak kosong, navigasi ke halaman Home
    if (datauser != '') {
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => Home()
        ),
      );
    } else {
      print('Login Failed'); // Jika login gagal, cetak pesan ke konsol
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Menambahkan padding di sekitar child
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150), // Memberikan jarak vertikal
              // Menampilkan gambar
              Image.asset(
                'assets/note.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 80), // Memberikan jarak vertikal
              const Text(
                'Selamat Datang!', // Menampilkan teks sambutan
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20), // Memberikan jarak vertikal
              // Input untuk username
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username'
                ),
              ),
              SizedBox(height: 10), // Memberikan jarak vertikal
              // Input untuk password
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password'
                ),
              ),
              SizedBox(height: 20), // Memberikan jarak vertikal
              // Tombol untuk login
              ElevatedButton(
                  onPressed: () {
                    _login(); // Memanggil fungsi _login saat tombol ditekan
                  },
                  child: const Text('Login')
              ),
              SizedBox(height: 10), // Memberikan jarak vertikal
              // Tombol untuk navigasi ke halaman registrasi
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
