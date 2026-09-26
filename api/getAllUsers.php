<?php
header('Content-Type: application/json');

require_once __DIR__ . '/../includes/db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$result = $conn->query(
    'SELECT id, firstName, lastName, userName, email, phoneNumber, role
     FROM Users
     ORDER BY id'
);

if (!$result) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to retrieve users']);
    $conn->close();
    exit;
}

$users = [];

while ($row = $result->fetch_assoc()) {
    $row['id'] = (int) $row['id'];
    $row['role'] = (int) $row['role'];
    $row['enabled'] = ((int) $row['role'] !== 0);

    $users[] = $row;
}

http_response_code(200);
echo json_encode(['users' => $users]);

$result->free();
$conn->close();
