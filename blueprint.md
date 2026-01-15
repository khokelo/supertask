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
- **Operasi**: Pengguna dapat menambah, mengedit, menghapus, dan menandai tugas sebagai selesai.
- **Filter**: Pengguna dapat memfilter tugas berdasarkan tanggal.

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
