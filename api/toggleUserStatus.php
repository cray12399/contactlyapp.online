<?php
header('Content-Type: application/json');

require_once __DIR__ . '/../includes/db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'PUT') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['userId']) || !isset($data['enabled'])) {
    http_response_code(400);
    echo json_encode(['error' => 'userId and enabled are required']);
    exit;
}

$userId = (int) $data['userId'];
$enabled = (bool) $data['enabled'];

// Only regular users can be changed.
// Admins (role = 2) are left untouched.
$newRole = $enabled ? 1 : 0;

$stmt = $conn->prepare(
    'UPDATE Users
     SET role = ?
     WHERE id = ? AND role IN (0, 1)'
);

$stmt->bind_param('ii', $newRole, $userId);

if (!$stmt->execute()) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to update user status']);
    $stmt->close();
    $conn->close();
    exit;
}

if ($stmt->affected_rows === 0) {
    // Could mean the user doesn't exist or is an admin.
    http_response_code(404);
    echo json_encode(['error' => 'User not found or user is an admin']);
    $stmt->close();
    $conn->close();
    exit;
}

http_response_code(200);
echo json_encode([
    'message' => $enabled
        ? 'User enabled successfully'
        : 'User disabled successfully'
]);

$stmt->close();
$conn->close();
