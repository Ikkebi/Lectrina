<?php

require_once __DIR__ . "/../includes/database.php";
require_once __DIR__ . "/../includes/require_token.php";

global $user;

if (!isset($_GET["book_id"])) {
    echo json_encode([
        "status" => false,
        "message" => "Please provide a book id",
    ]);
    die();
}

$book_id = $_GET["book_id"];

$statement = database()->prepare("SELECT COUNT(*) FROM book WHERE id = ?");
$statement->execute([$book_id]);

if (!$statement->fetchColumn()) {
    echo json_encode([
        "status" => false,
        "message" => "That book does not exist!",
    ]);
    die();
}

$statement = database()->prepare("UPDATE user SET active_book_id = ? WHERE id = ?");
$result    = $statement->execute([$book_id, $user["id"]]);

if (!$result) {
    echo json_encode([
        "status" => false,
        "message" => "An unexpected error occured",
    ]);
    die();
}

echo json_encode([
    "status" => true
]);
