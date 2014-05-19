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

$app->get('/companies/nearby', function () use ($app) {
    $ctrl = new CompanyController();
    $ctrl->nearby();
});

$app->get('/companies/liked', function () use ($app) {
    $ctrl = new CompanyController();
    $ctrl->liked();
});

$app->get('/companies/:companyId', function ($companyId) use ($app) {
    $ctrl = new CompanyController();
    $ctrl->getDetail($companyId);
})->conditions(array('companyId' => '\d{1,10}'));

$app->get('/companies/:companyId/staffs', function ($companyId) use ($app) {
    $ctrl = new CompanyController();
    $ctrl->listStaffs($companyId);
})->conditions(array('companyId' => '\d{1,10}'));

$app->post('/companies/:companyId/staffs/:staffId/status', function ($companyId, $staffId) use ($app) {
    $ctrl = new CompanyController();
    $ctrl->changeStaffStatusByCompanyAndUser($companyId, $staffId);
})->conditions(array('companyId' => '\d{1,10}', 'staffId' => '\d{1,10}'));

$app->post('/companies/:companyId/staffs/:staffId/remove', function ($companyId, $staffId) use ($app) {
    $ctrl = new CompanyController();
    $ctrl->removeStaffByCompanyAndUser($companyId, $staffId);
})->conditions(array('companyId' => '\d{1,10}', 'staffId' => '\d{1,10}'));

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

$app->post('/companies', function () use ($app) {
    $ctrl = new CompanyController();
    $ctrl->create();
});

$app->post('/companies/:companyId/join', function ($companyId) use ($app) {
    $ctrl = new CompanyController();
    $ctrl->join($companyId);
})->conditions(array('companyId' => '\d{1,10}'));

$app->put('/companies/:companyId', function ($companyId) use ($app) {
    $ctrl = new CompanyController();
    $ctrl->update($companyId);
})->conditions(array('companyId' => '\d{1,10}'));

$app->get('/companies/withdraws', function () use ($app) {
    $ctrl = new CompanyController();
    $ctrl->listCompanyWithdraw();
});
