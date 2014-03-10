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

use Welfony\Controller\API\RosterController;
use Welfony\Core\Enum\RosterStatus;

$app->get('/users/:userId/roster', function($userId) use($app)
{
    $controller = new RosterController();
    $controller->listAllRostersByUserId($userId);
})->conditions(array('userId' => '\d{1,10}'));

$app->post('/roster', function() use($app)
{
    $controller = new RosterController();
    $controller->add();
});

$app->put('/roster/:rosterId', function($rosterId) use($app)
{
    $controller = new RosterController();
    $controller->update($rosterId);
})->conditions(array('rosterId' => '\d{1,10}'));