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
    $credentialsFile = getenv("WP_CREDENTIALS_FILE");
    if (!file_exists($credentialsFile)) {
        fwrite(STDERR, "Error: Credentials file not found at {$credentialsFile}\n");
        exit(1);
    }
    $credentials = file_get_contents($credentialsFile);
    if ($credentials === false) {
        fwrite(STDERR, "Error: Unable to read credentials file\n");
        exit(1);
    }

    $parsedCredentials = json_decode($credentials, true);

    wp_install(
        SITE_NAME,
        $parsedCredentials['ADMIN']['USERNAME'],
        $parsedCredentials['ADMIN']['EMAIL'],
        true,
        user_password: $parsedCredentials['ADMIN']['PASSWORD'],
        language: WPLANG
    );
    wp_create_user(
        $parsedCredentials['USER']['USERNAME'],
        $parsedCredentials['USER']['PASSWORD'],
        $parsedCredentials['USER']['EMAIL'],
    );
}

$dbConnection->close();
