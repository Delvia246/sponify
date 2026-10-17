<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, "Metode tidak diizinkan", null, 405);
}

$input = json_decode(file_get_contents("php://input"), true);

if (empty($input['user_id']) || empty($input['username'])) {
    sendResponse(false, "user_id dan username wajib diisi", null, 400);
}

$user_id = $conn->real_escape_string($input['user_id']);
$username = $conn->real_escape_string($input['username']);

// Cek apakah username sudah dipakai user lain
$cek = $conn->query("SELECT id FROM users WHERE username = '$username' AND id != '$user_id'");
if ($cek->num_rows > 0) {
    sendResponse(false, "Username sudah digunakan", null, 409);
}

$query = "UPDATE users SET username = '$username' WHERE id = '$user_id'";
if ($conn->query($query)) {
    sendResponse(true, "Profil berhasil diperbarui", null, 200);
} else {
    sendResponse(false, "Gagal memperbarui profil: " . $conn->error, null, 500);
}
?>