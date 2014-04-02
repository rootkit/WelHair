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

use Welfony\Controller\API\CompanyController;

$app->get('/companies', function () use ($app) {
    $ctrl = new CompanyController();
    $ctrl->search();
});

$app->get('/companies/:companyId/comments', function ($companyId) use ($app) {
    $ctrl = new CompanyController();
    $ctrl->listComments($companyId);
})->conditions(array('companyId' => '\d{1,10}'));

$app->post('/companies/:companyId/comments', function ($companyId) use ($app) {
    $ctrl = new CompanyController();
    $ctrl->addComment($companyId);
})->conditions(array('companyId' => '\d{1,10}'));

$app->post('/companies/:companyId/likes', function ($companyId) use ($app) {
    $ctrl = new CompanyController();
    $ctrl->addCompanyLike($companyId);
})->conditions(array('companyId' => '\d{1,10}'));
