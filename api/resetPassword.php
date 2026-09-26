<?php
header('Content-Type: application/json');

require_once __DIR__ . '/../includes/db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'PUT') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['userId']) || !isset($data['newPassword'])) {
    http_response_code(400);
    echo json_encode(['error' => 'userId and newPassword are required']);
    exit;
}

$userId = (int) $data['userId'];
$newPassword = $data['newPassword'];

if ($userId <= 0 || $newPassword === '') {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid userId or password']);
    exit;
}

$hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);

$stmt = $conn->prepare(
    'UPDATE Users
     SET password = ?
     WHERE id = ?'
);

$stmt->bind_param('si', $hashedPassword, $userId);

if (!$stmt->execute()) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to reset password']);
    $stmt->close();
    $conn->close();
    exit;
}

if ($stmt->affected_rows === 0) {
    http_response_code(404);
    echo json_encode(['error' => 'User not found']);
    $stmt->close();
    $conn->close();
    exit;
}

http_response_code(200);
echo json_encode([
    'message' => 'Password reset successfully'
]);

$stmt->close();
$conn->close();
