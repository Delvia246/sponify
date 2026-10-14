<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

$query = "SELECT al.id, al.title, al.cover_url, al.release_year,
          ar.name as artist,
          (SELECT COUNT(*) FROM songs WHERE album_id = al.id) as song_count
          FROM albums al
          JOIN artists ar ON al.artist_id = ar.id
          ORDER BY al.title ASC";
$result = $conn->query($query);
if (!$result) {
    sendResponse(false, "Query error: " . $conn->error, null, 500);
}
$albums = [];
while ($row = $result->fetch_assoc()) {
    $albums[] = $row;
}
sendResponse(true, "OK", $albums, 200);
?>