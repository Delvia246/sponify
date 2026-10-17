<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

$method = $_SERVER['REQUEST_METHOD'];

// ============ GET: Ambil daftar lagu yang disukai ============
if ($method === 'GET') {
    $user_id = $_GET['user_id'] ?? null;
    if (!$user_id) {
        sendResponse(false, "user_id wajib diisi", null, 400);
    }
    $user_id = $conn->real_escape_string($user_id);

    $query = "SELECT s.id, s.title, s.duration, s.audio_url, 
              s.album_id, al.artist_id,
              al.title AS album, al.cover_url,
              ar.name AS artist
              FROM liked_songs ls
              JOIN songs s ON ls.song_id = s.id
              JOIN albums al ON s.album_id = al.id
              JOIN artists ar ON al.artist_id = ar.id
              WHERE ls.user_id = '$user_id'
              ORDER BY ls.liked_at DESC";

    $result = $conn->query($query);
    if (!$result) {
        sendResponse(false, "Query error: " . $conn->error, null, 500);
    }
    $songs = [];
    while ($row = $result->fetch_assoc()) {
        $songs[] = $row;
    }
    sendResponse(true, "OK", $songs, 200);
}

// ============ POST: Toggle like/unlike ============
elseif ($method === 'POST') {
    $input = json_decode(file_get_contents("php://input"), true);

    if (empty($input['user_id']) || empty($input['song_id'])) {
        sendResponse(false, "user_id dan song_id wajib diisi", null, 400);
    }
    $user_id = $conn->real_escape_string($input['user_id']);
    $song_id = $conn->real_escape_string($input['song_id']);

    // Cek apakah lagu udah di-like
    $cek = $conn->query(
        "SELECT id FROM liked_songs WHERE user_id = '$user_id' AND song_id = '$song_id'"
    );

    if ($cek->num_rows > 0) {
        // Sudah di-like → unlike
        $conn->query("DELETE FROM liked_songs WHERE user_id = '$user_id' AND song_id = '$song_id'");
        sendResponse(true, "Lagu di-unlike", ["liked" => false], 200);
    } else {
        // Belum di-like → like
        $conn->query("INSERT INTO liked_songs (user_id, song_id) VALUES ('$user_id', '$song_id')");
        sendResponse(true, "Lagu di-like", ["liked" => true], 201);
    }
}

// ============ DELETE: Unlike ============
elseif ($method === 'DELETE') {
    parse_str(file_get_contents("php://input"), $input);
    $user_id = $_GET['user_id'] ?? ($input['user_id'] ?? null);
    $song_id = $_GET['song_id'] ?? ($input['song_id'] ?? null);

    if (!$user_id || !$song_id) {
        sendResponse(false, "user_id dan song_id wajib diisi", null, 400);
    }
    $user_id = $conn->real_escape_string($user_id);
    $song_id = $conn->real_escape_string($song_id);

    $conn->query("DELETE FROM liked_songs WHERE user_id = '$user_id' AND song_id = '$song_id'");
    sendResponse(true, "Lagu di-unlike", null, 200);
}

else {
    sendResponse(false, "Method tidak diizinkan", null, 405);
}
?>