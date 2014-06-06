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

use Welfony\Controller\API\DepositController;

$app->get('/users/:userId/deposit', function ($userId) use ($app) {
    $ctrl = new DepositController();
    $ctrl->listByUser($userId);
})->conditions(array('userId' => '\d{1,10}'));

$app->post('/users/:userId/deposit', function ($userId) use ($app) {
    $ctrl = new DepositController();
    $ctrl->create($userId);
})->conditions(array('userId' => '\d{1,10}'));