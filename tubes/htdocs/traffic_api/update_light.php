<?php
// update_light.php - accepts JSON POST {id, status}
require_once __DIR__ . '/db.php';

$input = json_decode(file_get_contents('php://input'), true);
if (!is_array($input)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid JSON']);
    exit;
}

$id = isset($input['id']) ? (int)$input['id'] : 0;
$status = isset($input['status']) ? strtoupper(trim($input['status'])) : '';
$allowed = ['RED','YELLOW','GREEN'];

if ($id <= 0 || !in_array($status, $allowed, true)) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing or invalid parameters']);
    exit;
}

$mysqli = get_db();
$stmt = $mysqli->prepare("UPDATE traffic_light SET status=? WHERE id=?");
$stmt->bind_param('si', $status, $id);
if ($stmt->execute()) {
    json_ok(['success' => true]);
} else {
    http_response_code(500);
    echo json_encode(['error' => 'Update failed']);
}
$stmt->close();
$mysqli->close();
?>