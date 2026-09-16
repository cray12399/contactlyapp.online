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

// Check that all required fields were provided
if (
    !isset($data['firstName']) ||
    !isset($data['lastName']) ||
    !isset($data['userName']) ||
    !isset($data['password'])
) {
    http_response_code(400);
    echo json_encode([
        'error' => 'Missing required fields'
    ]);
    exit;
}

// Get the values from the request
$firstName = trim($data['firstName']);
$lastName = trim($data['lastName']);
$userName = trim($data['userName']);
$password = $data['password'];

// Make sure none of the fields are empty
if (
    $firstName === '' ||
    $lastName === '' ||
    $userName === '' ||
    $password === ''
) {
    http_response_code(400);
    echo json_encode([
        'error' => 'All fields are required'
    ]);
    exit;
}

// Check whether the username already exists
$stmt = $conn->prepare(
    'SELECT id FROM Users WHERE userName = ?'
);

$stmt->bind_param('s', $userName);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    http_response_code(409);
    echo json_encode([
        'error' => 'Username already exists'
    ]);
    $stmt->close();
    $conn->close();
    exit;
}

// Hash the password before storing it
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

// Create the new user
$stmt = $conn->prepare(
    'INSERT INTO Users (firstName, lastName, userName, password)
     VALUES (?, ?, ?, ?)'
);

$stmt->bind_param(
    'ssss',
    $firstName,
    $lastName,
    $userName,
    $hashedPassword
);

// Execute the INSERT
if ($stmt->execute()) {
    http_response_code(201);
    echo json_encode([
        'message' => 'User registered successfully'
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        'error' => 'Registration failed'
    ]);
}

$stmt->close();
$conn->close();
