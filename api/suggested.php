<?php

header('Content-Type: application/json');

require_once __DIR__ . '/../includes/db.php';

// Only allow GET requests
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

if (!isset($_GET['userID'])) {
    http_response_code(400);
    echo json_encode(['error' => 'userID is required']);
    exit;
}

$userID = (int) $_GET['userID'];

/*
  LOGIC OVERVIEW:
  1. Connected Users: Registered users matching User A's contacts (by email or phone).
  2. Recommended Contacts: Contacts saved by those Connected Users.
  3. Relate Contacts: Grouped by matching email or phone.
  4. Ranking: Ordered by distinct mutual count.
  5. Exclusion: Excludes contacts User A already has saved.
*/

$stmt = $conn->prepare(
    'SELECT 
        MAX(rec.firstName) AS firstName,
        MAX(rec.lastName) AS lastName,
        MAX(rec.email) AS email,
        MAX(rec.phoneNumber) AS phoneNumber,
        COUNT(DISTINCT rec.userID) AS mutual_count
     FROM Contacts rec
     INNER JOIN Users connected_users 
        ON rec.userID = connected_users.id
     INNER JOIN Contacts user_a_contacts 
        ON (
            (user_a_contacts.email = connected_users.email AND connected_users.email != "" AND connected_users.email IS NOT NULL) OR 
            (user_a_contacts.phoneNumber = connected_users.phoneNumber AND connected_users.phoneNumber != "" AND connected_users.phoneNumber IS NOT NULL)
        )
     WHERE user_a_contacts.userID = ?
       AND rec.userID != ?
       
       AND NOT EXISTS (
           SELECT 1 
           FROM Contacts existing
           WHERE existing.userID = ?
             AND (
                 (existing.email = rec.email AND rec.email != "" AND rec.email IS NOT NULL) OR
                 (existing.phoneNumber = rec.phoneNumber AND rec.phoneNumber != "" AND rec.phoneNumber IS NOT NULL)
             )
       )
     GROUP BY 
        CASE 
            WHEN rec.email IS NOT NULL AND rec.email != "" THEN rec.email 
            ELSE rec.phoneNumber 
        END
     ORDER BY mutual_count DESC, lastName ASC, firstName ASC
     LIMIT 10'
);

$stmt->bind_param('iii', $userID, $userID, $userID);
$stmt->execute();

$result = $stmt->get_result();
$suggestions = [];

while ($row = $result->fetch_assoc()) {
    $suggestions[] = $row;
}

http_response_code(200);
echo json_encode(['suggestions' => $suggestions]);

$stmt->close();
$conn->close();