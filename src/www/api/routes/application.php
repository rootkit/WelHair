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

$app->hook('slim.before.router', function() use($app)
{
    $ip = '119.163.88.200';//Util::getRealIp();
    $isLocalhost = $ip == '127.0.0.1';

    $location = htmlspecialchars($app->request->get('currentLocation'));
    if (empty($location)) {
        $location = $isLocalhost ? '36.68278473,117.02496707' : '0,0';
    }
    $locationArr = explode(',', $location);
    if (count($locationArr) != 2) {
        $locationArr = $isLocalhost ? array(36.68278473, 117.02496707) : array(0, 0);
    }
    if (doubleval($locationArr[0]) <= 0) {
        $client = new \GuzzleHttp\Client();
        $res = $client->get('http://api.map.baidu.com/location/ip?ak=3998daac6ca53a8067263f139b4aadf4&ip=' . $ip . '&coor=bd09ll');

        var_export($res->json());die();
    }

    $currentUserId = intval($app->request->get('currentUserId'));

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

$app->get('/', function() use($app)
{
    $controller = new IndexController();
    $controller->index();
});

$app->notFound(function() use($app)
{
    $ctrl = new ErrorController();
    $ctrl->notFound();
});

$app->error(function(\Exception $e) use($app)
{
    $ctrl = new ErrorController();
    $ctrl->error($e);
});