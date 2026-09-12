<?php
// Copy this file to includes/db.php and fill in your own values.
// includes/db.php is gitignored. Never commit real credentials.

$db_host = 'localhost';
$db_name = 'contactsdb';
$db_user = 'contactly';
$db_pass = 'your-local-password';

$conn = new mysqli($db_host, $db_user, $db_pass, $db_name);

if ($conn->connect_error) {
    die('Database connection failed: ' . $conn->connect_error);
}
