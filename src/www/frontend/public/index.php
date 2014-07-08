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


defined('APP_ENV') || define('APP_ENV', (getenv('APP_ENV') ? getenv('APP_ENV') : 'development'));

define('DS', \DIRECTORY_SEPARATOR);
define('ROOT_PATH', realpath(__DIR__ . '/../../'));
define('STATIC_ROOT_PATH', ROOT_PATH . '/static');

@header('Content-type:text/html;charset=UTF-8');

require ROOT_PATH . '/vendor/autoload.php';

$config = new Zend_Config_Ini(ROOT_PATH . '/frontend/apps/configs/application.ini', APP_ENV);
$options = $config->toArray();

$app = new Zend_Application(APP_ENV, $options);

try {
    $app->bootstrap()->run();
} catch (Exception $e) {
    error_log($e->getTraceAsString());
}