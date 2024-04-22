<?php

require_once __DIR__ . "/../includes/database.php";
require_once __DIR__ . "/../includes/require_token.php";

global $user;

$statement = database()->prepare(<<<SQL
SELECT * FROM assignment
WHERE
    id NOT IN (
        SELECT assignment_id
        FROM user_assignment_progress
        WHERE
            user_id = ?
            AND completed = 1
    )
ORDER BY RAND()
LIMIT 1
SQL
);

$statement->execute([$user["id"]]);
$assignment = $statement->fetch(PDO::FETCH_ASSOC) ?: null;

if ($assignment) {
    $assignment["id"] = (int)$assignment["id"];
    $assignment["exp"] = (int)$assignment["exp"];
    $assignment["correct_answer"] = (int)$assignment["correct_answer"];
}

echo json_encode([
    "status" => true,
    "assignment" => $assignment
]);
