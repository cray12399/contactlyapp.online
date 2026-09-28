<?php

header('Content-Type: application/json');

require_once __DIR__ . '/../includes/db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'PUT') {
    http_response_code(405);
    echo json_encode([
        'error' => 'Method not allowed'
    ]);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

if (
    !isset($data['id']) ||
    !isset($data['firstName']) ||
    !isset($data['lastName']) ||
    !isset($data['userName']) ||
    !isset($data['email'])
) {
    http_response_code(400);
    echo json_encode([
        'error' => 'Missing required fields'
    ]);
    exit;
}

$id = (int) $data['id'];
$firstName = trim($data['firstName']);
$lastName = trim($data['lastName']);
$userName = trim($data['userName']);
$email = trim($data['email']);
$phoneNumber = isset($data['phoneNumber']) ? trim($data['phoneNumber']) : '';
$role = isset($data['role']) ? (int) $data['role'] : null;

if (
    $firstName === '' ||
    $lastName === '' ||
    $userName === '' ||
    $email === ''
) {
    http_response_code(400);
    echo json_encode([
        'error' => 'All fields are required'
    ]);
    exit;
}

// Dynamically handle query depending on whether a role update is present
if ($role !== null) {
    $stmt = $conn->prepare(
        'UPDATE Users
         SET firstName = ?,
             lastName = ?,
             userName = ?,
             email = ?,
             phoneNumber = ?,
             role = ?
         WHERE id = ?'
    );

    $stmt->bind_param(
        'sssssii',
        $firstName,
        $lastName,
        $userName,
        $email,
        $phoneNumber,
        $role,
        $id
    );
} else {
    $stmt = $conn->prepare(
        'UPDATE Users
         SET firstName = ?,
             lastName = ?,
             userName = ?,
             email = ?,
             phoneNumber = ?
         WHERE id = ?'
    );

    $stmt->bind_param(
        'sssssi',
        $firstName,
        $lastName,
        $userName,
        $email,
        $phoneNumber,
        $id
    );
}

if ($stmt->execute()) {
    http_response_code(200);
    echo json_encode([
        'message' => 'Profile updated successfully'
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        'error' => 'Failed to update profile'
    ]);
}

$stmt->close();
$conn->close();