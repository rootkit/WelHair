<?php

// ==============================================================================
//
// This file is part of the WelStory.
//
// Create by Welfony Support <support@welfony.com>
// Copyright (c) 2012-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

use Ratchet\Server\IoServer;
use Ratchet\Http\HttpServer;
use Ratchet\WebSocket\WsServer;

use Welfony\WebSocket\ChatServer;

defined('APP_ENV') || define('APP_ENV', (getenv('APP_ENV') ? getenv('APP_ENV') : 'development'));

define('DS', \DIRECTORY_SEPARATOR);
define('ROOT_PATH', realpath(__DIR__ . '/../'));
define('API_ROOT_PATH', ROOT_PATH . '/api');

$loader = require ROOT_PATH . '/vendor/autoload.php';

$config = new \Zend_Config_Ini(API_ROOT_PATH . '/config/application.ini', APP_ENV);

error_reporting($config->phpSettings->error_reporting);
ini_set('display_errors', $config->phpSettings->display_errors);
ini_set('log_errors', $config->phpSettings->log_errors);
ini_set('error_log', $config->phpSettings->error_log);
date_default_timezone_set($config->phpSettings->date->timezone);

$dbConfig = new \Doctrine\DBAL\Configuration();
$connectionParams = array(
    'dbname' => $config->database->params->dbname,
    'user' => $config->database->params->user,
    'password' => $config->database->params->password,
    'host' => $config->database->params->host,
    'driver' => $config->database->params->driver,
    'charset' => $config->database->params->charset
);

$conn = \Doctrine\DBAL\DriverManager::getConnection($connectionParams, $dbConfig);
Zend_Registry::set('conn', $conn);

$logger = Zend_Log::factory(array(
    'timestampFormat' => 'Y-m-d',
    array(
        'writerName' => 'Stream',
        'writerParams' => array(
            'stream' => $config->log->file_path,
        ),
        'formatterName' => 'Simple',
        'formatterParams' => array(
            'format' => '%timestamp% %priorityName% (%priority%): %message%' . PHP_EOL,
        )
    )
));
Zend_Registry::set('logger', $logger);

$server = IoServer::factory(
    new HttpServer(
        new WsServer(
            new ChatServer()
        )
    ),
    8080
);

try {
    $server->run();
} catch (Exception $e) {
    error_log($e->getTraceAsString());
}