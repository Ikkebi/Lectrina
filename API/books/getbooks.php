<?php

require_once "../includes/database.php";

require_once "../includes/require_token.php";

$books = database()->query("SELECT * FROM book")->fetchAll(PDO::FETCH_ASSOC);

$formatted_books = [];

foreach ($books as $book) {
    $formatted_books[] = [
        "id" => $book["id"],
        "name" => $book["name"],
        "cover" => base64_encode($book["cover"]),
        "author" => $book["author"],
        "isbn" => $book["isbn"],
    ];
}

echo json_encode([
    "status" => true,
    "books" => $formatted_books,
]);