<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, "Metode tidak diizinkan", null, 405);
}

$input = json_decode(file_get_contents("php://input"), true);

if (empty($input['user_id']) || empty($input['song_id'])) {
    sendResponse(false, "user_id dan song_id wajib diisi", null, 400);
}

$user_id = $conn->real_escape_string($input['user_id']);
$song_id = $conn->real_escape_string($input['song_id']);

$query = "INSERT INTO listening_history (user_id, song_id) VALUES ('$user_id', '$song_id')";
if ($conn->query($query)) {
    sendResponse(true, "History tercatat", null, 201);
} else {
    sendResponse(false, "Gagal catat history: " . $conn->error, null, 500);
}
?>