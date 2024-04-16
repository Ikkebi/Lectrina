<?php

require_once "../includes/database.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    echo json_encode([
        "status" => false,
        "message" => "Invalid method",
    ]);
    die();
}

if (!isset($_POST["username"]) || !isset($_POST["password"])) {
    echo json_encode([
        "status" => false,
        "message" => "Username and password is required",
    ]);
    die();
}

$username = $_POST["username"];
$password = $_POST["password"];

$statement = database()->prepare("SELECT * FROM user WHERE username = ?");
$statement->execute([$username]);

if ($statement->fetch(PDO::FETCH_ASSOC)) {
    echo json_encode([
        "status" => false,
        "message" => "A user with this username already exists!",
    ]);
    die();
}

// Nu laver vi den nye bruger
$hashed_password = password_hash($password, PASSWORD_DEFAULT);

$statement = database()->prepare("INSERT INTO user (username, password) VALUES (?, ?)");
$result = $statement->execute([$username, $hashed_password]);

if (!$result) {
    // Burde ikke ske

    // Kan teoretisk set ske hvis to brugere prøver at registrere sig med samme brugernavn
    // inden for ekstrem lidt tid af hinanden (se: race condition) - slet efter tilføjet til rapport
    echo json_encode([
        "status" => false,
        "message" => "An unexpected error occurred",
    ]);
    die();
}

echo json_encode([
    "status" => true,
]);
