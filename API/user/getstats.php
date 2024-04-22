<?php

require_once __DIR__ . "/../includes/database.php";
require_once __DIR__ . "/../includes/require_token.php";

global $user;

/**
 * Bøger læst
 * Kapitler læst
 * Streak
 * XP point
 * Opgaver klaret
 * Gennemsnit kapitler/dag
 */

// Bøger læst
$statement = database()->prepare(<<<SQL
SELECT
    (
        SELECT COUNT(*)
        FROM chapter
        WHERE book_id = b.id
    ) AS total_chapters,
    (
        SELECT COUNT(*)
        FROM user_chapter_progress ucp
        INNER JOIN chapter c
            ON c.id = ucp.chapter_id
        WHERE 
            c.book_id = b.id
            AND ucp.user_id = ?
    ) AS chapters_read
FROM book b
SQL
);
$statement->execute([$user["id"]]);
$book_progresses = $statement->fetchAll(PDO::FETCH_ASSOC);

$books_read = 0;
foreach ($book_progresses as $book_progress) {
    if ($book_progress["total_chapters"] === $book_progress["chapters_read"]) {
        $books_read++;
    }
}

// Kapitler læst
$statement = database()->prepare("SELECT COUNT(*) FROM user_chapter_progress WHERE user_id = ? AND completed = 1");
$statement->execute([$user["id"]]);
$chapters_read = (int)$statement->fetchColumn();

// Opgaver klaret
$statement = database()->prepare("SELECT COUNT(*) FROM user_assignment_progress WHERE user_id = ? AND completed = 1");
$statement->execute([$user["id"]]);
$assignments_completed = (int)$statement->fetchColumn();

// Gennemsnit kapitler/dag
$user_created_at  = \DateTime::createFromFormat("Y-m-d H:i:s", $user["created_at"]);
$today            = new DateTime();
$difference       = $today->diff($user_created_at)->days + 1;
$chapters_per_day = round($chapters_read / $difference, 2);

// Færdig

echo json_encode([
    "status" => true,
    "stats" => [
        "books_read" => $books_read,
        "chapters_read" => $chapters_read,
        "streak" => (int)$user["streak"],
        "exp" => (int)$user["exp"],
        "assignments_completed" => $assignments_completed,
        "chapters_per_day" => $chapters_per_day,
    ],
]);