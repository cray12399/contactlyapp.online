<?php

header('Content-Type: application/json');

require_once __DIR__ . '/../includes/db.php';

// Only allow GET requests
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode([
        'error' => 'Method not allowed'
    ]);
    exit;
}

// Check that username was provided
if (!isset($_GET['username'])) {
    http_response_code(400);
    echo json_encode([
        'error' => 'Username is required'
    ]);
    exit;
}

$username = trim($_GET['username']);

// Make sure username isn't empty
if ($username === '') {
    http_response_code(400);
    echo json_encode([
        'error' => 'Username is required'
    ]);
    exit;
}

// Check whether username already exists
$stmt = $conn->prepare(
    'SELECT id FROM Users WHERE userName = ?'
);

$stmt->bind_param('s', $username);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo json_encode([
        'available' => false
    ]);
} else {
    echo json_encode([
        'available' => true
    ]);
}

$stmt->close();
$conn->close();
