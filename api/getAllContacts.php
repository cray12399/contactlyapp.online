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

// Optional search parameter
$search = isset($_GET['search']) ? trim($_GET['search']) : '';

if ($search === '') {

    // Get all contacts
    $stmt = $conn->prepare(
        'SELECT id, userID, firstName, lastName, email, phoneNumber, dateCreated, dateUpdated
         FROM Contacts
         ORDER BY lastName, firstName'
    );

} else {

    // Search contacts
    $searchTerm = '%' . $search . '%';

    $stmt = $conn->prepare(
        'SELECT id, userID, firstName, lastName, email, phoneNumber, dateCreated, dateUpdated
         FROM Contacts
         WHERE firstName LIKE ?
            OR lastName LIKE ?
            OR email LIKE ?
            OR phoneNumber LIKE ?
         ORDER BY lastName, firstName'
    );

    $stmt->bind_param(
        'ssss',
        $searchTerm,
        $searchTerm,
        $searchTerm,
        $searchTerm
    );
}

if (!$stmt->execute()) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Failed to retrieve contacts'
    ]);
    $stmt->close();
    $conn->close();
    exit;
}

$result = $stmt->get_result();

$contacts = [];

while ($row = $result->fetch_assoc()) {
    $contacts[] = $row;
}

http_response_code(200);

echo json_encode([
    'contacts' => $contacts
]);

$stmt->close();
$conn->close();
