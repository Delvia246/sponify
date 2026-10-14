<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, "Metode tidak diizinkan", null, 405);
}

$input = json_decode(file_get_contents("php://input"), true);

if (empty($input['username']) || empty($input['email']) || empty($input['password'])) {
    sendResponse(false, "Username, email, dan password wajib diisi", null, 400);
}

$username = $conn->real_escape_string($input['username']);
$email = $conn->real_escape_string($input['email']);
$password = password_hash($input['password'], PASSWORD_BCRYPT);

$cek = $conn->query("SELECT id FROM users WHERE email = '$email' OR username = '$username'");
if ($cek->num_rows > 0) {
    sendResponse(false, "Username atau email sudah terdaftar", null, 409);
}

$query = "INSERT INTO users (username, email, password) VALUES ('$username', '$email', '$password')";
if ($conn->query($query)) {
    sendResponse(true, "Registrasi berhasil", ["id" => $conn->insert_id], 201);
} else {
    sendResponse(false, "Registrasi gagal: " . $conn->error, null, 500);
}
?>