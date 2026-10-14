<?php
$host = "localhost";
$username = "root";
$password = ""; // Di XAMPP Mac biasanya kosong
$database = "sponify_db";

$conn = new mysqli($host, $username, $password, $database);

if ($conn->connect_error) {
    die(json_encode([
        "success" => false,
        "message" => "Koneksi database gagal: " . $conn->connect_error
    ]));
}
?>