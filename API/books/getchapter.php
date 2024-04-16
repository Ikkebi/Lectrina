<?php

require_once "../includes/database.php";

require_once "../includes/require_token.php";

if (!isset($_GET["chapter_id"])) {
    echo json_encode([
        "status" => false,
        "message" => "Please specify a chapter",
    ]);
    die();
}

$chapter_id = $_GET["chapter_id"];

$statement = database()->prepare("SELECT COUNT(*) FROM chapter WHERE id = ?");
$statement->execute([$chapter_id]);

if (!$statement->fetchColumn()) {
    echo json_encode([
        "status" => false,
        "message" => "This chapter does not exist",
    ]);
    die();
}

$statement = database()->prepare("SELECT id, name, content FROM chapter WHERE id = ?");
$statement->execute([$chapter_id]);
$chapter = $statement->fetch(PDO::FETCH_ASSOC);

if (!$chapter) {
    echo json_encode([
        "status" => false,
        "message" => "An unexpected error occurred",
    ]);
    die();
}

echo json_encode([
    "status" => true,
    "chapter" => $chapter,
]);
