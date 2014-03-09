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

define('DS', \DIRECTORY_SEPARATOR);
define('ROOT_PATH', realpath(__DIR__ . '/../'));

$loader = require ROOT_PATH . '/vendor/autoload.php';

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