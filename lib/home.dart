// Mengimpor paket-paket yang diperlukan untuk aplikasi Flutter
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Untuk tata letak grid terhuyung-huyung
import 'package:http/http.dart' as http; // Untuk membuat permintaan HTTP
import 'dart:convert'; // Untuk konversi data JSON
import 'add.dart'; // Mengimpor layar tambah catatan
import 'edit.dart'; // Mengimpor layar edit catatan
import 'package:uas_rama/main.dart'; // Mengimpor layar utama

// Fungsi utama yang merupakan titik masuk aplikasi
main() {
  runApp(Home()); // Menjalankan widget Home
}

// Home adalah StatefulWidget yang akan memiliki state
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState(); // Membuat state untuk Home
}

// State untuk Home
class HomeState extends State<Home> {
  List _get = []; // Menyimpan data yang diambil dari API
  final _lightColors = [ // Warna-warna untuk kartu
    Colors.cyan.shade300,
    Colors.brown.shade300,
    Colors.pink.shade300,
    Colors.blue.shade300,
    Colors.pinkAccent.shade100,
    Colors.tealAccent.shade100
  ];

  @override
  void initState() {
    super.initState();
    _getData(); // Mengambil data saat inisialisasi
  }

  // Fungsi untuk mengambil data dari API
  Future<void> _getData() async {
    try {
      final response = await http.get(Uri.parse(
        "http://mobilecomputing.my.id/api_rama/catatan/list.php",
      ));
      if (response.statusCode == 200) { // Jika respons sukses
        final data = jsonDecode(response.body); // Mengurai data JSON
        setState(() {
          _get = data; // Menyimpan data dalam state
        });
      }
    } catch (e) {
      print(e); // Menangani kesalahan
    }
  }

  // Fungsi untuk me-refresh data
  Future<void> _refreshData() async {
    await _getData();
  }

  // Fungsi untuk menangani tindakan kembali (back) di perangkat
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apakah Anda yakin?'),
        content: Text('Apakah Anda ingin keluar dari aplikasi?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyProject()),
                    (Route<dynamic> route) => false,
              );
            },
            child: Text('Ya'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Menangani tindakan kembali
      child: Scaffold(
        appBar: AppBar(
          title: Text('Catatan'), // Judul AppBar
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData, // Fungsi untuk refresh data
          child: _get.isNotEmpty
              ? MasonryGridView.count(
            crossAxisCount: 2, // Jumlah kolom
            itemCount: _get.length, // Jumlah item
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Edit(id: _get[index]['id']),
                    ),
                  );
                },
                child: Card(
                  color: _lightColors[index % _lightColors.length], // Warna kartu
                  child: Container(
                    constraints:
                    BoxConstraints(minHeight: (index % 2 + 1) * 85), // Tinggi minimum kartu
                    padding: EdgeInsets.all(15), // Padding di dalam kartu
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Penjajaran ke kiri
                      children: [
                        Text(
                          '${_get[index]['date']}', // Menampilkan tanggal
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 10), // Memberikan jarak vertikal
                        Text(
                          "" + '${_get[index]['judul']}', // Menampilkan judul
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "" + '${_get[index]['content']}', // Menampilkan konten
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
              : Center(
            child: Text(
              "Data Kosong", // Pesan jika data kosong
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          child: Icon(Icons.add), // Ikon tambah
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Add()), // Navigasi ke layar tambah catatan
            );
          },
        ),
      ),
    );
  }
}
