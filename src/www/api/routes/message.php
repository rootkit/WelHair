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

use Welfony\Controller\API\MessageController;

$app->get('/messages/to/:toId/from/:fromId', function ($fromId, $toId) use ($app) {
    $ctrl = new MessageController();
    $ctrl->listMessages($fromId, $toId);
})->conditions(array('fromId' => '\d{1,10}'), array('toId' => '\d{1,10}'));

$app->get('/users/:userId/messages/conversations', function ($userId) use ($app) {
    $ctrl = new MessageController();
    $ctrl->listConversationsByUserId($userId);
})->conditions(array('userId' => '\d{1,10}'));

$app->post('/messages', function () use ($app) {
    $ctrl = new MessageController();
    $ctrl->create();
});

$app->post('/messages/conversations/:conversationId/remove', function ($conversationId) use ($app) {
    $ctrl = new MessageController();
    $ctrl->removeConversationsById($conversationId);
})->conditions(array('conversationId' => '\d{1,10}'));

$app->put('/messages/conversations/:conversationId', function ($conversationId) use ($app) {
    $ctrl = new MessageController();
    $ctrl->updateConversation($conversationId);
})->conditions(array('conversationId' => '\d{1,10}'));