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

// Vi kører en SQL query for at finde brugeren med det indtastede brugernavn
$statement = database()->prepare("SELECT * FROM user WHERE username = ?");
$statement->execute([$username]);
$db_user = $statement->fetch(PDO::FETCH_ASSOC);

// Vi tjekker om brugeren findes og om deres password er korrekt
if (!$db_user || !password_verify($password, $db_user["password"])) {
    echo json_encode([
        "status" => false,
        "message" => "Incorrect username or password",
    ]);
    die();
}

// Vi har verificeret at brugernavnet og koden er rigtig, nu vil vi lave en ny "session" til brugeren
$token = base64_encode(random_bytes(32));

// Opret session i databasen
$statement = database()->prepare("INSERT INTO user_session (user_id, token) VALUES (?, ?)");
$result = $statement->execute([$db_user["id"], $token]);

if (!$result) {
    // Burde ikke ske
    echo json_encode([
        "status" => false,
        "message" => "An unexpected error occured",
    ]);
    die();
}

require_once "../includes/utils/streakchecker.php";

$streak_checker = new StreakChecker($db_user);
$streak_checker->check(true);

if ($streak_checker->isExpired()) {
    $streak = 0;
} else {
    $streak = $db_user["streak"];
}

// Send token tilbage til godot
echo json_encode([
    "status" => true,
    "token" => $token,
    "streak" => $streak,
]);
