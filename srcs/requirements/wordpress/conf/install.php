<?php
define('WP_INSTALLING', true);

require_once __DIR__ . '/wp-load.php';
require_once ABSPATH . 'wp-admin/includes/upgrade.php';

const MAX_DB_TRIES = 30;
const SITE_NAME = "Qvan-ste's site";

$tries = 0;
while ($tries < MAX_DB_TRIES) {
    $dbConnection = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
    if (!$dbConnection->connect_error) {
        break;
    }
    sleep(2);
    $tries++;
}

if ($tries == MAX_DB_TRIES) {
    fwrite(STDERR, "Error: Unable to connect to MariaDB\n");
    exit(1);
}

$isInstalled = false;
try {
    $result = $dbConnection->query("SHOW TABLES LIKE 'wp_options'");
    if ($result && $result->num_rows > 0) {
        $isInstalled = true;
    }
} catch (Exception $e) {
    $isInstalled = false;
    fwrite(STDERR, "Error: {$e->getMessage()}");
}

if (!$isInstalled) {
    wp_install(
        SITE_NAME,
        getenv('WP_ADMIN'),
        getenv('WP_ADMIN_EMAIL'),
        true,
        user_password: getenv('WP_ADMIN_PASSWORD'),
        language: "en_US"
    );
    wp_create_user(
        getenv('WP_USER'),
        getenv('WP_USER_PASSWORD'),
        getenv('WP_USER_EMAIL')
    );
}

$dbConnection->close();
