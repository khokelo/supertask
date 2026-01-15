# Daily Task Manager - Blueprint

## Ringkasan

Aplikasi Daily Task Manager ini adalah aplikasi seluler yang dibuat dengan Flutter untuk membantu pengguna mengelola tugas harian mereka secara efisien. Aplikasi ini memiliki fitur-fitur seperti otentikasi pengguna, manajemen tugas (CRUD), unggah gambar, pelacakan lokasi waktu nyata, dan informasi cuaca. Dasbor menyediakan ringkasan kemajuan tugas pengguna.

## Arsitektur

Aplikasi ini mengikuti arsitektur bersih yang memisahkan antara `tampilan`, `logika bisnis`, dan `data`. Struktur folder utamanya adalah sebagai berikut:

- **lib/**
  - **models/**: Berisi kelas model data (misalnya, `Task`, `User`).
  - **services/**: Menangani logika bisnis dan komunikasi dengan API backend.
  - **controllers/**: Bertindak sebagai perantara antara `tampilan` dan `layanan`.
  - **views/**: Berisi layar atau halaman UI.
  - **widgets/**: Berisi komponen UI yang dapat digunakan kembali.
  - **themes/**: Mendefinisikan tema terang dan gelap untuk aplikasi.
  - **main.dart**: Titik masuk utama aplikasi.

## Fitur

### 1. Otentikasi
- **Login & Registrasi**: Pengguna dapat membuat akun dan masuk.
- **Token JWT**: Otentikasi berbasis token untuk mengamankan titik akhir API.
- **Simpan Sesi**: Menyimpan sesi pengguna untuk login otomatis.

### 2. Manajemen Tugas Harian (CRUD)
- **Atribut Tugas**: Judul, deskripsi, tanggal, status, foto, lokasi, dan cuaca.
- **Fungsi Tanggal**: Tanggal pembuatan dan penyelesaian tugas dicatat secara otomatis.
- **Operasi**: Pengguna dapat menambah, mengedit, menghapus, dan menandai tugas sebagai selesai.
- **Filter**: Pengguna dapat memfilter tugas berdasarkan tanggal.
- **Tampilan Tanggal**: Tanggal pembuatan setiap tugas ditampilkan dengan jelas di daftar tugas.

### 3. Unggah Gambar
- **Sumber Gambar**: Pengguna dapat memilih gambar dari kamera atau galeri.
- **Pratinjau**: Menampilkan pratinjau gambar sebelum mengunggah.
- **Unggah & Simpan**: Mengunggah gambar ke backend dan menyimpan URL.

### 4. Lokasi & Cuaca
- **Lokasi GPS**: Secara otomatis mengambil lokasi pengguna saat ini.
- **Geocoding Terbalik**: Mengubah koordinat GPS menjadi alamat yang dapat dibaca.
- **Cuaca Waktu Nyata**: Mengambil informasi cuaca berdasarkan lokasi pengguna.

### 5. Dasbor
- **Statistik**: Menampilkan jumlah total tugas dan tugas yang telah selesai.
- **Grafik Penyelesaian Tugas**: Grafik batang baru yang memvisualisasikan jumlah tugas yang diselesaikan per hari selama 7 hari terakhir.
- **Grafik**: Grafik mingguan untuk melacak kemajuan dan diagram lingkaran untuk status tugas.

### 6. UI & UX
- **Desain Minimalis**: Antarmuka yang bersih dan tidak berantakan.
- **Tata Letak**: Tata letak berbasis kartu untuk menampilkan tugas.
- **Akses Cepat**: Tombol Aksi Mengambang (FAB) untuk menambah tugas dengan cepat.
- **Navigasi**: Bilah navigasi bawah untuk beralih antar layar.
- **Animasi**: Animasi halus untuk meningkatkan pengalaman pengguna.

### 7. Mode Terang & Gelap
- **Beralih Tema**: Pengguna dapat beralih antara tema terang dan gelap.
- **Simpan Preferensi**: Menyimpan preferensi tema pengguna.
- **UI Dinamis**: Antarmuka beradaptasi dengan tema yang dipilih.

## Rencana Saat Ini: Penambahan Fitur Tanggal dan Grafik Dasbor

- **[Selesai]** **Perbarui Model Data**: Menambahkan bidang `createdAt` dan `completedAt` ke model `Task`.
- **[Selesai]** **Tambahkan Pustaka Grafik**: Menambahkan pustaka `fl_chart` ke proyek.
- **[Selesai]** **Perbarui Logika Kontroler**: Memodifikasi `TaskController` untuk mengelola tanggal pembuatan/penyelesaian dan membuat data agregat untuk grafik.
- **[Selesai]** **Buat Grafik Baru**: Membuat widget `CompletedTasksChart` baru untuk menampilkan penyelesaian tugas harian.
- **[Selesai]** **Integrasikan Grafik**: Menambahkan grafik baru ke `DashboardScreen`.
- **[Selesai]** **Perbarui UI Daftar Tugas**: Menampilkan tanggal pembuatan di setiap kartu tugas di `HomeScreen`.
- **[Selesai]** **Dokumentasi**: Memperbarui `blueprint.md` untuk mencerminkan semua perubahan.
