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

use Welfony\Controller\API\RoomController;

$app->get('/users/:userId/rooms', function ($userId) use ($app) {
    $controller = new RoomController();
    $controller->listAllRoomsByUserId($userId);
})->conditions(array('userId' => '\d{1,10}'));

$app->post('/rooms', function () use ($app) {
    $ctrl = new RoomController();
    $ctrl->addNewRoom();
});
