<?php
$env = parse_ini_file(__DIR__ . '/../.env');

if ($env === false) {
    die('Missing .env file. Copy .env.example to .env and fill it in.');
}

$conn = new mysqli(
    $env['DB_HOST'],
    $env['DB_USER'],
    $env['DB_PASS'],
    $env['DB_NAME']
);

if ($conn->connect_error) {
    die('Database connection failed: ' . $conn->connect_error);
}
