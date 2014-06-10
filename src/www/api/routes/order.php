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

use Welfony\Controller\API\OrderController;

$app->get('/users/:userId/orders', function ($userId) use ($app) {
    $controller = new OrderController();
    $controller->listAllOrdersByUserId($userId);
})->conditions(array('userId' => '\d{1,10}'));

$app->post('/orders', function () use ($app) {
    $ctrl = new OrderController();
    $ctrl->create();
});

$app->post('/orders/:orderId/pay', function ($orderId) use ($app) {
    $ctrl = new OrderController();
    $ctrl->pay($orderId);
})->conditions(array('orderId' => '\d{1,10}'));