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

use Welfony\Controller\API\AppointmentController;

$app->get('/users/:userId/appointments', function ($userId) use ($app) {
    $ctrl = new AppointmentController();
    $ctrl->listByUser($userId);
})->conditions(array('userId' => '\d{1,10}'));

$app->get('/staffs/:staffId/appointments', function ($staffId) use ($app) {
    $ctrl = new AppointmentController();
    $ctrl->listByStaff($staffId);
})->conditions(array('staffId' => '\d{1,10}'));

$app->post('/appointments', function () use ($app) {
    $ctrl = new AppointmentController();
    $ctrl->create();
});

$app->put('/appointments/:appointmentId', function ($appointmentId) use ($app) {
    $ctrl = new AppointmentController();
    $ctrl->update($appointmentId);
})->conditions(array('appointmentId' => '\d{1,10}'));

$app->get('/appointments/:appointmentId/note', function ($appointmentId) use ($app) {
    $ctrl = new AppointmentController();
    $ctrl->listNote($appointmentId);
})->conditions(array('appointmentId' => '\d{1,10}'));

$app->get('/appointments/note/staff/:staffId/user/:userId', function ($staffId, $userId) use ($app) {
    $ctrl = new AppointmentController();
    $ctrl->listNoteByStaffAndUser($staffId, $userId);
})->conditions(array('staffId' => '\d{1,10}', 'userId' => '\d{1,10}'));

$app->post('/appointments/:appointmentId/note', function ($appointmentId) use ($app) {
    $ctrl = new AppointmentController();
    $ctrl->addNote($appointmentId);
})->conditions(array('appointmentId' => '\d{1,10}'));
