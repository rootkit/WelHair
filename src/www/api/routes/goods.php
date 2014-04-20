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

use Welfony\Controller\API\GoodsController;

$app->get('/goods', function () use ($app) {
    $ctrl = new GoodsController();
    $ctrl->search();
});

$app->get('/goods/:goodsId', function ($goodsId) use ($app) {
    $ctrl = new GoodsController();
    $ctrl->detail($goodsId);
})->conditions(array('goodsId' => '\d{1,10}'));

$app->get('/goods/:goodsId/comments', function ($goodsId) use ($app) {
    $ctrl = new GoodsController();
    $ctrl->listComments($goodsId);
})->conditions(array('goodsId' => '\d{1,10}'));

$app->get('/companies/:companyId/goods', function ($companyId) use ($app) {
    $ctrl = new GoodsController();
    $ctrl->listByCompany($companyId);
})->conditions(array('companyId' => '\d{1,10}'));

$app->get('/goods/liked', function () use ($app) {
    $ctrl = new GoodsController();
    $ctrl->liked();
});

$app->post('/goods/:goodsId/likes', function ($goodsId) use ($app) {
    $ctrl = new GoodsController();
    $ctrl->addGoodsLike($goodsId);
})->conditions(array('goodsId' => '\d{1,10}'));

$app->post('/goods/:goodsId/comments', function ($goodsId) use ($app) {
    $ctrl = new GoodsController();
    $ctrl->addComment($goodsId);
})->conditions(array('goodsId' => '\d{1,10}'));