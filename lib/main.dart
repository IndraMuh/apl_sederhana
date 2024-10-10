import 'package:flutter/material.dart';

void main() {
  runApp(PenilaianSiswaApp());
}

class PenilaianSiswaApp extends StatefulWidget {
  @override
  _PenilaianSiswaAppState createState() => _PenilaianSiswaAppState();
}

class _PenilaianSiswaAppState extends State<PenilaianSiswaApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Penilaian Siswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: _themeMode,
      home: PenilaianPage(
        onThemeChanged: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class PenilaianPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  PenilaianPage({required this.onThemeChanged, required this.isDarkMode});

  @override
  _PenilaianPageState createState() => _PenilaianPageState();
}

class _PenilaianPageState extends State<PenilaianPage> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _siswaList = [];
  List<TextEditingController> _namaControllers = [];
  List<TextEditingController> _mapel1Controllers = [];
  List<TextEditingController> _mapel2Controllers = [];
  List<TextEditingController> _mapel3Controllers = [];
  List<String> _errorMessages = [];

  void _tambahSiswa() {
    setState(() {
      _siswaList.add({
        'nama': '',
        'mapel1': 0,
        'mapel2': 0,
        'mapel3': 0,
        'rataRata': 0.0,
        'kategori': '',
        'error': '',
      });
      _namaControllers.add(TextEditingController());
      _mapel1Controllers.add(TextEditingController());
      _mapel2Controllers.add(TextEditingController());
      _mapel3Controllers.add(TextEditingController());
      _errorMessages.add('');
    });
  }

  void _hitungRataRataSiswa(int index) {
    final mapel1 = int.tryParse(_mapel1Controllers[index].text);
    final mapel2 = int.tryParse(_mapel2Controllers[index].text);
    final mapel3 = int.tryParse(_mapel2Controllers[index].text);

    if (mapel1 == null ||
        mapel2 == null ||
        mapel3 == null ||
        mapel1 < 0 ||
        mapel1 > 100 ||
        mapel2 < 0 ||
        mapel2 > 100 ||
        mapel3 < 0 ||
        mapel3 > 100) {
      _siswaList[index]['rataRata'] = 0.0;
      _siswaList[index]['kategori'] = '';
      _siswaList[index]['error'] =
          'Nilai tidak valid. Pastikan nilai antara 0 hingga 100.';
      return;
    } else {
      _siswaList[index]['error'] = '';
    }

    _siswaList[index]['mapel1'] = mapel1;
    _siswaList[index]['mapel2'] = mapel2;
    _siswaList[index]['mapel3'] = mapel3;

    final rataRata = (mapel1 + mapel2 + mapel3) / 3;
    _siswaList[index]['rataRata'] = rataRata;
    _siswaList[index]['kategori'] = _kelompokkanRataRata(rataRata);
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

  double _hitungRataRataSeluruhSiswa() {
    if (_siswaList.isEmpty) return 0.0;
    final totalRataRata =
        _siswaList.fold(0.0, (sum, siswa) => sum + siswa['rataRata']);
    return totalRataRata / _siswaList.length;
  }

  void _resetForm() {
    setState(() {
      _siswaList.clear();
      _namaControllers.clear();
      _mapel1Controllers.clear();
      _mapel2Controllers.clear();
      _mapel3Controllers.clear();
      _errorMessages.clear();
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ...List.generate(_siswaList.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Siswa ${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _namaControllers[index],
                      decoration: InputDecoration(labelText: 'Nama Siswa'),
                      onChanged: (value) {
                        _siswaList[index]['nama'] = value;
                      },
                    ),
                    TextField(
                      controller: _mapel1Controllers[index],
                      decoration: InputDecoration(labelText: 'Nilai Mapel 1'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _hitungRataRataSiswa(index);
                      },
                    ),
                    TextField(
                      controller: _mapel2Controllers[index],
                      decoration: InputDecoration(labelText: 'Nilai Mapel 2'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _hitungRataRataSiswa(index);
                      },
                    ),
                    TextField(
                      controller: _mapel3Controllers[index],
                      decoration: InputDecoration(labelText: 'Nilai Mapel 3'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _hitungRataRataSiswa(index);
                      },
                    ),
                    SizedBox(height: 8),
                    if (_siswaList[index]['error'].isNotEmpty)
                      Text(
                        _siswaList[index]['error'],
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    if (_siswaList[index]['rataRata'] > 0) ...[
                      Text(
                        'Rata-rata: ${_siswaList[index]['rataRata'].toStringAsFixed(2)} - ${_siswaList[index]['kategori']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Nilai Mapel 1: ${_siswaList[index]['mapel1']} - Kategori: ${_kelompokkanRataRata(_siswaList[index]['mapel1'].toDouble())}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Nilai Mapel 2: ${_siswaList[index]['mapel2']} - Kategori: ${_kelompokkanRataRata(_siswaList[index]['mapel2'].toDouble())}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Nilai Mapel 3: ${_siswaList[index]['mapel3']} - Kategori: ${_kelompokkanRataRata(_siswaList[index]['mapel3'].toDouble())}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                    Divider(),
                  ],
                );
              }),
              ElevatedButton(
                onPressed: _tambahSiswa,
                child: Text('Tambah Siswa'),
              ),
              SizedBox(height: 16),
              // Menampilkan Nama Siswa, Kategori, dan Rata-rata Sebelum Rata-rata Seluruh Siswa
              if (_siswaList.isNotEmpty) ...[
                Text('Daftar Siswa dan Rata-rata:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ..._siswaList.map((siswa) {
                  if (siswa['rataRata'] > 0) {
                    return Text(
                      '${siswa['nama']} - ${siswa['kategori']} - Rata-rata: ${siswa['rataRata'].toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    );
                  }
                  return SizedBox.shrink();
                }).toList(),
              ],
              SizedBox(height: 16),
              Text(
                'Nilai rata-rata seluruh siswa: ${_hitungRataRataSeluruhSiswa().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text('Hitung'),
              ),
              if (_siswaList.isNotEmpty)
                ElevatedButton(
                  onPressed: _resetForm,
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(iconColor: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
