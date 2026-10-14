<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, "Metode tidak diizinkan", null, 405);
}

$input = json_decode(file_get_contents("php://input"), true);

if (empty($input['email']) || empty($input['password'])) {
    sendResponse(false, "Email dan password wajib diisi", null, 400);
}

$email = $conn->real_escape_string($input['email']);
$password = $input['password'];

$query = "SELECT id, username, email, password FROM users WHERE email = '$email'";
$result = $conn->query($query);

if ($result->num_rows === 0) {
    sendResponse(false, "Email tidak ditemukan", null, 404);
}

$user = $result->fetch_assoc();

if (!password_verify($password, $user['password'])) {
    sendResponse(false, "Password salah");
}

unset($user['password']);
sendResponse(true, "Login berhasil", $user, 200);
?>
