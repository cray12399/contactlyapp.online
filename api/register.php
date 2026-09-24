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
    !isset($data['email']) ||
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
$email = trim($data['email']);
$phoneNumber = isset($data['phoneNumber']) ? trim($data['phoneNumber']) : '';
$password = $data['password'];

// Make sure required fields are not empty
if (
    $firstName === '' ||
    $lastName === '' ||
    $userName === '' ||
    $email === '' ||
    $password === ''
) {
    http_response_code(400);
    echo json_encode([
        'error' => 'All required fields must be filled'
    ]);
    exit;
}

// Check whether the username or email already exists
$stmt = $conn->prepare(
    'SELECT userName, email FROM Users WHERE userName = ? OR email = ?'
);

$stmt->bind_param('ss', $userName, $email);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $existingUser = $result->fetch_assoc();
    $errorMessage = 'Username or email already exists';

    if (strcasecmp($existingUser['userName'], $userName) === 0) {
        $errorMessage = 'Username already exists';
    } else if (strcasecmp($existingUser['email'], $email) === 0) {
        $errorMessage = 'Email already exists';
    }

    http_response_code(409);
    echo json_encode([
        'error' => $errorMessage
    ]);
    $stmt->close();
    $conn->close();
    exit;
}

// Hash the password before storing it
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

// Create the new user
$stmt = $conn->prepare(
    'INSERT INTO Users (firstName, lastName, userName, email, phoneNumber, password)
     VALUES (?, ?, ?, ?, ?, ?)'
);

$stmt->bind_param(
    'ssssss',
    $firstName,
    $lastName,
    $userName,
    $email,
    $phoneNumber,
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