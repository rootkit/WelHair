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

use Welfony\Controller\API\ServiceController;

$app->post('/services', function () use ($app) {
    $ctrl = new ServiceController();
    $ctrl->create();
});

$app->post('/services/:serviceId/remove', function ($serviceId) use ($app) {
    $ctrl = new ServiceController();
    $ctrl->remove($serviceId);
})->conditions(array('serviceId' => '\d{1,10}'));
