<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendResponse(false, "Metode tidak diizinkan", null, 405);
}

$user_id = $_GET['user_id'] ?? null;
if (!$user_id) {
    sendResponse(false, "user_id wajib diisi", null, 400);
}
$user_id = $conn->real_escape_string($user_id);

// 1. Total lagu yang diputar (unique) + total play count
$totalQuery = "SELECT 
                COUNT(*) AS total_plays,
                COUNT(DISTINCT song_id) AS unique_songs
              FROM listening_history
              WHERE user_id = '$user_id'";
$totalResult = $conn->query($totalQuery);
$total = $totalResult->fetch_assoc();

// 2. Total durasi (detik)
$durationQuery = "SELECT 
                  COALESCE(SUM(s.duration), 0) AS total_duration
                  FROM listening_history lh
                  JOIN songs s ON lh.song_id = s.id
                  WHERE lh.user_id = '$user_id'";
$durationResult = $conn->query($durationQuery);
$duration = $durationResult->fetch_assoc();

// 3. Top 5 artist
$artistQuery = "SELECT 
                  ar.name AS artist,
                  ar.image_url,
                  COUNT(*) AS play_count
                FROM listening_history lh
                JOIN songs s ON lh.song_id = s.id
                JOIN albums al ON s.album_id = al.id
                JOIN artists ar ON al.artist_id = ar.id
                WHERE lh.user_id = '$user_id'
                GROUP BY ar.id, ar.name, ar.image_url
                ORDER BY play_count DESC
                LIMIT 5";
$artistResult = $conn->query($artistQuery);
$artists = [];
while ($row = $artistResult->fetch_assoc()) {
    $artists[] = $row;
}

// 4. Top 5 album
$albumQuery = "SELECT 
                al.title AS album,
                al.cover_url,
                ar.name AS artist,
                COUNT(*) AS play_count
              FROM listening_history lh
              JOIN songs s ON lh.song_id = s.id
              JOIN albums al ON s.album_id = al.id
              JOIN artists ar ON al.artist_id = ar.id
              WHERE lh.user_id = '$user_id'
              GROUP BY al.id, al.title, al.cover_url, ar.name
              ORDER BY play_count DESC
              LIMIT 5";
$albumResult = $conn->query($albumQuery);
$albums = [];
while ($row = $albumResult->fetch_assoc()) {
    $albums[] = $row;
}

// 5. Top 5 lagu  ← INI YANG DIPERBAIKI
$songQuery = "SELECT 
              s.title,
              al.cover_url,
              ar.name AS artist,
              COUNT(*) AS play_count
            FROM listening_history lh
            JOIN songs s ON lh.song_id = s.id
            JOIN albums al ON s.album_id = al.id
            JOIN artists ar ON al.artist_id = ar.id
            WHERE lh.user_id = '$user_id'
            GROUP BY s.id, s.title, al.cover_url, ar.name
            ORDER BY play_count DESC
            LIMIT 5";
$songResult = $conn->query($songQuery);
$songs = [];
while ($row = $songResult->fetch_assoc()) {
    $songs[] = $row;
}

// Response
sendResponse(true, "Statistik berhasil diambil", [
    "total_plays" => (int) $total['total_plays'],
    "unique_songs" => (int) $total['unique_songs'],
    "total_duration" => (int) $duration['total_duration'],
    "top_artists" => $artists,
    "top_albums" => $albums,
    "top_songs" => $songs,
], 200);
?>