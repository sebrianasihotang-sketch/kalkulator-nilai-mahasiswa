import 'package:flutter/material.dart';

void main() {
  runApp(const KalkulatorNilaiApp());
}

class KalkulatorNilaiApp extends StatelessWidget {
  const KalkulatorNilaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Nilai Mahasiswa',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Mahasiswa {
  String nama;
  String npm;
  String prodi;
  String kelas;
  double nilaiTugas;
  double nilaiUTS;
  double nilaiUAS;
  double nilaiAkhir;
  String grade;
  String status;

  Mahasiswa({
    required this.nama,
    required this.npm,
    required this.prodi,
    required this.kelas,
    required this.nilaiTugas,
    required this.nilaiUTS,
    required this.nilaiUAS,
    required this.nilaiAkhir,
    required this.grade,
    required this.status,
  });

  String get inisial {
    if (nama.trim().isEmpty) return '?';
    return nama.trim()[0].toUpperCase();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController(text: 'Manajemen Informatika');
  final TextEditingController _kelasController = TextEditingController(text: 'MI 3A');
  final TextEditingController _tugasController = TextEditingController();
  final TextEditingController _utsController = TextEditingController();
  final TextEditingController _uasController = TextEditingController();

  final List<Mahasiswa> _listMahasiswa = [];

  // Fungsi Tambah Data Mahasiswa
  void _tambahMahasiswa() {
    if (_formKey.currentState!.validate()) {
      String nama = _namaController.text;
      String npm = _npmController.text.isEmpty ? '-' : _npmController.text;
      String prodi = _prodiController.text;
      String kelas = _kelasController.text;

      double tugas = double.parse(_tugasController.text);
      double uts = double.parse(_utsController.text);
      double uas = double.parse(_uasController.text);

      // Rumus: 30% Tugas + 30% UTS + 40% UAS[cite: 1]
      double nilaiAkhir = (0.3 * tugas) + (0.3 * uts) + (0.4 * uas);

      // Grade[cite: 1]
      String grade;
      if (nilaiAkhir >= 85) {
        grade = 'A';
      } else if (nilaiAkhir >= 75) {
        grade = 'B';
      } else if (nilaiAkhir >= 65) {
        grade = 'C';
      } else if (nilaiAkhir >= 50) {
        grade = 'D';
      } else {
        grade = 'E';
      }

      // Status[cite: 1]
      String status = (nilaiAkhir >= 60) ? 'LULUS' : 'TIDAK LULUS';

      setState(() {
        _listMahasiswa.add(Mahasiswa(
          nama: nama,
          npm: npm,
          prodi: prodi,
          kelas: kelas,
          nilaiTugas: tugas,
          nilaiUTS: uts,
          nilaiUAS: uas,
          nilaiAkhir: nilaiAkhir,
          grade: grade,
          status: status,
        ));
      });

      _namaController.clear();
      _npmController.clear();
      _tugasController.clear();
      _utsController.clear();
      _uasController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data Mahasiswa Berhasil Ditambahkan!')),
      );
    }
  }

  // Fungsi Edit Data Mahasiswa
  void _editMahasiswa(int index) {
    final mhs = _listMahasiswa[index];

    final editNamaCtrl = TextEditingController(text: mhs.nama);
    final editNpmCtrl = TextEditingController(text: mhs.npm);
    final editProdiCtrl = TextEditingController(text: mhs.prodi);
    final editKelasCtrl = TextEditingController(text: mhs.kelas);
    final editTugasCtrl = TextEditingController(text: mhs.nilaiTugas.toString());
    final editUtsCtrl = TextEditingController(text: mhs.nilaiUTS.toString());
    final editUasCtrl = TextEditingController(text: mhs.nilaiUAS.toString());
    final editFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Mahasiswa'),
          content: SingleChildScrollView(
            child: Form(
              key: editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: editNamaCtrl,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: editNpmCtrl,
                    decoration: const InputDecoration(labelText: 'NPM'),
                  ),
                  TextFormField(
                    controller: editProdiCtrl,
                    decoration: const InputDecoration(labelText: 'Program Studi'),
                  ),
                  TextFormField(
                    controller: editKelasCtrl,
                    decoration: const InputDecoration(labelText: 'Kelas'),
                  ),
                  TextFormField(
                    controller: editTugasCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Nilai Tugas (30%)'),
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: editUtsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Nilai UTS (30%)'),
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: editUasCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Nilai UAS (40%)'),
                    validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editFormKey.currentState!.validate()) {
                  double tugas = double.parse(editTugasCtrl.text);
                  double uts = double.parse(editUtsCtrl.text);
                  double uas = double.parse(editUasCtrl.text);

                  double nilaiAkhir = (0.3 * tugas) + (0.3 * uts) + (0.4 * uas);

                  String grade;
                  if (nilaiAkhir >= 85) {
                    grade = 'A';
                  } else if (nilaiAkhir >= 75) {
                    grade = 'B';
                  } else if (nilaiAkhir >= 65) {
                    grade = 'C';
                  } else if (nilaiAkhir >= 50) {
                    grade = 'D';
                  } else {
                    grade = 'E';
                  }

                  String status = (nilaiAkhir >= 60) ? 'LULUS' : 'TIDAK LULUS';

                  setState(() {
                    _listMahasiswa[index] = Mahasiswa(
                      nama: editNamaCtrl.text,
                      npm: editNpmCtrl.text.isEmpty ? '-' : editNpmCtrl.text,
                      prodi: editProdiCtrl.text,
                      kelas: editKelasCtrl.text,
                      nilaiTugas: tugas,
                      nilaiUTS: uts,
                      nilaiUAS: uas,
                      nilaiAkhir: nilaiAkhir,
                      grade: grade,
                      status: status,
                    );
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data Mahasiswa Berhasil Diperbarui!')),
                  );
                }
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi Hapus Data Mahasiswa
  void _hapusMahasiswa(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: Text('Apakah Anda yakin ingin menghapus data ${_listMahasiswa[index].nama}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _listMahasiswa.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data Mahasiswa Berhasil Dihapus!')),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // Tampilkan Pop-up Identitas Mahasiswa saat Avatar diklik[cite: 3]
  void _tampilkanIdentitasMahasiswa(Mahasiswa mhs) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(20.0),
            color: const Color(0xFFFAF6F0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD3BBA2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Dashboard Mahasiswa',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5C4033)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Selamat Datang, Mahasiswa!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5C4033)),
                  ),
                  const Text(
                    'Sistem Informasi Data Mahasiswa',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: const Color(0xFF5C4033),
                    child: Text(
                      mhs.inisial,
                      style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    mhs.nama.toUpperCase(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5C4033)),
                  ),
                  Text(
                    'Mahasiswa ${mhs.prodi}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF8B5A2B)),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailCard('Nama', mhs.nama),
                  _buildDetailCard('NPM', mhs.npm),
                  _buildDetailCard('Program Studi', mhs.prodi),
                  _buildDetailCard('Kelas', mhs.kelas),
                  _buildDetailCard('Nilai Akhir', mhs.nilaiAkhir.toStringAsFixed(1)),
                  _buildDetailCard('Nilai Huruf', mhs.grade),
                  _buildDetailCard('Status', mhs.status),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5A2B),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0D5C1)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5C4033)),
            ),
          ),
          Text(
            ': $value',
            style: const TextStyle(color: Color(0xFF5C4033)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Nilai Mahasiswa'),
        backgroundColor: const Color(0xFF8B5A2B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form Input Data Mahasiswa
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Input Data Mahasiswa',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Mahasiswa',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _npmController,
                        decoration: const InputDecoration(
                          labelText: 'NPM',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _prodiController,
                              decoration: const InputDecoration(
                                labelText: 'Program Studi',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _kelasController,
                              decoration: const InputDecoration(
                                labelText: 'Kelas',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _tugasController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Nilai Tugas (30%)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _utsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Nilai UTS (30%)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _uasController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Nilai UAS (40%)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _tambahMahasiswa,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          backgroundColor: const Color(0xFF8B5A2B),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Hitung & Simpan Data'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header Daftar & Status Jumlah Mahasiswa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Mahasiswa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total: ${_listMahasiswa.length} / Minimal 10',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _listMahasiswa.length >= 10 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // List Mahasiswa dengan Aksi Edit & Hapus
            _listMahasiswa.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Belum ada data mahasiswa.'),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _listMahasiswa.length,
                    itemBuilder: (context, index) {
                      final mhs = _listMahasiswa[index];
                      final isLulus = mhs.status == 'LULUS';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () => _tampilkanIdentitasMahasiswa(mhs),
                            child: CircleAvatar(
                              backgroundColor: isLulus ? Colors.green : Colors.red,
                              foregroundColor: Colors.white,
                              child: Text(
                                mhs.inisial,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                          title: Text(
                            mhs.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Tugas: ${mhs.nilaiTugas} | UTS: ${mhs.nilaiUTS} | UAS: ${mhs.nilaiUAS}\n'
                            'Nilai Akhir: ${mhs.nilaiAkhir.toStringAsFixed(2)} | Grade: ${mhs.grade}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Tombol Edit
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editMahasiswa(index),
                              ),
                              // Tombol Hapus
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _hapusMahasiswa(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}