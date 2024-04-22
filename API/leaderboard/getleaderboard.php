<?php

require_once __DIR__ . "/../includes/database.php";
require_once __DIR__ . "/../includes/require_token.php";

global $user;

$statement = database()->prepare("SELECT id, username, exp FROM user WHERE exp > 0 ORDER BY exp DESC LIMIT 100");
$statement->execute();
$users = $statement->fetchAll(PDO::FETCH_ASSOC);

$formatted_data = [];

foreach ($users as $top_user) {
    $data = [
        "username" => $top_user["username"],
        "exp" => (int)$top_user["exp"],
    ];

    if ($top_user["id"] === $user["id"]) {
        $data["username"] .= " (dig)";
    }

    $formatted_data[] = $data;
}

echo json_encode([
    "status" => true,
    "leaderboard" => $formatted_data
]);
