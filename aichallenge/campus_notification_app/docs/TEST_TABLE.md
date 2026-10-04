# Tabel Pengujian Klik Notifikasi

Isi kolom "Hasil" setelah diuji di perangkat nyata. Payload uji (FCM HTTP v1):
`data: { "route": "/announcement/42" }`

| # | Platform | State app | Jenis pesan | Aksi | Rute yang diharapkan | Hasil |
|---|----------|-----------|-------------|------|----------------------|-------|
| 1 | Android 13+ | Foreground | notification+data | Tap local notification | /announcement/42 | ☐ |
| 2 | Android 13+ | Background | notification+data | Tap notifikasi sistem | /announcement/42 | ☐ |
| 3 | Android 13+ | Terminated | notification+data | Tap notifikasi sistem | /announcement/42 | ☐ |
| 4 | Android 13+ | Background | data-only | Tap local notification | /announcement/42 | ☐ |
| 5 | Android 13+ | Terminated | data-only | Tap local notification | /announcement/42 | ☐ |
| 6 | iOS | Foreground | notification+data | Tap local notification | /announcement/42 | ☐ |
| 7 | iOS | Background | notification+data | Tap notifikasi sistem | /announcement/42 | ☐ |
| 8 | iOS | Terminated | notification+data | Tap notifikasi sistem | /announcement/42 | ☐ |
| 9 | Keduanya | Semua | route tidak dikenal (/admin) | Tap | Ditolak, tetap di / | ☐ |
| 10 | Android 13+ | — | Izin notifikasi ditolak | Jalankan app | Tidak crash, token tetap dikirim | ☐ |
