# week_5_offline_notes

## Screenshots
<h3>Screenshot Pengujian</h3>

<table>
  <tr>
    <th>Test</th>
    <th>Screenshot</th>
    <th>Result</th>
  </tr>
  <tr>
    <td>First Launch</td>
    <td><img src="screenshots/firstLaunch.jpeg" width="250"></td>
    <td>Data berhasil ditampilkan setelah aplikasi pertama kali dijalankan.</td>
  </tr>
  <tr>
    <td>Offline</td>
    <td><img src="screenshots/offline.jpeg" width="250"></td>
    <td>Data tetap dapat ditampilkan tanpa koneksi internet.</td>
  </tr>
  <tr>
    <td>Online</td>
    <td><img src="screenshots/online.jpeg" width="250"></td>
    <td>Koneksi internet kembali aktif.</td>
  </tr>
  <tr>
    <td>Sync</td>
    <td><img src="screenshots/sync.jpeg" width="250"></td>
    <td>Data berhasil melalui proses sinkronisasi.</td>
  </tr>
</table>

## Refactoring dan testing
- UI tidak memanggil SQLite/SharedPreferences secara langsung; akses data dilakukan melalui repository.
- Aplikasi dapat membaca dan menghapus catatan dalam mode pesawat. Fitur tambah catatan tidak dicantumkan karena belum menjadi bagian dari implementasi UI saat ini.
- Badge dirty tersedia untuk menunjukkan status sinkronisasi catatan, tetapi pengujian perubahan badge sebelum/sesudah sync belum dilakukan.
- Cache posts tetap dapat ditampilkan tanpa koneksi internet berdasarkan mekanisme cache-first.
- Verifikasi kode
PS E:\College\Code File\Jasmine-Nasywa-mobile-course\week_5_offline_notes> flutter analyze
Analyzing week_5_offline_notes...                                       
No issues found! (ran in 7.3s)
PS E:\College\Code File\Jasmine-Nasywa-mobile-course\week_5_offline_notes> flutter test
00:16 +2: All tests passed!  

## Refleksi
1. Daftar catatan tidak sebaiknya disimpan di SharedPreferences karena fitur tersebut ditujukan untuk data sederhana seperti preferensi atau pengaturan. Jika digunakan untuk koleksi catatan, seluruh data harus disimpan sebagai satu nilai sehingga kurang efisien dan menyulitkan proses CRUD ketika jumlah catatan bertambah.

2. Cache-first cukup digunakan ketika data lama masih berguna dan aplikasi perlu tetap dapat digunakan saat offline, seperti catatan. Untuk data yang harus selalu terbaru, seperti harga real-time, lebih sesuai menggunakan network-first agar aplikasi mengambil data terbaru dari server terlebih dahulu dan menggunakan cache sebagai cadangan.

3. Dirty flag dapat menjadi antrean sync sederhana dengan menandai catatan yang berubah menggunakan dirty = 1, kemudian proses sinkronisasi berjalan di background tanpa menghambat UI. Setelah berhasil disinkronkan, flag diubah menjadi 0. Tabel outbox diperlukan jika operasi sync semakin kompleks dan membutuhkan pencatatan setiap operasi, retry, atau urutan operasi.

4. Saya menolak penggunaan SharedPreferences sebagai penyimpanan utama catatan karena kurang sesuai untuk koleksi data dalam jumlah besar. Saya juga tidak menggunakan Drift atau Hive karena kebutuhan aplikasi saat ini masih dapat dipenuhi dengan sqflite, sedangkan penggunaan database atau framework tambahan akan menambah kompleksitas yang belum diperlukan.


## Ai Prompt Challenge

1. Apakah AI menempatkan daftar catatan di SharedPreferences?
Tidak. SharedPreferences digunakan untuk menyimpan data preferensi sederhana seperti mode gelap. Daftar catatan disimpan menggunakan SQLite melalui sqflite karena lebih sesuai untuk koleksi data dalam jumlah besar dan membutuhkan operasi CRUD/query.

2. Apakah skema AI mendukung antrean sync atau hanya CRUD polos?
Skema final mendukung kebutuhan sinkronisasi karena menggunakan dirty dan updated_at. dirty digunakan untuk menandai catatan yang belum tersinkronisasi, sedangkan updated_at menyimpan waktu perubahan catatan. Jadi implementasinya tidak hanya CRUD polos.

3. Apakah klaim "real-time" AI didukung stream?
Tidak. Implementasi yang digunakan belum memakai stream seperti watch() pada Drift. Perubahan data diperbarui dengan mengambil data kembali dari database dan menggunakan setState(). Jadi lebih tepat disebut refresh/update UI setelah perubahan, bukan real-time database stream.

4. Apakah estimasi boilerplate AI masuk akal setelah instalasi?
Secara umum, ya. sqflite membutuhkan lebih banyak kode dibandingkan SharedPreferences karena perlu konfigurasi database, tabel, serta pengelolaan CRUD. Namun setelah dependency di-install dengan flutter pub get, implementasinya masih cukup sederhana untuk aplikasi catatan.

5. Keputusan final
Saya memilih kombinasi SharedPreferences dan sqflite. SharedPreferences digunakan untuk preferensi sederhana seperti tema, sedangkan sqflite digunakan untuk menyimpan catatan karena lebih sesuai untuk data dalam jumlah besar, operasi CRUD, query, dan kebutuhan sinkronisasi menggunakan dirty serta updated_at.

PS E:\College\Code File\Jasmine-Nasywa-mobile-course\aichallenge\week_5> flutter analyze
Analyzing week_5...                                                     

  error - Undefined name 'openNotesDb'. Try correcting the name to one that is defined, or defining the name -
         lib\data\repositories\note_repository.dart:13:29 - undefined_identifier
warning - Unused import: 'package:path/path.dart'. Try removing the import directive - lib\main.dart:2:8 -
       unused_import
warning - Unused import: 'package:sqflite/sqflite.dart'. Try removing the import directive - lib\main.dart:4:8 -
       unused_import
  error - The method 'NotesPage' isn't defined for the type '_OfflineNotesAppState'. Try correcting the name to
         the name of an existing method, or defining a method named 'NotesPage' - lib\main.dart:68:13 -
         undefined_method
warning - Unused import: '../data/models/post.dart'. Try removing the import directive -
       lib\pages\notes_page.dart:3:8 - unused_import
warning - Unused import: '../data/repositories/note_repository.dart'. Try removing the import directive -
       lib\pages\notes_page.dart:5:8 - unused_import
warning - Unused import: 'package:flutter/material.dart'. Try removing the import directive -
       lib\pages\settings_page.dart:1:8 - unused_import
   info - The imported package 'week5_offline_notes' isn't a dependency of the importing package. Try adding a
          dependency for 'week5_offline_notes' in the 'pubspec.yaml' file - test\widget_test.dart:3:8 -
          depend_on_referenced_packages
  error - Target of URI doesn't exist: 'package:week5_offline_notes/data/local/note.dart'. Try creating the file
         referenced by the URI, or try using a URI for a file that does exist - test\widget_test.dart:3:8 -
         uri_does_not_exist
   info - The imported package 'week5_offline_notes' isn't a dependency of the importing package. Try adding a
          dependency for 'week5_offline_notes' in the 'pubspec.yaml' file - test\widget_test.dart:4:8 -
          depend_on_referenced_packages
  error - Target of URI doesn't exist: 'package:week5_offline_notes/data/repositories/note_repository.dart'. Try
         creating the file referenced by the URI, or try using a URI for a file that does exist -
         test\widget_test.dart:4:8 - uri_does_not_exist
  error - Classes can only extend other classes. Try specifying a different superclass, or removing the extends
         clause - test\widget_test.dart:6:34 - extends_non_class
  error - The named parameter 'openDb' isn't defined. Try correcting the name to an existing named parameter's
         name, or defining a named parameter with the name 'openDb' - test\widget_test.dart:8:15 -
         undefined_named_parameter
  error - The name 'Note' isn't a type, so it can't be used as a type argument. Try correcting the name to an
         existing type, or defining a type named 'Note' - test\widget_test.dart:10:14 -
         non_type_as_type_argument
  error - The name 'Note' isn't a type, so it can't be used as a type argument. Try correcting the name to an
         existing type, or defining a type named 'Note' - test\widget_test.dart:14:15 -
         non_type_as_type_argument
warning - The method doesn't override an inherited method. Try updating this class to match the superclass, or
       removing the override annotation - test\widget_test.dart:14:22 - override_on_non_overriding_member
warning - The method doesn't override an inherited method. Try updating this class to match the superclass, or
       removing the override annotation - test\widget_test.dart:20:15 - override_on_non_overriding_member
  error - The property 'dirty' can't be unconditionally accessed because the receiver can be 'null'. Try making
         the access conditional (using '?.') or adding a null check to the target ('!') -
         test\widget_test.dart:21:41 - unchecked_use_of_nullable_value
  error - Undefined name 'Note'. Try correcting the name to one that is defined, or defining the name -
         test\widget_test.dart:26:18 - undefined_identifier
  error - The function 'Note' isn't defined. Try importing the library that defines 'Note', correcting the name
         to the name of an existing function, or defining a function named 'Note' - test\widget_test.dart:33:18
         - undefined_function
  error - Undefined name 'Note'. Try correcting the name to one that is defined, or defining the name -
         test\widget_test.dart:38:22 - undefined_identifier
  error - Undefined name 'noteRepositoryProvider'. Try correcting the name to one that is defined, or defining
         the name - test\widget_test.dart:45:9 - undefined_identifier
  error - The function 'Note' isn't defined. Try importing the library that defines 'Note', correcting the name
         to the name of an existing function, or defining a function named 'Note' - test\widget_test.dart:47:13
         - undefined_function
  error - Undefined name 'notesProvider'. Try correcting the name to one that is defined, or defining the name -
         test\widget_test.dart:53:40 - undefined_identifier
  error - The property 'length' can't be unconditionally accessed because the receiver can be 'null'. Try making
         the access conditional (using '?.') or adding a null check to the target ('!') -
         test\widget_test.dart:54:18 - unchecked_use_of_nullable_value
  error - The property 'first' can't be unconditionally accessed because the receiver can be 'null'. Try making
         the access conditional (using '?.') or adding a null check to the target ('!') -
         test\widget_test.dart:55:18 - unchecked_use_of_nullable_value
  error - Undefined name 'noteRepositoryProvider'. Try correcting the name to one that is defined, or defining
         the name - test\widget_test.dart:61:9 - undefined_identifier
  error - Undefined name 'notesProvider'. Try correcting the name to one that is defined, or defining the name -
         test\widget_test.dart:68:22 - undefined_identifier

28 issues found. (ran in 15.1s)
PS E:\College\Code File\Jasmine-Nasywa-mobile-course\aichallenge\week_5> flutter test
00:00 +0: ... E:/College/Code File/Jasmine-Nasywa-mobile-course/aichallenge/week_5/test/widget_test.dart       Error: Couldn't resolve the package 'week5_offline_notes' in 'package:week5_offline_notes/data/local/note.dart'.
Error: Couldn't resolve the package 'week5_offline_notes' in
'package:week5_offline_notes/data/repositories/note_repository.dart'.
test/widget_test.dart:3:8: Error: Not found: 'package:week5_offline_notes/data/local/note.dart'
import 'package:week5_offline_notes/data/local/note.dart';
       ^
test/widget_test.dart:4:8: Error: Not found:
'package:week5_offline_notes/data/repositories/note_repository.dart'
import 'package:week5_offline_notes/data/repositories/note_repository.dart';
       ^
00:02 +0: ... E:/College/Code File/Jasmine-Nasywa-mobile-course/aichallenge/week_5/test/widget_test.dart       test/widget_test.dart:6:34: Error: Type 'NoteRepository' not found.
class FakeNoteRepository extends NoteRepository {
                                 ^^^^^^^^^^^^^^
test/widget_test.dart:10:14: Error: Type 'Note' not found.
  final List<Note> items;
             ^^^^
test/widget_test.dart:14:15: Error: Type 'Note' not found.
  Future<List<Note>> fetchNotes() async {
              ^^^^
00:03 +0: ... E:/College/Code File/Jasmine-Nasywa-mobile-course/aichallenge/week_5/test/widget_test.dart       test/widget_test.dart:10:14: Error: 'Note' isn't a type.
  final List<Note> items;
             ^^^^
test/widget_test.dart:21:41: Error: The getter 'dirty' isn't defined for the type 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'dirty'.
      Future.value(items.where((n) => n.dirty).length);
                                        ^^^^^
test/widget_test.dart:26:18: Error: Undefined name 'Note'.
    final note = Note.fromMap({'title': 'Belanja'});
                 ^^^^
test/widget_test.dart:33:18: Error: Method not found: 'Note'.
    final note = Note(
                 ^^^^
test/widget_test.dart:38:22: Error: Undefined name 'Note'.
    final restored = Note.fromMap(note.toMap());
                     ^^^^
test/widget_test.dart:47:13: Error: Method not found: 'Note'.
            Note(title: 'Tes', updatedAt: DateTime.now()),
            ^^^^
test/widget_test.dart:45:9: Error: Undefined name 'noteRepositoryProvider'.
        noteRepositoryProvider.overrideWithValue(
        ^^^^^^^^^^^^^^^^^^^^^^
test/widget_test.dart:53:40: Error: Undefined name 'notesProvider'.
    final notes = await container.read(notesProvider.future);
                                       ^^^^^^^^^^^^^
test/widget_test.dart:61:9: Error: Undefined name 'noteRepositoryProvider'.
        noteRepositoryProvider.overrideWithValue(
        ^^^^^^^^^^^^^^^^^^^^^^
test/widget_test.dart:68:22: Error: Undefined name 'notesProvider'.
      container.read(notesProvider.future),
                     ^^^^^^^^^^^^^
test/widget_test.dart:54:18: Error: The getter 'length' isn't defined for the type 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'length'.
    expect(notes.length, 1);
                 ^^^^^^
test/widget_test.dart:55:18: Error: The getter 'first' isn't defined for the type 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'first'.
    expect(notes.first.title, 'Tes');
                 ^^^^^
00:10 +0 -1: loading E:/College/Code File/Jasmine-Nasywa-mobile-course/aichallenge/week_5/test/widget_test.dart[E]
  Failed to load "E:/College/Code File/Jasmine-Nasywa-mobile-course/aichallenge/week_5/test/widget_test.dart":
  Compilation failed for testPath=E:/College/Code File/Jasmine-Nasywa-mobile-course/aichallenge/week_5/test/widget_test.dart: Error: Couldn't resolve the package 'week5_offline_notes' in 'package:week5_offline_notes/data/local/note.dart'.
  Error: Couldn't resolve the package 'week5_offline_notes' in 'package:week5_offline_notes/data/repositories/note_repository.dart'.
  test/widget_test.dart:3:8: Error: Not found: 'package:week5_offline_notes/data/local/note.dart'
  import 'package:week5_offline_notes/data/local/note.dart';
         ^
  test/widget_test.dart:4:8: Error: Not found: 'package:week5_offline_notes/data/repositories/note_repository.dart'
  import 'package:week5_offline_notes/data/repositories/note_repository.dart';
         ^
  test/widget_test.dart:6:34: Error: Type 'NoteRepository' not found.
  class FakeNoteRepository extends NoteRepository {
                                   ^^^^^^^^^^^^^^
  test/widget_test.dart:10:14: Error: Type 'Note' not found.
    final List<Note> items;
               ^^^^
  test/widget_test.dart:14:15: Error: Type 'Note' not found.
    Future<List<Note>> fetchNotes() async {
                ^^^^
  test/widget_test.dart:10:14: Error: 'Note' isn't a type.
    final List<Note> items;
               ^^^^
  test/widget_test.dart:21:41: Error: The getter 'dirty' isn't defined for the type 'Object?'.
   - 'Object' is from 'dart:core'.
  Try correcting the name to the name of an existing getter, or defining a getter or field named 'dirty'.
        Future.value(items.where((n) => n.dirty).length);
                                          ^^^^^
  test/widget_test.dart:26:18: Error: Undefined name 'Note'.
      final note = Note.fromMap({'title': 'Belanja'});
                   ^^^^
  test/widget_test.dart:33:18: Error: Method not found: 'Note'.
      final note = Note(
                   ^^^^
  test/widget_test.dart:38:22: Error: Undefined name 'Note'.
      final restored = Note.fromMap(note.toMap());
                       ^^^^
  test/widget_test.dart:47:13: Error: Method not found: 'Note'.
              Note(title: 'Tes', updatedAt: DateTime.now()),
              ^^^^
  test/widget_test.dart:45:9: Error: Undefined name 'noteRepositoryProvider'.
          noteRepositoryProvider.overrideWithValue(
          ^^^^^^^^^^^^^^^^^^^^^^
  test/widget_test.dart:53:40: Error: Undefined name 'notesProvider'.
      final notes = await container.read(notesProvider.future);
                                         ^^^^^^^^^^^^^
  test/widget_test.dart:61:9: Error: Undefined name 'noteRepositoryProvider'.
          noteRepositoryProvider.overrideWithValue(
          ^^^^^^^^^^^^^^^^^^^^^^
  test/widget_test.dart:68:22: Error: Undefined name 'notesProvider'.
        container.read(notesProvider.future),
                       ^^^^^^^^^^^^^
  test/widget_test.dart:54:18: Error: The getter 'length' isn't defined for the type 'Object?'.
   - 'Object' is from 'dart:core'.
  Try correcting the name to the name of an existing getter, or defining a getter or field named 'length'.
      expect(notes.length, 1);
                   ^^^^^^
  test/widget_test.dart:55:18: Error: The getter 'first' isn't defined for the type 'Object?'.
   - 'Object' is from 'dart:core'.
  Try correcting the name to the name of an existing getter, or defining a getter or field named 'first'.
      expect(notes.first.title, 'Tes');
                   ^^^^^
  .

To run this test again: D:\FlutterSDK\flutter\bin\cache\dart-sdk\bin\dart.exe test E:/College/Code File/Jasmine-Nasywa-mobile-course/aichallenge/week_5/test/widget_test.dart -p vm --plain-name "loading E:/College/Code File/Jasmine-Nasywa-mobile-course/aichallenge/week_5/test/widget_test.dart"
00:10 +0 -1: Some tests failed.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
