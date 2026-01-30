<?php
require_once __DIR__ . '/db.php';

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
if ($id <= 0) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing or invalid id']);
    exit;
}

$mysqli = get_db();
$stmt = $mysqli->prepare("SELECT id, junction_id, direction, lat, lng, status FROM traffic_light WHERE id = ? LIMIT 1");
$stmt->bind_param('i', $id);
$stmt->execute();
$res = $stmt->get_result();
if ($row = $res->fetch_assoc()) {
    json_ok($row);
} else {
    http_response_code(404);
    echo json_encode(['error' => 'Not found']);
}
$stmt->close();
$mysqli->close();
?>