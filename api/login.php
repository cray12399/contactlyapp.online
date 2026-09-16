<?php

header('Content-Type: application/json');

require_once __DIR__ . '/../includes/db.php';

// Only allow POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'error' => 'Method not allowed'
    ]);
    exit;
}

// Read the JSON request body
$data = json_decode(file_get_contents('php://input'), true);

// Check that username and password were provided
if (
    !isset($data['userName']) ||
    !isset($data['password'])
) {
    http_response_code(400);
    echo json_encode([
        'error' => 'Username and password are required'
    ]);
    exit;
}

$userName = trim($data['userName']);
$password = $data['password'];

// Make sure the fields aren't empty
if ($userName === '' || $password === '') {
    http_response_code(400);
    echo json_encode([
        'error' => 'Username and password are required'
    ]);
    exit;
}

// Find the user by username
$stmt = $conn->prepare(
    'SELECT id, firstName, lastName, userName, password, dateCreated, dateUpdated
     FROM Users
     WHERE userName = ?'
);

$stmt->bind_param('s', $userName);
$stmt->execute();

$result = $stmt->get_result();

// Check whether the username exists
if ($result->num_rows === 0) {
    http_response_code(401);
    echo json_encode([
        'error' => 'Invalid username or password'
    ]);
    $stmt->close();
    $conn->close();
    exit;
}

$user = $result->fetch_assoc();

// Verify the password against the stored hash
if (!password_verify($password, $user['password'])) {
    http_response_code(401);
    echo json_encode([
        'error' => 'Invalid username or password'
    ]);
    $stmt->close();
    $conn->close();
    exit;
}

// Remove the password from the response
unset($user['password']);

// Successful login
http_response_code(200);
echo json_encode([
    'message' => 'Login successful',
    'user' => $user
]);

$stmt->close();
$conn->close();
