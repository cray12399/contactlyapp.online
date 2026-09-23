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

// Check that userID was provided
if (!isset($_GET['userID'])) {
    http_response_code(400);
    echo json_encode([
        'error' => 'userID is required'
    ]);
    exit;
}

$userID = (int) $_GET['userID'];

// Optional search parameter
$search = isset($_GET['search']) ? trim($_GET['search']) : '';

if ($search === '') {

    $stmt = $conn->prepare(
        'SELECT id, userID, firstName, lastName, email, phoneNumber, dateCreated, dateUpdated
         FROM Contacts
         WHERE userID = ?
         ORDER BY lastName, firstName'
    );

    $stmt->bind_param('i', $userID);

} else {

    $searchTerm = '%' . $search . '%';

    $stmt = $conn->prepare(
        'SELECT id, userID, firstName, lastName, email, phoneNumber, dateCreated, dateUpdated
         FROM Contacts
         WHERE userID = ?
         AND (
             firstName LIKE ?
             OR lastName LIKE ?
             OR email LIKE ?
             OR phoneNumber LIKE ?
         )
         ORDER BY lastName, firstName'
    );

    $stmt->bind_param(
        'issss',
        $userID,
        $searchTerm,
        $searchTerm,
        $searchTerm,
        $searchTerm
    );
}

$stmt->execute();

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
