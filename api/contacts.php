<?php

header('Content-Type: application/json');

require_once __DIR__ . '/../includes/db.php';

// Allow GET POST and PUT requests
if (
    $_SERVER['REQUEST_METHOD'] !== 'GET' &&
    $_SERVER['REQUEST_METHOD'] !== 'POST' &&
    $_SERVER['REQUEST_METHOD'] !== 'PUT' &&
    $_SERVER['REQUEST_METHOD'] !== 'DELETE'
) {
    http_response_code(405);
    echo json_encode([
        'error' => 'Method not allowed'
    ]);
    exit;
}


// GET

if ($_SERVER['REQUEST_METHOD'] === 'GET') {

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
}


// POST

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $data = json_decode(file_get_contents('php://input'), true);

    // Check required fields
    if (
        !isset($data['userID']) ||
        !isset($data['firstName']) ||
        !isset($data['lastName']) ||
        !isset($data['email']) ||
        !isset($data['phoneNumber'])
    ) {
        http_response_code(400);
        echo json_encode([
            'error' => 'Missing required fields'
        ]);
        $conn->close();
        exit;
    }

    $userID = (int) $data['userID'];
    $firstName = trim($data['firstName']);
    $lastName = trim($data['lastName']);
    $email = trim($data['email']);
    $phoneNumber = trim($data['phoneNumber']);

    // Make sure fields aren't empty
    if (
        $firstName === '' ||
        $lastName === '' ||
        $email === '' ||
        $phoneNumber === ''
    ) {
        http_response_code(400);
        echo json_encode([
            'error' => 'All fields are required'
        ]);
        $conn->close();
        exit;
    }

    // Insert contact
    $stmt = $conn->prepare(
        'INSERT INTO Contacts (userID, firstName, lastName, email, phoneNumber)
         VALUES (?, ?, ?, ?, ?)'
    );

    $stmt->bind_param(
        'issss',
        $userID,
        $firstName,
        $lastName,
        $email,
        $phoneNumber
    );

    if ($stmt->execute()) {

        http_response_code(201);

        echo json_encode([
            'message' => 'Contact added successfully',
            'id' => $stmt->insert_id
        ]);

    } else {

        http_response_code(500);

        echo json_encode([
            'error' => 'Failed to add contact'
        ]);
    }

    $stmt->close();
}

// PUT

if ($_SERVER['REQUEST_METHOD'] === 'PUT') {

    $data = json_decode(file_get_contents('php://input'), true);

    if (
        !isset($data['id']) ||
        !isset($data['userID']) ||
        !isset($data['firstName']) ||
        !isset($data['lastName']) ||
        !isset($data['email']) ||
        !isset($data['phoneNumber'])
    ) {
        http_response_code(400);
        echo json_encode([
            'error' => 'Missing required fields'
        ]);
        $conn->close();
        exit;
    }

    $id = (int) $data['id'];
    $userID = (int) $data['userID'];
    $firstName = trim($data['firstName']);
    $lastName = trim($data['lastName']);
    $email = trim($data['email']);
    $phoneNumber = trim($data['phoneNumber']);

    if (
        $firstName === '' ||
        $lastName === '' ||
        $email === '' ||
        $phoneNumber === ''
    ) {
        http_response_code(400);
        echo json_encode([
            'error' => 'All fields are required'
        ]);
        $conn->close();
        exit;
    }

    $stmt = $conn->prepare(
        'UPDATE Contacts
         SET firstName = ?, lastName = ?, email = ?, phoneNumber = ?
         WHERE id = ? AND userID = ?'
    );

    $stmt->bind_param(
        'ssssii',
        $firstName,
        $lastName,
        $email,
        $phoneNumber,
        $id,
        $userID
    );

    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        http_response_code(200);
        echo json_encode([
            'message' => 'Contact updated successfully'
        ]);
    } else {
        http_response_code(404);
        echo json_encode([
            'error' => 'Contact not found'
        ]);
    }

    $stmt->close();
}

// DELETE

if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {

    $data = json_decode(file_get_contents('php://input'), true);

    if (
        !isset($data['id']) ||
        !isset($data['userID'])
    ) {
        http_response_code(400);
        echo json_encode([
            'error' => 'id and userID are required'
        ]);
        $conn->close();
        exit;
    }

    $id = (int) $data['id'];
    $userID = (int) $data['userID'];

    $stmt = $conn->prepare(
        'DELETE FROM Contacts
         WHERE id = ? AND userID = ?'
    );

    $stmt->bind_param(
        'ii',
        $id,
        $userID
    );

    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        http_response_code(200);
        echo json_encode([
            'message' => 'Contact deleted successfully'
        ]);
    } else {
        http_response_code(404);
        echo json_encode([
            'error' => 'Contact not found'
        ]);
    }

    $stmt->close();
}

$conn->close();
