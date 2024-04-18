<?php

require_once __DIR__ . "/../includes/database.php";
require_once __DIR__ . "/../includes/require_token.php";

global $user;

const DEFAULT_EXP_GIVEN_FOR_ASSIGNMENT = 30;

if (!isset($_GET["assignment_id"])) {
    echo json_encode([
        "status" => false,
        "message" => "Please specify an assignment",
    ]);
    die();
}

$assignment_id = $_GET["assignment_id"];

$statement = database()->prepare("SELECT * FROM assignment WHERE id = ?");
$statement->execute([$assignment_id]);
$assignment = $statement->fetch();

if (!$assignment) {
    echo json_encode([
        "status" => false,
        "message" => "This assignment does not exist",
    ]);
    die();
}

$statement = database()->prepare("SELECT completed FROM user_assignment_progress WHERE user_id = ? AND assignment_id = ?");
$statement->execute([$user["id"], $assignment_id]);
$completed = $statement->fetchColumn();

if ($completed) {
    // Brugeren har allerede løst det her på et tidspunkt, men det er ikke en fejl, så vi siger bare at de ikke har fået noget xp
    echo json_encode([
        "status" => true,
        "exp_given" => 0,
    ]);
    die();
}

/*
 * Nu skal vi:
 *
 * 1. gemme at brugeren har løst opgaven
 * 2. give brugeren exp :3
 */

$exp_given = $assignment["exp"] ?? DEFAULT_EXP_GIVEN_FOR_ASSIGNMENT;

database()->beginTransaction();

database()
    ->prepare("UPDATE user SET exp = exp + ? WHERE id = ?")
    ->execute([$exp_given, $user["id"]]);

database()
    ->prepare("INSERT INTO user_assignment_progress (user_id, assignment_id, completed) VALUES (?, ?, ?)")
    ->execute([$user["id"], $assignment_id, 1]);

if (!database()->commit()) {
    echo json_encode([
        "status" => false,
        "message" => "An unexpected error occured >:(",
    ]);
    die();
}

require_once "../includes/utils/streakchecker.php";

echo json_encode([
    "status" => true,
    "exp_given" => $exp_given,
]);
