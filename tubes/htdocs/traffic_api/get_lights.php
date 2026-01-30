<?php
require_once __DIR__ . '/db.php';

$mysqli = get_db();

$sql = "SELECT id, junction_id, direction, lat, lng, status FROM traffic_light ORDER BY junction_id, id";
if ($res = $mysqli->query($sql)) {
    $rows = [];
    while ($row = $res->fetch_assoc()) {
        $rows[] = $row;
    }
    json_ok($rows);
    $res->free();
} else {
    http_response_code(500);
    echo json_encode(['error' => 'Query failed']);
}

$mysqli->close();
?>