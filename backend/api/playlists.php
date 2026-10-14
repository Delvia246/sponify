<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $user_id = $_GET['user_id'] ?? null;
    if (!$user_id) {
        sendResponse(false, "user_id wajib diisi", null, 400);
    }
    $user_id = $conn->real_escape_string($user_id);
    $query = "SELECT p.id, p.name, p.description,
              (SELECT COUNT(*) FROM playlist_songs ps WHERE ps.playlist_id = p.id) as song_count
              FROM playlists p
              WHERE p.user_id = '$user_id'
              ORDER BY p.created_at DESC";
    $result = $conn->query($query);
    if (!$result) {
        sendResponse(false, "Query error: " . $conn->error, null, 500);
    }
    $playlists = [];
    while ($row = $result->fetch_assoc()) {
        $playlists[] = $row;
    }
    sendResponse(true, "OK", $playlists, 200);

} elseif ($method === 'POST') {
    $input = json_decode(file_get_contents("php://input"), true);
    if (empty($input['user_id']) || empty($input['name'])) {
        sendResponse(false, "user_id dan name wajib diisi", null, 400);
    }
    $user_id = $conn->real_escape_string($input['user_id']);
    $name = $conn->real_escape_string($input['name']);
    $description = $conn->real_escape_string($input['description'] ?? '');

    $query = "INSERT INTO playlists (user_id, name, description) VALUES ('$user_id', '$name', '$description')";
    if ($conn->query($query)) {
        sendResponse(true, "Playlist berhasil dibuat", ["id" => $conn->insert_id], 201);
    } else {
        sendResponse(false, "Gagal bikin playlist: " . $conn->error, null, 500);
    }
} else {
    sendResponse(false, "Method tidak diizinkan", null, 405);
}
?>