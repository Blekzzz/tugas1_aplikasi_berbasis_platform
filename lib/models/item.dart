/// Entitas utama: barang inventaris (6 atribut).
class Item {
  const Item({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.jumlah,
    required this.tanggalMasuk,
    required this.status,
  });

  final String id;
  final String nama;
  final String kategori;
  final int jumlah;
  final DateTime tanggalMasuk;
  final String status;

  static const List<String> kategoriList = [
    'Elektronik',
    'Alat Tulis',
    'Furnitur',
    'Lainnya',
  ];
  static const List<String> statusList = ['Tersedia', 'Dipinjam', 'Rusak'];

  /// Object -> Map (untuk dijadikan JSON).
  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'kategori': kategori,
        'jumlah': jumlah,
        'tanggalMasuk': tanggalMasuk.toIso8601String(),
        'status': status,
      };

  /// Map (hasil decode JSON) -> Object.
  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as String,
        nama: json['nama'] as String,
        kategori: json['kategori'] as String,
        jumlah: json['jumlah'] as int,
        tanggalMasuk: DateTime.parse(json['tanggalMasuk'] as String),
        status: json['status'] as String,
      );
}
