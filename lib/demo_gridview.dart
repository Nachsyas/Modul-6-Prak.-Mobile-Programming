import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Daftar Game',
      theme: ThemeData(
        // Menggunakan skema warna dari percobaan sebelumnya
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      // Judul diubah sesuai konteks tugas
      home: const MyHomePage(title: 'Daftar Game Gratis'),
      debugShowCheckedModeBanner: false,
    );
  }
}

// d. Tambahkan fungsi _tombolBaca (di luar class _MyHomePageState)
Container _tombolBaca() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    decoration: BoxDecoration(
        color: Colors.orange, borderRadius: BorderRadius.circular(15)),
    child: const Text(
      'Baca Info',
      style: TextStyle(color: Colors.white),
    ),
  );
}

// e. Tambahkan fungsi _listItem (di luar class _MyHomePageState)
Container _listItem(String url, String judul, String genre, String rilis) {
  return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10), // Diberi margin
      decoration: BoxDecoration(
        color: Colors.white, // Latar belakang item
        borderRadius: BorderRadius.circular(15),
        // Memberi sedikit bayangan agar terlihat
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              url,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              // Error handler jika gambar gagal dimuat
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                judul,
                style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Memastikan teks terlihat di Card putih
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end, // Agar tombol sejajar
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(genre, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 2),
                      Text(rilis, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  _tombolBaca() // Memanggil fungsi tombol
                ],
              )
            ]),
          ),
        ],
      ));
}

// Class dari Percobaan 3
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Variabel diubah menjadi dataGame untuk konsistensi (Tugas f)
  List dataGame = [];

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  // c. Sesuaikan fungsi _ambilData dengan API FreeToGame
  Future _ambilData() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.freetogame.com/api/games'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          // Simpan hanya 20 data pertama ke List dataGame (Tugas c & f)
          dataGame = data.take(20).toList();
        });
      } else {
        throw Exception('Gagal load data dari FreeToGame API');
      }
    } catch (e) {
      print('Error: $e');
      // Tampilkan pesan error di UI jika perlu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber, // Sesuai percobaan
        title: Text(widget.title),
      ),
      // f. Pada ListView.builder, gunakan fungsi _listItem
      body: dataGame.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Tampilkan loading
          : ListView.builder(
              itemCount: dataGame.length,
              // Memberi padding atas dan bawah untuk list
              padding: const EdgeInsets.symmetric(vertical: 10), 
              itemBuilder: (context, index) {
                return _listItem(
                  dataGame[index]['thumbnail'] ??
                      'https://via.placeholder.com/150',
                  dataGame[index]['title'] ?? 'Tidak ada judul',
                  dataGame[index]['genre'] ?? 'Tidak ada genre',
                  dataGame[index]['release_date'] ?? 'Tidak ada tanggal',
                );
              },
            ),
    );
  }
}
