<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendResponse(false, "Metode tidak diizinkan", null, 405);
}

$mood = $_GET['mood'] ?? null;
if (!$mood) {
    sendResponse(false, "mood wajib diisi", null, 400);
}
$mood = $conn->real_escape_string($mood);

// Mapping mood → artist name (case-insensitive)
$moodMap = [
    'happy'    => "ar.name = 'The Coding Beats'",
    'sad'      => "al.title = 'Debugging Sessions'",
    'chill'    => "ar.name = 'Lo-Fi Chill'",
    'workout'  => "ar.name = 'Synthwave Rider'",
    'party'    => "al.title = 'Neon Nights'",
    'focus'    => "al.title = 'Study Vibes'",
];

$condition = $moodMap[strtolower($mood)] ?? "1=1";

$query = "SELECT s.id, s.title, s.duration, s.audio_url, s.lyrics,
          al.title AS album, al.cover_url,
          ar.name AS artist
          FROM songs s
          JOIN albums al ON s.album_id = al.id
          JOIN artists ar ON al.artist_id = ar.id
          WHERE $condition
          ORDER BY s.id ASC";

$result = $conn->query($query);
if (!$result) {
    sendResponse(false, "Query error: " . $conn->error, null, 500);
}

$songs = [];
while ($row = $result->fetch_assoc()) {
    $songs[] = $row;
}

sendResponse(true, "Mood playlist berhasil diambil", $songs, 200);
?>