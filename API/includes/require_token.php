<?php

global $user;

require_once __DIR__ . "/database.php";

if (!isset($_SERVER["HTTP_X_TOKEN"])) {
    echo json_encode([
        "status" => false,
        "message" => "Unauthenticated",
    ]);
    die();
}

$token = $_SERVER["HTTP_X_TOKEN"];

$statement = database()->prepare(<<<SQL
    SELECT * FROM user
    WHERE id = (
        SELECT user_id FROM user_session WHERE token = ?
    )
SQL
);

$statement->execute([$token]);
$user = $statement->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    echo json_encode([
        "status" => false,
        "message" => "Unauthenticated",
    ]);
    die();
}