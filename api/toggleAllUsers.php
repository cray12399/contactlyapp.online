<?php
header('Content-Type: application/json');

require_once __DIR__ . '/../includes/db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'PUT') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['enabled'])) {
    http_response_code(400);
    echo json_encode(['error' => 'enabled is required']);
    exit;
}

$enabled = (bool) $data['enabled'];
$newRole = $enabled ? 1 : 0;

// Only affect regular users.
// Admins (role = 2) are never changed.
$stmt = $conn->prepare(
    'UPDATE Users
     SET role = ?
     WHERE role IN (0, 1)'
);

$stmt->bind_param('i', $newRole);

if (!$stmt->execute()) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to update users']);
    $stmt->close();
    $conn->close();
    exit;
}

http_response_code(200);
echo json_encode([
    'message' => $enabled
        ? 'All regular users enabled successfully'
        : 'All regular users disabled successfully'
]);

$stmt->close();
$conn->close();
