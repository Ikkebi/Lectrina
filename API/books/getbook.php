<?php

require_once "../includes/database.php";

require_once "../includes/require_token.php";

global $user;

if (!isset($_GET["book_id"])) {
    echo json_encode([
        "status" => false,
        "message" => "Please provide a book id",
    ]);
    die();
}

$book_id = $_GET["book_id"];

$statement = database()->prepare("SELECT * FROM book WHERE id = ?");
$statement->execute([$book_id]);
$book = $statement->fetch(PDO::FETCH_ASSOC);

if (!$book) {
    echo json_encode([
        "status" => false,
        "message" => "That book does not exist!",
    ]);
    die();
}

$statement = database()->prepare(<<<SQL
SELECT
    c.id,
    c.name,
    p.completed
FROM chapter c
LEFT JOIN user_chapter_progress p
    ON p.chapter_id = c.id AND p.user_id = ?
WHERE c.book_id = ?
ORDER BY c.idx ASC
SQL
);

$statement->execute([$user["id"], $book_id]);
$chapters = $statement->fetchAll(PDO::FETCH_ASSOC);

foreach ($chapters as &$chapter) {
    $chapter["completed"] = !!$chapter["completed"];
}

echo json_encode([
    "status" => true,
    "name" => $book["name"],
    "chapters" => $chapters,
]);
