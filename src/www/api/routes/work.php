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

use Welfony\Controller\API\WorkController;

$app->get('/works/:workId/comments', function($workId) use($app)
{
    $ctrl = new WorkController();
    $ctrl->listComments($workId);
})->conditions(array('workId' => '\d{1,10}'));

$app->post('/works/:workId/comments', function($workId) use($app)
{
    $ctrl = new WorkController();
    $ctrl->addComment($workId);
})->conditions(array('workId' => '\d{1,10}'));