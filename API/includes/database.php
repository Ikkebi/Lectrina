<?php

const DB_HOST = "mysql81.unoeuro.com";
const DB_USER = "lectrina_dk";
const DB_PASS = "xRA4edzDHkth9fw3gb6y";
const DB_DB = "lectrina_dk_db";

function database(): PDO {
    static $db;

    if (!$db) {
        $db = new PDO(
            "mysql:host=" . DB_HOST . ";dbname=" . DB_DB,
            DB_USER,
            DB_PASS
        );
    }

    return $db;
}
