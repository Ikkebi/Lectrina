<?php

require_once "../includes/database.php";

require_once "../includes/require_token.php";

$books = database()->query("SELECT * FROM book")->fetchAll(PDO::FETCH_ASSOC);

$formatted_books = [];

foreach ($books as $book) {
    $formatted_books[] = [
        "id" => (int)$book["id"],
        "name" => $book["name"],
        "author" => $book["author"],
        "isbn" => $book["isbn"],
        "cover_url" => $book["cover_url"],
    ];
}

echo json_encode([
    "status" => true,
    "books" => $formatted_books,
]);