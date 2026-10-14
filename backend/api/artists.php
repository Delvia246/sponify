<?php
require_once '../config/database.php';
require_once '../helpers/response.php';

$query = "SELECT a.id, a.name, a.image_url,
          (SELECT COUNT(*) FROM albums WHERE artist_id = a.id) as album_count
          FROM artists a
          ORDER BY a.name ASC";
$result = $conn->query($query);
if (!$result) {
    sendResponse(false, "Query error: " . $conn->error, null, 500);
}
$artists = [];
while ($row = $result->fetch_assoc()) {
    $artists[] = $row;
}
sendResponse(true, "OK", $artists, 200);
?>