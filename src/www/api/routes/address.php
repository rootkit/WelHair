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

use Welfony\Controller\API\AddressController;

$app->get('/users/:userId/addresses', function ($userId) use ($app) {
    $ctrl = new AddressController();
    $ctrl->listByUser($userId);
})->conditions(array('userId' => '\d{1,10}'));

$app->post('/addresses', function () use ($app) {
    $ctrl = new AddressController();
    $ctrl->create();
});

$app->put('/addresses/:addressId', function ($addressId) use ($app) {
    $ctrl = new AddressController();
    $ctrl->update($addressId);
})->conditions(array('addressId' => '\d{1,10}'));

$app->post('/addresses/:addressId/remove', function ($addressId) use ($app) {
    $ctrl = new AddressController();
    $ctrl->remove($addressId);
})->conditions(array('addressId' => '\d{1,10}'));

$app->post('/addresses/:addressId/default', function ($addressId) use ($app) {
    $ctrl = new AddressController();
    $ctrl->setToDefault($addressId);
})->conditions(array('addressId' => '\d{1,10}'));
