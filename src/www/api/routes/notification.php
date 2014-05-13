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

use Welfony\Controller\API\NotificationController;

$app->post('/user/registerDevice', function () use ($app) {
    $ctrl = new NotificationController();
    $ctrl->registerDeivceToken();
});

$app->post('/user/removeDevice', function () use ($app) {
    $ctrl = new NotificationController();
    $ctrl->removeDeivceToken();
});