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

use Welfony\Controller\API\PaymentTransactionController;

$app->get('/companies/:companyId/paymenttransactions', function ($companyId) use ($app) {
    $ctrl = new PaymentTransactionController();
    $ctrl->listByCompany($companyId);
})->conditions(array('companyId' => '\d{1,10}'));

$app->post('/paymenttransactions', function () use ($app) {
    $ctrl = new PaymentTransactionController();
    $ctrl->create();
});
