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

namespace Welfony\Controller\API;

use Welfony\Controller\Base\AbstractAPIController;
use Welfony\Core\Enum\AppointmentStatus;
use Welfony\Service\AppointmentService;

class AppointmentController extends AbstractAPIController
{

    public function listByUser($userId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));
        $dataList = AppointmentService::listAllAppointments($page, $pageSize, 0, $userId, -1);
        $this->sendResponse($dataList);
    }

    public function listByStaff($staffId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));
        $dataList = AppointmentService::listAllAppointments($page, $pageSize, $staffId, 0, array(AppointmentStatus::Paid, AppointmentStatus::Completed));
        $this->sendResponse($dataList);
    }

    public function create()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['UserId'] = $this->currentContext['UserId'];
        $reqData['AppointmentId'] = 0;
        $reqData['Status'] = AppointmentStatus::Pending;

        $result = AppointmentService::save($reqData);
        $this->sendResponse($result);
    }

    public function update($appointmentId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['UserId'] = $this->currentContext['UserId'];

        $result = AppointmentService::update($appointmentId, $reqData);
        $this->sendResponse($result);
    }

}
