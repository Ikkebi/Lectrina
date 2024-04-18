<?php

const DB_HOST = "mysql81.unoeuro.com";
const DB_USER = "lectrina_dk";
const DB_PASS = "xRA4edzDHkth9fw3gb6y";
const DB_DB = "lectrina_dk_db";

function database(): PDO {
    // static gør at $db variablen bliver genbrugt hver gang database() bliver kørt
    // det gør at den samme forbindelse bliver brugt
    static $db;

    if (!$db) {
        // Opret forbindelse til databasen
        $db = new PDO(
            "mysql:host=" . DB_HOST . ";dbname=" . DB_DB . ";charset=utf8mb4",
            DB_USER,
            DB_PASS
        );
    }

    return $db;
}
