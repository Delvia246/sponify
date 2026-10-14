<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $playlist_id = $_GET['playlist_id'] ?? null;
    if (!$playlist_id) {
        sendResponse(false, "playlist_id wajib diisi", null, 400);
    }
    $playlist_id = $conn->real_escape_string($playlist_id);

    $query = "SELECT s.id, s.title, s.duration, s.audio_url,
              al.title AS album, al.cover_url,
              ar.name AS artist
              FROM playlist_songs ps
              JOIN songs s ON ps.song_id = s.id
              JOIN albums al ON s.album_id = al.id
              JOIN artists ar ON al.artist_id = ar.id
              WHERE ps.playlist_id = '$playlist_id'
              ORDER BY ps.added_at DESC";
    $result = $conn->query($query);
    if (!$result) {
        sendResponse(false, "Query error: " . $conn->error, null, 500);
    }
    $songs = [];
    while ($row = $result->fetch_assoc()) {
        $songs[] = $row;
    }
    sendResponse(true, "OK", $songs, 200);

} elseif ($method === 'POST') {
    $input = json_decode(file_get_contents("php://input"), true);
    if (empty($input['playlist_id']) || empty($input['song_id'])) {
        sendResponse(false, "playlist_id dan song_id wajib diisi", null, 400);
    }
    $playlist_id = $conn->real_escape_string($input['playlist_id']);
    $song_id = $conn->real_escape_string($input['song_id']);

    $query = "INSERT INTO playlist_songs (playlist_id, song_id) VALUES ('$playlist_id', '$song_id')";
    if ($conn->query($query)) {
        sendResponse(true, "Lagu berhasil ditambahkan", null, 201);
    } else {
        sendResponse(false, "Gagal tambah lagu: " . $conn->error, null, 500);
    }
} else {
    sendResponse(false, "Method tidak diizinkan", null, 405);
}
?>