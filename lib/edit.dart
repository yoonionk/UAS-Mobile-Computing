// Mengimpor paket-paket yang diperlukan untuk aplikasi Flutter
import 'dart:convert'; // Untuk konversi data JSON
import 'package:flutter/material.dart'; // Untuk membuat elemen UI
import 'package:http/http.dart' as http; // Untuk membuat permintaan HTTP
import 'package:uas_rama/Home.dart'; // Mengimpor layar Home

// Widget Edit adalah StatefulWidget yang akan memiliki state
class Edit extends StatefulWidget {
  Edit({required this.id}); // Konstruktor untuk widget Edit yang menerima id
  String id; // Deklarasi variabel id
  @override
  State<Edit> createState() => _EditState(); // Membuat state untuk Edit
}

// State untuk Edit
class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk form
  // Inisialisasi field
  var title = TextEditingController(); // Mengontrol input teks untuk judul
  var content = TextEditingController(); // Mengontrol input teks untuk konten

  @override
  void initState() {
    super.initState();
    _getData(); // Mendapatkan data saat state diinisialisasi
  }

  // Fungsi untuk mendapatkan data dari API
  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          "http://mobilecomputing.my.id/api_rama/catatan/detail.php?id='${widget.id}'"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Mengurai respons JSON
        setState(() {
          title = TextEditingController(text: data['Judul']); // Mengatur teks kontrol judul
          content = TextEditingController(text: data['Content']); // Mengatur teks kontrol konten
        });
      }
    } catch (e) {
      print(e); // Menangani kesalahan
    }
  }

  // Fungsi untuk mengupdate data
  Future _onUpdate() async {
    try {
      final response = await http.post(
        Uri.parse("http://mobilecomputing.my.id/api_rama/catatan/update.php"),
        body: {
          "id": widget.id, // Mengirim id
          "judul": title.text, // Mengirim judul
          "content": content.text, // Mengirim konten
        },
      );
      var data = jsonDecode(response.body); // Mengurai respons JSON
      print(data["message"]); // Mencetak pesan dari respons
      // Menampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Note berhasil diupdate"),
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
          content: Text("Terjadi kesalahan saat mengupdate note"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fungsi untuk menghapus data
  Future _onDelete() async {
    try {
      final response = await http.post(
        Uri.parse("http://mobilecomputing.my.id/api_rama/catatan/delete.php"),
        body: {
          "id": widget.id, // Mengirim id
        },
      );
      var data = jsonDecode(response.body); // Mengurai respons JSON
      print(data["message"]); // Mencetak pesan dari respons
      // Menampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Note berhasil dihapus"),
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
          content: Text("Terjadi kesalahan saat menghapus note"),
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
        title: Text("Edit Data"), // Judul AppBar
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                // Menampilkan dialog konfirmasi penghapusan
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('Yakin ingin menghapus note?'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Icon(Icons.cancel),
                          onPressed: () => Navigator.of(context).pop(), // Menutup dialog
                        ),
                        ElevatedButton(
                          child: Icon(Icons.check_circle),
                          onPressed: () => _onDelete(), // Memanggil fungsi penghapusan
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete), // Ikon delete
            ),
          )
        ],
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
                      return 'Judul Harus di Isi!'; // Validasi input kosong
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
                    hintText: 'Masukkan Content', // Teks petunjuk
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
                      return 'Content Wajib di Isi!'; // Validasi input kosong
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
                    "Edit Notes",
                    style: TextStyle(color: Colors.white), // Warna teks tombol
                  ),
                  onPressed: () {
                    // Validasi form
                    if (_formKey.currentState!.validate()) {
                      _onUpdate(); // Memanggil fungsi _onUpdate saat tombol ditekan
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
