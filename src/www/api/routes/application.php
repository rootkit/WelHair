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

use Welfony\Controller\API\ErrorController;
use Welfony\Controller\API\IndexController;
use Welfony\Utility\Util;

$app->hook('slim.before.router', function () use ($app) {
    $ip = Util::getRealIp();
    $isLocalhost = $ip == '127.0.0.1' || $ip == '192.168.1.103';

    $contextArr = json_decode($app->request->headers->get('WH-Context'), true);

    $location = null;
    if (!isset($contextArr['currentLocation']) || empty($contextArr['currentLocation'])) {
        $location = $isLocalhost ? '36.68278473,117.02496707' : '0,0';
    } else {
        $location = htmlspecialchars($contextArr['currentLocation']);
    }
    $locationArr = explode(',', $location);
    if (count($locationArr) != 2) {
        $locationArr = $isLocalhost ? array(36.68278473, 117.02496707) : array(0, 0);
    }
    if (doubleval($locationArr[0]) <= 0) {
        if ($isLocalhost) {
            $locationArr = array(36.68278473, 117.02496707);
        } else {
            $client = new \GuzzleHttp\Client();
            $res = $client->get('http://api.map.baidu.com/location/ip?ak=3998daac6ca53a8067263f139b4aadf4&ip=' . $ip . '&coor=bd09ll');
            $bdData = $res->json();
            $locationArr[0] = $bdData['content']['point']['y'];
            $locationArr[1] = $bdData['content']['point']['x'];
        }
    }

    $currentUserId = intval($contextArr['currentUserId']);

    $currentContext = array(
        'Location' => array(
            'Latitude' => doubleval($locationArr[0]),
            'Longitude' => doubleval($locationArr[1])
        ),
        'UserId' => $currentUserId,
        'IP' => $ip
    );

    \Zend_Registry::set('currentContext', $currentContext);

    $app->response()->header('Content-Type', 'application/json');
});

$app->get('/', function () use ($app) {
    $controller = new IndexController();
    $controller->index();
});

$app->notFound(function () use ($app) {
    $ctrl = new ErrorController();
    $ctrl->notFound();
});

$app->error(function (\Exception $e) use ($app) {
    $ctrl = new ErrorController();
    $ctrl->error($e);
});
