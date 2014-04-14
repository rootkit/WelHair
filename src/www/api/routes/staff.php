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

use Welfony\Controller\API\StaffController;

$app->get('/staffs', function () use ($app) {
    $ctrl = new StaffController();
    $ctrl->search();
});

$app->get('/staffs/liked', function () use ($app) {
    $ctrl = new StaffController();
    $ctrl->liked();
});

$app->get('/staffs/:staffId', function ($staffId) use ($app) {
    $ctrl = new StaffController();
    $ctrl->detail($staffId);
})->conditions(array('staffId' => '\d{1,10}'));

$app->get('/staffs/:staffId/comments', function ($staffId) use ($app) {
    $ctrl = new StaffController();
    $ctrl->listComments($staffId);
})->conditions(array('staffId' => '\d{1,10}'));

$app->get('/staffs/:staffId/works', function ($staffId) use ($app) {
    $ctrl = new StaffController();
    $ctrl->listWorks($staffId);
})->conditions(array('staffId' => '\d{1,10}'));

$app->get('/staffs/:staffId/services', function ($staffId) use ($app) {
    $ctrl = new StaffController();
    $ctrl->listServices($staffId);
})->conditions(array('staffId' => '\d{1,10}'));

$app->post('/staffs/:staffId/comments', function ($staffId) use ($app) {
    $ctrl = new StaffController();
    $ctrl->addComment($staffId);
})->conditions(array('staffId' => '\d{1,10}'));

$app->post('/staffs/:staffId/likes', function ($staffId) use ($app) {
    $ctrl = new StaffController();
    $ctrl->addStaffLike($staffId);
})->conditions(array('staffId' => '\d{1,10}'));
