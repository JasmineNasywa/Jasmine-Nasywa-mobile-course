# week_2_declarative_ui_and_responsive_design

## Screenshots

<p align="center">
  <img src="screenshot/extended-warmup.jpeg" width="300">
  <br>
  <em>Extended version setelah warm-up</em>
</p>

<p align="center">
  <img src="screenshot/mainaxis-default.jpeg" width="300">
  <br>
  <em>Penggunaan MainAxisSize pada tampilan default</em>
</p>

<p align="center">
  <img src="screenshot/vanilla-warmup.jpeg" width="300">
  <br>
  <em>Versi vanilla sebelum modifikasi</em>
</p>

<p align="center">
  <img src="screenshot/breakpoint-1200.jpeg" width="300">
  <br>
  <em>Implementasi breakpoint pada ukuran 1200</em>
</p>

<p align="center">
  <img src="screenshot/dark-mode.jpeg" width="300">
  <br>
  <em>Tampilan dark mode</em>
</p>

<p align="center">
  <img src="screenshot/different-screen-size.jpeg" width="300">
  <br>
  <em>Tampilan pada layar dengan ukuran berbeda</em>
</p>

<p align="center">
  <img src="screenshot/light-mode.jpeg" width="300">
  <br>
  <em>Tampilan light mode</em>
</p>

<p align="center">
  <img src="screenshot/semantics.jpeg" width="300">
  <br>
  <em>Implementasi Semantics untuk accessibility</em>
</p>

<p align="center">
  <img src="screenshot/theme-system-dark.jpeg" width="300">
  <br>
  <em>Theme system setelah penerapan dark theme</em>
</p>

## Refleksi
1. Apa perbedaan cara berpikir imperative dan declarative saat membangun UI?
Imperative berfokus pada bagaimana UI harus diubah. Declarative berfokus pada seperti apa kondisi UI yang diinginkan berdasarkan state saat ini.

2. Kapan Expanded membantu dan kapan penggunaannya justru menghasilkan layout error?
membantu ketika sebuah widget berada di dalam Row atau Column dan ingin menggunakan ruang yang tersedia secara fleksibel, tapi Expanded dapat menghasilkan layout error ketika digunakan pada kondisi dengan constraint yang tidak terbatas

3. Bagaimana breakpoint dan theme memengaruhi pengalaman pengguna?
Breakpoint dapat membuat layout menyesuaikan diri dengan ukuran layar. theme memengaruhi tampilan visual seperti warna, brightness, dan UI

4. Apa yang Anda verifikasi dari rekomendasi AI setelah tugas inti selesai?
Setelah tugas inti selesai, rekomendasi AI tidak langsung diterapkan begitu saja. Saya memverifikasi apakah rekomendasi tersebut sesuai dengan requirement tugas, struktur kode Flutter, dan hasil yang diharapkan supaya tidak terjadi error yang tidak saya mengerti, apabila saya terapkan maka saya akan bertanya pada AI tentang detail kode tersebut.


## Tujuan
Menerapkan konsep declarative UI dan responsive design pada Flutter dengan membangun dashboard mahasiswa yang dapat menyesuaikan tata letak berdasarkan ukuran layar. Praktikum ini juga bertujuan memahami penggunaan StatelessWidget, StatefulWidget, LayoutBuilder, breakpoint, theme, serta komponen Material dan Cupertino.

## Fitur Utama
- Responsive dashboard
- Light and dark theme
- Dashboard Cards
- Accessibility Support
- Widget Testing

Stack Teknologi
- Flutter
- Dart
- Android

Cara Menjalankan
1. Pastikan Flutter sudah terpasang dan dapat digunakan.
2. Buka folder project melalui terminal.
3. Jalankan perintah:
   flutter pub get
   flutter run

Hasil yang Dicapai
Aplikasi berhasil dibuat dan dijalankan pada perangkat Android. Aplikasi menampilkan halaman 4 card yang responsive.

## Ai Prompt Challenge

1. “Bandingkan dua tata letak dashboard akademik untuk Flutter: versi GridView dan versi LayoutBuilder + Column. Jelaskan trade-off responsif dan aksesibilitasnya.”

Output AI :

GridView

GridView cocok ketika konten utama berupa kumpulan item yang memang ingin ditampilkan dalam bentuk grid dua dimensi. Flutter menyediakan GridView.count untuk menentukan jumlah kolom secara langsung, sehingga cocok untuk dashboard yang berisi beberapa kartu informasi. GridView juga bersifat scrollable sehingga konten yang melebihi area tampilan dapat digulir.

Kelebihan:

Sederhana untuk menampilkan banyak kartu.
Cocok untuk layout dua kolom atau lebih.
Mendukung scrolling.
Bisa menentukan jumlah kolom menggunakan crossAxisCount.

Kekurangan:

Kurang fleksibel jika halaman memiliki banyak bagian berbeda, misalnya header profil di atas kemudian grid kartu di bawah.
Jika hanya menggunakan GridView.count, perubahan layout masih bergantung pada jumlah kolom yang ditentukan oleh kode.

LayoutBuilder + Column

LayoutBuilder memberikan BoxConstraints dari parent sehingga aplikasi dapat menentukan layout berdasarkan ruang yang benar-benar tersedia. Flutter memang merekomendasikan pendekatan berbasis constraints untuk adaptive layout, bukan sekadar mengecek jenis perangkat.

Column kemudian dapat digunakan untuk menyusun bagian halaman secara vertikal, misalnya:

Header profil
      ↓
Kartu informasi
      ↓
Konten akademik lainnya

Kelebihan:

Lebih fleksibel untuk halaman yang memiliki beberapa bagian.
Mudah membuat header di atas kemudian konten di bawah.
Breakpoint dapat ditentukan berdasarkan lebar yang tersedia.
Cocok untuk kebutuhan tugas yang meminta layout berbeda pada layar sempit dan lebar.

Kekurangan:

Struktur kode sedikit lebih kompleks.
Column sendiri bukan pengganti GridView jika kontennya memang berbentuk grid.
Untuk konten panjang, perlu memperhatikan scrolling dan penggunaan Expanded atau widget scrollable dengan benar.

Keputusan yang digunakan:
Pada dashboard ini digunakan LayoutBuilder untuk menentukan jumlah kolom berdasarkan lebar yang tersedia, kemudian Column digunakan untuk menyusun header dan bagian dashboard. Kartu informasi tetap ditampilkan menggunakan GridView.

Pendekatan ini lebih sesuai karena halaman bukan hanya kumpulan kartu, tetapi juga memiliki header profil dan kemungkinan bagian konten lain. Flutter sendiri menggunakan LayoutBuilder sebagai salah satu pendekatan untuk membuat layout yang adaptif terhadap ukuran ruang yang tersedia.

2. “Jelaskan kapan penggunaan Expanded justru menyebabkan overflow di dalam Row, beri contoh kode yang gagal dan perbaikannya.”

Output AI :

Expanded digunakan agar child di dalam Row, Column, atau Flex mengisi ruang yang tersedia pada main axis.

Namun, Expanded tidak boleh digunakan ketika parent Row memberikan unbounded constraint pada arah horizontal. Contoh yang dapat bermasalah adalah Row yang berada di dalam SingleChildScrollView horizontal.

Contoh yang bermasalah
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      Expanded(
        child: Container(
          width: 300,
          color: Colors.blue,
          child: const Text('Content'),
        ),
      ),
    ],
  ),
)

Masalahnya adalah SingleChildScrollView horizontal tidak memberikan batas lebar maksimum seperti layout normal. Akibatnya Row tidak memiliki lebar maksimum yang jelas, sementara Expanded membutuhkan ruang yang tersedia untuk menentukan ukuran child.

Flutter dapat menghasilkan error terkait flex pada unbounded constraints.

Perbaikan

Jika kontennya memang ingin memiliki lebar tertentu di dalam scroll horizontal, tidak perlu menggunakan Expanded:

SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      Container(
        width: 300,
        color: Colors.blue,
        child: const Text('Content'),
      ),
    ],
  ),
)

Sebaliknya, Expanded cocok ketika Row memang memiliki ruang yang terbatas dan jelas, misalnya:

Row(
  children: [
    const Icon(Icons.person),
    Expanded(
      child: Text(
        'Nama mahasiswa yang cukup panjang',
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
)

Di sini Expanded membantu text menggunakan sisa ruang yang tersedia dan mencegah child mengambil lebar tanpa batas.

Kesimpulan:
Expanded bukan solusi universal untuk overflow. Ia bekerja dengan baik ketika parent Flex memiliki batas ruang yang jelas. Pada kondisi unbounded, penggunaan Expanded justru dapat menyebabkan masalah constraint.

3. “Periksa kembali rekomendasi layout di atas: apakah tetap responsif di bawah 600px, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stabil saat ini?”

Hasil verifikasi AI:

Responsif di bawah 600px:
Layout tetap dapat dibuat responsif selama breakpoint ditentukan berdasarkan constraints.maxWidth dan layout sempit menggunakan satu kolom. LayoutBuilder memang dirancang untuk membangun widget berdasarkan constraint dari parent. Flutter juga menyarankan penggunaan LayoutBuilder atau MediaQuery untuk menentukan layout berdasarkan ruang yang tersedia.

Pada implementasi tugas ini, logikanya:

final columns = constraints.maxWidth >= 1200 ? 2 : 1;

berarti:

lebar < 1200 → 1 kolom
lebar ≥ 1200 → 2 kolom

Angka 1200 merupakan breakpoint yang dipilih untuk kebutuhan tugas/demo, bukan aturan wajib Flutter. Flutter justru menyarankan memilih breakpoint berdasarkan kebutuhan layout.

Aksesibilitas:
Penggunaan LayoutBuilder, Column, atau GridView tidak secara otomatis mengurangi aksesibilitas. Aksesibilitas lebih bergantung pada semantic information, struktur navigasi, label, ukuran target interaksi, dan bagaimana widget disajikan kepada assistive technology.

Pada implementasi ini digunakan:

Semantics(
  label: 'Dark mode',
  value: isDark ? 'On' : 'Off',
  child: CupertinoSwitch(
    value: isDark,
    onChanged: onDarkChanged,
  ),
)

Semantics memang digunakan untuk memberikan informasi mengenai makna widget kepada assistive technologies.

Jadi penggunaan Semantics tersebut meningkatkan informasi aksesibilitas, bukan menguranginya.

Ketersediaan widget:
LayoutBuilder, GridView, Column, Row, Expanded, dan Semantics merupakan widget/API Flutter yang tersedia pada dokumentasi Flutter saat ini. Dokumentasi resmi yang diperbarui pada Agustus 2026 mencatat Flutter 3.47 sebagai stable release terbaru yang terdokumentasi, dan dokumentasi API masih menyediakan widget-widget tersebut.

Hasil verifikasi:
Rekomendasi layout dapat digunakan untuk tugas ini. Tidak ditemukan penggunaan widget eksperimental atau widget yang tidak tersedia pada Flutter stable yang menjadi dasar implementasi.

4. Dokumentasi
Prompt yang digunakan

Prompt 1:

“Bandingkan dua tata letak dashboard akademik untuk Flutter: versi GridView dan versi LayoutBuilder + Column. Jelaskan trade-off responsif dan aksesibilitasnya.”

Prompt 2:

“Jelaskan kapan penggunaan Expanded justru menyebabkan overflow di dalam Row, beri contoh kode yang gagal dan perbaikannya.”

Prompt 3:

“Periksa kembali rekomendasi layout di atas: apakah tetap responsif di bawah 600px, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stabil saat ini?”

Keputusan yang dipilih AI:

Implementasi menggunakan kombinasi:

LayoutBuilder
    ↓
Column
    ↓
Profile Header
    ↓
Expanded
    ↓
GridView
    ↓
Dashboard Cards

LayoutBuilder digunakan untuk menentukan jumlah kolom berdasarkan lebar yang tersedia. Pada layar sempit digunakan satu kolom, sedangkan pada layar lebar digunakan dua kolom. Column digunakan untuk menyusun header profil dan konten dashboard secara vertikal.

GridView tetap digunakan untuk menyusun kartu informasi karena widget tersebut memang dirancang untuk layout dua dimensi dan menyediakan scrolling.

Expanded digunakan agar GridView mengisi sisa ruang di dalam Column, sedangkan Semantics digunakan pada toggle tema untuk memberikan informasi yang bermakna kepada assistive technology.

Alasan teknis

Pendekatan ini dipilih karena dashboard membutuhkan lebih dari sekadar grid kartu. Halaman juga memiliki header profil dan dapat dikembangkan dengan bagian akademik lainnya. LayoutBuilder memungkinkan layout menyesuaikan diri berdasarkan constraint aktual dari parent, sehingga lebih sesuai untuk kebutuhan responsive/adaptive layout.

Bukti verifikasi
Screenshot layar sempit menunjukkan dashboard dalam satu kolom.
Screenshot layar lebar menunjukkan dashboard dalam dua kolom.
Toggle light/dark theme diuji dan dapat mengubah tema aplikasi.
Elemen toggle tema diberi Semantics dengan label dan value.
Widget yang digunakan diverifikasi melalui dokumentasi Flutter stable.
Kesimpulan

AI digunakan setelah implementasi mandiri selesai sebagai alat pembanding desain, penguatan pemahaman konsep Expanded, dan verifikasi hasil. Keputusan akhir tetap menggunakan implementasi yang sesuai dengan kebutuhan dashboard dan requirement tugas.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
