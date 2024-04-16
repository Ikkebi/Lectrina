<?php

require_once "../includes/database.php";

require_once "../includes/require_token.php";

const EXP_GIVEN_FOR_CHAPTER = 100;

global $user;

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

$statement = database()->prepare("SELECT completed FROM user_chapter_progress WHERE user_id = ? AND chapter_id = ?");
$statement->execute([$user["id"], $chapter_id]);
$completed = $statement->fetchColumn();

if ($completed) {
    // Brugeren har allerede løst det her på et tidspunkt, men det er ikke en fejl, så vi siger bare at de ikke har fået noget xp
    echo json_encode([
        "status" => true,
        "exp_given" => 0,
        "streak_continued" => false,
        "new_streak" => null,
    ]);
    die();
}

/*
 * Nu skal vi:
 *
 * 1. gemme at brugeren har læst kapitlet
 * 2. give brugeren exp :3
 */

$database = database();
$database->beginTransaction();

$database
    ->prepare("UPDATE user SET exp = exp + ? WHERE id = ?")
    ->execute([EXP_GIVEN_FOR_CHAPTER, $user["id"]]);

$database
    ->prepare("INSERT INTO user_chapter_progress (user_id, chapter_id, completed) VALUES (?, ?, ?)")
    ->execute([$user["id"], $chapter_id, 1]);

if (!$database->commit()) {
    echo json_encode([
        "status" => false,
        "message" => "An unexpected error occured >:(",
    ]);
    die();
}

require_once "../includes/utils/streakchecker.php";

$streak_checker = new StreakChecker($user);
$streak_checker->check(false);

echo json_encode([
    "status" => true,
    "exp_given" => EXP_GIVEN_FOR_CHAPTER,
    "streak_continued" => $streak_checker->isIncreased(),
    "new_streak" => $streak_checker->getNewStreak(),
]);
