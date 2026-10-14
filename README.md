# Sponify — Clone Spotify

Proyek UTS Pemrograman Aplikasi Bergerak 2026.
Aplikasi mobile berbasis Flutter yang mereplikasi aplikasi Spotify, terintegrasi dengan REST API dan database MySQL.

## Deskripsi

Sponify adalah aplikasi pemutar musik yang meniru UI/UX Spotify. Pengguna dapat mendaftar, login, mencari lagu, memutar musik, membuat playlist, dan melihat halaman premium.

## Anggota Kelompok

| Nama | NIM |
|------|-----|
| Delvia | 224xxxxxxx |
| Anggota 2 | NIM 2 |
| Anggota 3 | NIM 3 |

## Tech Stack

- Frontend: Flutter (Dart)
- Backend: PHP (REST API)
- Database: MySQL (via XAMPP)
- Tools: VS Code, Postman, XAMPP

## Fitur Utama

- Register & Login dengan session
- Home page dengan greeting dinamis
- Search lagu/artis/album
- Library (Playlist, Artis, Album)
- Music Player (Mini & Full Screen)
- Buat playlist baru
- Halaman Premium (pricing plans)
- Halaman Profil (dengan logout)

## Struktur Folder

sponify/
- backend/          REST API PHP
- database/         Script SQL
- docs/             Dokumentasi
- mobile/           Aplikasi Flutter

## Cara Menjalankan

### Setup Database
1. Buka XAMPP, start Apache & MySQL
2. Buka http://localhost/phpmyadmin
3. Buat database: sponify_db
4. Import database/schema.sql
5. Import database/seed.sql

### Setup Backend
1. Copy folder backend ke /Applications/XAMPP/htdocs/sponify/
2. Test: http://localhost/sponify/backend/api/songs.php

### Setup Flutter
cd mobile
flutter pub get
flutter run -d chrome

### Akun Demo
- Email: tes@gmail.com
- Password: 123456

## Video Demo

[Link YouTube akan diupdate]

## Lisensi

Proyek ini dibuat untuk keperluan akademik UTS Pemrograman Aplikasi Bergerak 2026.
