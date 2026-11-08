# week_8_Mid Project Review & Code Review

## Screenshots

<table>
  <tr>
    <td align="center"><strong>01</strong></td>
    <td align="center"><strong>02</strong></td>
  </tr>
  <tr>
    <td><img src="screenshot/Praktikum_8/01.jpeg" alt="Dokumentasi Praktikum 8 - 01" width="100%"></td>
    <td><img src="screenshot/Praktikum_8/02.jpeg" alt="Dokumentasi Praktikum 8 - 02" width="100%"></td>
  </tr>
  <tr>
    <td align="center"><strong>03</strong></td>
    <td align="center"><strong>04</strong></td>
  </tr>
  <tr>
    <td><img src="screenshot/Praktikum_8/03.jpeg" alt="Dokumentasi Praktikum 8 - 03" width="100%"></td>
    <td><img src="screenshot/Praktikum_8/04.jpeg" alt="Dokumentasi Praktikum 8 - 04" width="100%"></td>
  </tr>
</table>
 
## Refleksi

1. Apa beda LGTM buta dengan approve yang bertanggung jawab? Apa risikonya bagi tim?

LGTM buta adalah menyetujui Pull Request tanpa memeriksa kode dan hasil pengujiannya secara menyeluruh. Sementara itu, approve yang bertanggung jawab dilakukan setelah reviewer memahami perubahan, memeriksa kemungkinan kesalahan, dan memastikan pengujian yang relevan telah dilakukan. LGTM buta berisiko membuat bug lolos ke aplikasi, menurunkan kualitas kode, dan menambah beban perbaikan bagi anggota tim.

2. Kapan komentar wajib berstatus request changes, dan kapan cukup saran?

Request changes diperlukan ketika ditemukan masalah penting yang dapat menyebabkan bug, kesalahan logika, kegagalan pengujian, atau pelanggaran persyaratan fitur. Sementara itu, saran cukup diberikan untuk perbaikan yang tidak menghambat fungsi utama, seperti meningkatkan keterbacaan kode atau menyederhanakan implementasi. Dengan demikian, tim dapat memprioritaskan masalah yang benar-benar perlu diperbaiki sebelum Pull Request digabungkan.

3. Bagian mana dari review AI yang Anda tolak atau sederhanakan, dan mengapa?

Saran dari AI tidak langsung diterapkan seluruhnya. Setiap saran perlu diperiksa kembali kesesuaiannya dengan kebutuhan aplikasi, struktur kode, dan aturan yang digunakan dalam project. Saran yang terlalu kompleks atau tidak memberikan manfaat signifikan dapat disederhanakan agar implementasi tetap mudah dipahami dan dipelihara. AI digunakan sebagai alat bantu, sedangkan keputusan akhir tetap didasarkan pada kebutuhan dan hasil pengujian project.

4. Satu hal konkret yang Anda perbaiki setelah review sejawat, apa dampaknya?

Salah satu perbaikan konkret adalah menambahkan pemeriksaan otomatis melalui flutter analyze dan flutter test, serta merapikan format kode menggunakan dart format. Perbaikan ini membantu menemukan masalah kode lebih awal dan menjaga konsistensi format. Dengan pemeriksaan otomatis, proses review menjadi lebih efisien karena reviewer dapat lebih fokus pada logika, perilaku fitur, dan kualitas implementasi.

## Refactoring dan testing
gambar hasil testing berada di nomor 4 pada folder screenshoot

## AI Challenge

1. Lima temuan awal untuk AI review
P1
Test lama dihapus tanpa pengganti yang terlihat

File: test/widget_test.dart

Diff menunjukkan dua baris dihapus dan tidak ada penambahan pada file tersebut. Periksa apakah test lama memang sengaja dihapus dan apakah sudah ada test pengganti.

Verifikasi: jalankan flutter test. Kalau tidak ada test yang memeriksa routing atau halaman awal, tambahkan widget test yang relevan.



P2
File tema masih kosong

File: lib/core/theme/app_colors.dart, lib/core/theme/app_theme.dart

Keduanya ditambahkan tetapi belum berisi kode. Ini bukan bug runtime dengan sendirinya, tetapi bisa menjadi file placeholder yang belum diperlukan.

Usulan: isi saat implementasi tema dimulai, atau hapus sementara jika belum dipakai.



P2
Belum terlihat perpindahan dari splash ke home

File: lib/app/router.dart, lib/features/splash/splash_screen.dart

Router mendaftarkan /splash dan /home, dengan /splash sebagai lokasi awal. Splash saat ini hanya menampilkan teks.

Verifikasi: jika PR ini memang hanya menyiapkan placeholder, kondisi ini bisa diterima. Kalau persyaratannya adalah splash otomatis menuju home, navigasi tersebut belum terlihat pada diff.



Saran
Pemisahan App dan router sudah dimulai

File: lib/app/app.dart, lib/app/router.dart, lib/main.dart

App menggunakan MaterialApp.router, sedangkan konfigurasi GoRouter berada di file terpisah. Ini pemisahan tanggung jawab yang masuk akal untuk tahap awal.

Saran: pertahankan pemisahan tersebut dan hindari menaruh seluruh konfigurasi navigasi di main.dart.



Saran
Pemeriksaan otomatis belum terlihat

Halaman PR menunjukkan nol checks. Itu tidak membuktikan kode gagal, tetapi belum ada bukti CI berhasil dari tampilan tersebut.

Verifikasi: jalankan flutter analyze dan flutter test secara lokal, lalu siapkan workflow CI jika memang diwajibkan oleh praktikum.



Saran ditolak :
Saran untuk menghapus route /home ditolak karena route tersebut memang disiapkan sebagai tujuan navigasi berikutnya. Walaupun belum digunakan oleh splash screen pada tahap ini, pendaftaran route diperlukan untuk pengembangan fitur selanjutnya.

# week_10_ai_integration

## Screenshoot
<td><img src="screenshot/ai.jpeg" alt="Hasil implementasi integrasi ai" width="100%"></td>

## Refleksi
1. Saya mengintegrasikan AI Chat Assistant untuk membantu mahasiswa mencari informasi akademik dan memahami pengumuman kampus dengan lebih mudah.

2. Saya menghindari pengiriman data sensitif seperti NIK, nomor telepon, dan alamat ke AI API serta merencanakan penyimpanan API key secara aman.

3. Jika AI mengalami error, aplikasi akan menampilkan pesan kesalahan dan pengguna tetap dapat mengakses pengumuman kampus secara langsung.

4. Saya belajar bahwa antarmuka chat yang sederhana, indikator loading, dan suggested prompts membuat interaksi AI di perangkat mobile lebih mudah dipahami.


# week_11_optimisasi_performa

1. UI Jank
Ada beberapa frame dengan UI frame time melewati batas 16,67 ms.

2. Raster Jank
Ada beberapa frame dengan Raster frame time yang tinggi.

3. Layout membutuhkan waktu cukup lama
Pada Frame 49, DevTools secara eksplisit menunjukkan Layout sebagai fase UI terlama.

Berdasarkan hasil profiling, ditemukan indikasi UI jank, Raster jank, dan waktu proses layout yang relatif tinggi pada beberapa frame. Masalah tersebut perlu dianalisis lebih lanjut untuk mengetahui penyebab utamanya. Perbaikan belum dapat ditentukan secara langsung karena belum dinilai cukup berdampak bagi pengguna. Tidak semua indikasi jank harus langsung diperbaiki, terutama apabila hanya terjadi sesaat dan tidak memengaruhi pengalaman penggunaan aplikasi secara signifikan.

Berdasarkan pengujian, lonjakan frame time dan jank lebih banyak ditemukan ketika aplikasi pertama kali dibuka. Pada navigasi berikutnya, performa cenderung lebih stabil dan perpindahan halaman berlangsung lebih lancar.

Hal ini mengindikasikan kemungkinan adanya overhead pada proses inisialisasi awal aplikasi, seperti pemuatan data, inisialisasi widget, atau persiapan resource. Oleh karena itu, optimasi belum menjadi prioritas sebelum penyebab lonjakan tersebut dapat dipastikan.

Perbaikan sebaiknya difokuskan pada proses startup apabila pengujian lebih lanjut menunjukkan bahwa keterlambatan tersebut berdampak pada pengalaman pengguna.

## screenshoot

<td><img src="screenshot/optimisasi1.jpeg" alt="Rebuild masih ringan belum perlu optimisasi, bar merah hanya terjadi ketika masuk dalam aplikasi saja" width="100%"></td>

## refleksi

1. Optimasi mana yang memberikan dampak terbesar dan mengapa?

Pada praktikum ini, belum dilakukan perubahan atau optimasi kode karena hasil profiling belum menunjukkan bukti yang cukup kuat mengenai adanya masalah excessive widget rebuild. Beberapa widget memang mengalami rebuild, tetapi frekuensinya masih relatif rendah dalam skenario pengujian Hal ini menunjukkan bahwa optimasi perlu dilakukan berdasarkan hasil pengukuran dan identifikasi masalah, bukan sekadar mengubah kode agar terlihat lebih optimal.

2. Bagaimana Anda memverifikasi bahwa optimasi benar-benar bekerja (bukan placebo)?

Verifikasi dilakukan dengan membandingkan hasil profiling sebelum dan sesudah optimasi menggunakan Flutter DevTools dalam Profile Mode.

Beberapa metrik yang dapat dibandingkan meliputi:
- Frame time pada UI Thread dan Raster Thread.
- Jumlah frame yang mengalami jank.
- Rata-rata FPS.
- Penggunaan memori.
- Frekuensi request API.

Optimasi dapat dianggap berhasil apabila terdapat perbaikan yang terukur pada metrik terkait tanpa menimbulkan masalah baru.

3. Trade-off apa yang Anda hadapi (misalnya kompleksitas kode vs performa)?

Trade-off yang perlu dipertimbangkan adalah kompleksitas kode dan kemudahan pemeliharaan aplikasi. Optimasi seperti penggunaan caching, pemisahan state, dan perubahan struktur widget dapat meningkatkan performa, tetapi juga berpotensi menambah kompleksitas implementasi.

4. Kapan sebaiknya optimasi premature dihindari?

Premature optimization sebaiknya dihindari ketika belum terdapat bukti bahwa suatu bagian aplikasi menjadi bottleneck performa.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
