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

use Welfony\Controller\API\UserController;

$app->get('/users', function () use ($app) {
    $ctrl = new UserController();
    $ctrl->index();
});

$app->get('/users/:userId', function ($userId) use ($app) {
    $ctrl = new UserController();
    $ctrl->getDetail($userId);
})->conditions(array('userId' => '\d{1,10}'));

$app->get('/users/:userId/points', function ($userId) use ($app) {
    $ctrl = new UserController();
    $ctrl->listPointsByUser($userId);
})->conditions(array('userId' => '\d{1,10}'));

$app->put('/users/:userId', function ($userId) use ($app) {
    $ctrl = new UserController();
    $ctrl->update($userId);
})->conditions(array('userId' => '\d{1,10}'));

$app->post('/users/signin/social', function () use ($app) {
    $ctrl = new UserController();
    $ctrl->signInWithSocial();
});

$app->post('/users/signin/email', function () use ($app) {
    $ctrl = new UserController();
    $ctrl->signInWithEmail();
});

$app->post('/users/signup/email', function () use ($app) {
    $ctrl = new UserController();
    $ctrl->signUpWithEmail();
});

$app->post('/users/signin/mobile', function () use ($app) {
    $ctrl = new UserController();
    $ctrl->signInWithMobile();
});

$app->post('/users/signup/mobile', function () use ($app) {
    $ctrl = new UserController();
    $ctrl->signUpWithMobile();
});

$app->post('/users/:userId/follow', function ($userId) use ($app) {
    $ctrl = new UserController();
    $ctrl->addFollow($userId);
})->conditions(array('userId' => '\d{1,10}'));
