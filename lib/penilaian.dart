import 'package:flutter/material.dart';

class PenilaianPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  PenilaianPage({required this.onThemeChanged, required this.isDarkMode});

  @override
  _PenilaianPageState createState() => _PenilaianPageState();
}

class _PenilaianPageState extends State<PenilaianPage> {
  final _nilaiController = TextEditingController();
  List<int> _nilaiList = [];
  String _kategori = '';
  double? _rataRata;

  void _kelompokkanNilai() {
    setState(() {
      final nilai = int.tryParse(_nilaiController.text);
      if (nilai == null || nilai < 0 || nilai > 100) {
        _kategori = 'Nilai tidak valid';
      } else {
        _nilaiList.add(nilai);
        _rataRata = _nilaiList.reduce((a, b) => a + b) / _nilaiList.length;
        _kategori = _kelompokkanRataRata(_rataRata!);
      }
    });
  }

  String _kelompokkanRataRata(double rataRata) {
    if (rataRata >= 85) {
      return 'Kategori A';
    } else if (rataRata >= 70) {
      return 'Kategori B';
    } else if (rataRata >= 50) {
      return 'Kategori C';
    } else {
      return 'Kategori D';
    }
  }

  void _resetForm() {
    setState(() {
      _nilaiController.clear();
      _nilaiList.clear();
      _rataRata = null;
      _kategori = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penilaian Siswa'),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: (value) {
              widget.onThemeChanged(value);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nilaiController,
              decoration: InputDecoration(
                labelText: 'Masukkan Nilai',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _kelompokkanNilai,
              child: Text('Tambahkan dan Hitung Rata-Rata'),
            ),
            SizedBox(height: 16),
            if (_rataRata != null)
              Text(
                'Rata-rata: ${_rataRata!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 16),
            if (_kategori.isNotEmpty)
              Text(
                _kategori,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetForm,
              child: Text('Reset'),
              style: ElevatedButton.styleFrom(iconColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
