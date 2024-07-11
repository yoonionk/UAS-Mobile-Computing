// Mengimpor paket-paket yang diperlukan untuk aplikasi Flutter
import 'dart:convert'; // Untuk konversi data JSON
import 'package:flutter/material.dart'; // Untuk membuat elemen UI
import 'package:http/http.dart' as http; // Untuk membuat permintaan HTTP
import 'package:uas_rama/Home.dart'; // Mengimpor layar Home

// Widget Add adalah StatefulWidget yang akan memiliki state
class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState(); // Membuat state untuk Add
}

// State untuk Add
class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk form
  // Inisialisasi field
  var title = TextEditingController(); // Mengontrol input teks untuk judul
  var content = TextEditingController(); // Mengontrol input teks untuk konten

  // Fungsi untuk mengirim data ke API
  Future _onSubmit() async {
    try {
      final response = await http.post(
        Uri.parse("http://mobilecomputing.my.id/api_rama/catatan/create.php"), // URL endpoint untuk API create
        body: {
          "judul": title.text, // Mengirim judul
          "content": content.text, // Mengirim konten
        },
      );
      var data = jsonDecode(response.body); // Mengurai respons JSON
      print(data["message"]); // Mencetak pesan dari respons
      // Menampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Note berhasil disimpan"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      await Future.delayed(Duration(seconds: 2)); // Menunggu selama 2 detik
      Navigator.of(context).popUntil((route) => route.isFirst); // Menutup semua layar dan kembali ke layar pertama
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home()) // Menavigasi ke layar Home
      );
    } catch (e) {
      print(e); // Menangani kesalahan
      // Menampilkan snackbar kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Note Baru"), // Judul AppBar
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Kunci form
          child: Container(
            padding: EdgeInsets.all(20.0), // Padding di sekitar kontainer
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Penjajaran ke kiri
              children: [
                Text(
                  'Judul',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5), // Memberikan jarak vertikal
                TextFormField(
                  controller: title, // Mengontrol input teks untuk judul
                  decoration: InputDecoration(
                    hintText: "Masukkan Judul Note", // Teks petunjuk
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0), // Bentuk tepi border
                    ),
                    fillColor: Colors.white, // Warna latar belakang
                    filled: true,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Judul Note Wajib di Isi!'; // Validasi input kosong
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20), // Memberikan jarak vertikal
                Text(
                  'Content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5), // Memberikan jarak vertikal
                TextFormField(
                  controller: content, // Mengontrol input teks untuk konten
                  keyboardType: TextInputType.multiline, // Tipe input multiline
                  minLines: 5, // Jumlah baris minimal
                  maxLines: null, // Jumlah baris maksimal tidak terbatas
                  decoration: InputDecoration(
                    hintText: 'Masukkan Konten', // Teks petunjuk
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0), // Bentuk tepi border
                    ),
                    fillColor: Colors.white, // Warna latar belakang
                    filled: true,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan Konten!'; // Validasi input kosong
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15), // Memberikan jarak vertikal
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey, // Warna latar belakang tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Bentuk tepi tombol
                    ),
                  ),
                  child: Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white), // Warna teks tombol
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _onSubmit(); // Memanggil fungsi _onSubmit saat tombol ditekan
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
