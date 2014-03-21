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

$app->get('/users', function() use($app)
{
    $ctrl = new UserController();
    $ctrl->index();
});

$app->post('/users/signin/email', function() use($app)
{
    $ctrl = new UserController();
    $ctrl->signInWithEmail();
});

$app->post('/users/signup/email', function() use($app)
{
    $ctrl = new UserController();
    $ctrl->signUpWithEmail();
});