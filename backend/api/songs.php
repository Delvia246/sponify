<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendResponse(false, "Metode tidak diizinkan", null, 405);
}

// Query join untuk ambil lagu sekaligus info album dan artisnya
$query = "SELECT 
            songs.id, 
            songs.title, 
            songs.duration, 
            songs.audio_url,
            albums.title AS album,
            albums.cover_url,
            artists.name AS artist
          FROM songs
          JOIN albums ON songs.album_id = albums.id
          JOIN artists ON albums.artist_id = artists.id
          ORDER BY songs.id ASC";

$result = $conn->query($query);

if (!$result) {
    sendResponse(false, "Gagal mengambil data lagu: " . $conn->error, null, 500);
}

$songs = [];
while ($row = $result->fetch_assoc()) {
    $songs[] = $row;
}

sendResponse(true, "Daftar lagu berhasil diambil", $songs, 200);
?>