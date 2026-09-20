# week_3_Navigation and State management

## Screenshots
<h3>Screenshot Pengujian</h3>

<table>
  <tr>
    <td align="center"><b>Normal</b></td>
    <td align="center"><b>No Internet</b></td>
    <td align="center"><b>URL Salah</b></td>
  </tr>
  <tr>
    <td>
      <img src="screenshot/NormalW4.jpeg" width="280">
    </td>
    <td>
      <img src="screenshot/NoInternetW4.jpeg" width="280">
    </td>
    <td>
      <img src="screenshot/urlSalahW4.jpeg" width="280">
    </td>
  </tr>
</table>

## Refactoring dan testing
1. Arsitektur akses data
UI tidak memanggil Dio secara langsung.
Seluruh akses API dilakukan melalui PostRepository.
Provider/Notifier digunakan sebagai penghubung antara UI dan repository.
2. State UI
Loading state menampilkan CircularProgressIndicator.
Error state menampilkan pesan error yang ramah pengguna serta tombol Coba lagi.
Empty state menampilkan pesan ketika tidak ada data.
Success state menampilkan daftar post yang berhasil dimuat.
3. Pagination
Data halaman berikutnya ditambahkan ke daftar yang sudah ada ketika pengguna melakukan scroll.
Request berikutnya tidak dijalankan jika request sebelumnya masih berlangsung.
Pagination berhenti ketika server mengembalikan data kurang dari batas limit.
Ketika seluruh data telah dimuat, ditampilkan indikator “Semua data termuat.”
4. Refactoring
Widget baris post diekstrak menjadi PostTile agar dapat digunakan kembali.
Fungsi friendlyErrorMessage dipindahkan ke network_errors.dart agar dapat digunakan oleh beberapa halaman.
Halaman detail post ditambahkan menggunakan GoRouter dengan route /post/:id.
Detail post mengambil data dari list yang sudah dimuat atau melalui repository jika data belum tersedia.
5. Verifikasi kode
flutter analyze berhasil tanpa issue.
flutter test berhasil dan seluruh test lulus.

## Refleksi
1. Mengapa UI dilarang memanggil Dio langsung?

UI menggunakan Repository dan Provider agar logika API terpisah dari tampilan. Jika Dio dipanggil langsung, kode lebih sulit diuji, dipelihara, dan diubah.

2. Kapan pagination client-side/server?

Client-side cukup untuk data kecil yang sudah tersedia. Server-side lebih cocok untuk data besar karena hanya mengambil data sesuai halaman menggunakan _page dan _limit.

3. Bagaimana exception menjadi AsyncError?

Exception dari Future pada AsyncNotifier otomatis diubah Riverpod menjadi AsyncError, sehingga widget tidak perlu try/catch. try/catch tetap diperlukan jika perlu menangani error atau mengubah state secara khusus.

4. Bagian AI yang diperbaiki
Sebelumnya, konfigurasi Dio bisa tersebar atau dibuat langsung saat akses API. Dengan dioProvider, satu instance Dio dikonfigurasi di satu tempat dan kemudian digunakan oleh PostRepository. Jadi baseUrl dan timeout tidak perlu ditulis ulang di setiap request.


## Ai Prompt Challenge

Kode yang dibuat AI belum sepenuhnya sesuai dengan semua ketentuan. UI sudah menggunakan provider dan repository sehingga tidak memanggil Dio secara langsung. fromJson juga aman ketika ada field yang hilang karena field tersebut akan menjadi null, tetapi masih dapat mengalami error jika tipe data dari JSON tidak sesuai. Penanganan error sudah mencakup timeout, connection error, serta status 404 dan 500, tetapi belum memetakan semua jenis DioExceptionType.

Selain itu, baseUrl dan timeout masih ditulis langsung di method repository, sehingga belum terpusat dalam satu konfigurasi Dio. Unit test yang dibuat sudah benar-benar menguji kasus field yang hilang, tetapi belum memiliki tambahan edge case seperti tipe data yang tidak sesuai.
Hasil pengujian menggunakan flutter test menunjukkan bahwa seluruh test berhasil dijalankan dengan hasil All tests passed. Sementara itu, flutter analyze menemukan satu issue berupa penggunaan relative import pada file test. Issue tersebut bukan error pada logika program, tetapi merupakan peringatan terkait aturan penulisan import yang disarankan Flutter.

PS E:\College\Code File\Jasmine-Nasywa-mobile-course\aichallenge\week_4> flutter test
00:15 +1: All tests passed!                                                                                               
PS E:\College\Code File\Jasmine-Nasywa-mobile-course\aichallenge\week_4> flutter analyze
Analyzing week_4...                                                     

   info - Can't use a relative path to import a library in 'lib'. Try fixing the relative path or changing the import to a
          'package:' import - test\comment_test.dart:3:8 - avoid_relative_lib_imports

1 issue found. (ran in 19.1s)


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
