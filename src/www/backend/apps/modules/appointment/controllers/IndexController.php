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

use Welfony\Controller\Base\AbstractAdminController;
use Welfony\Core\Enum\AppointmentStatus;
use Welfony\Service\AppointmentService;
use Welfony\Service\StaffService;
use Welfony\Service\UserService;

class Appointment_IndexController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '预约列表';

        $staff = array(
            'UserId' => 0
        );

        $staffId = intval($this->_request->getParam('staff_id'));
        if ($staffId > 0) {
            $staff = UserService::getUserById($staffId);
            $this->view->pageTitle = $staff['Nickname'] . '的预约列表';
        }

        $this->view->staffInfo = $staff;
    }

    public function infoAction()
    {
        $this->view->pageTitle = '预约详情';

        $staff = array(
            'UserId' => 0,
            'Nickname' => '',
            'Username' => '',
            'AvatarUrl' => '',
            'Company' => array('Name' => ''),
            'Services' => array(),
            'Works' => array()
        );

        $staffId = intval($this->_request->getParam('staff_id'));
        if ($staffId > 0) {
            $staff = StaffService::getStaffDetail($staffId);
        }

        $this->view->staffInfo = $staff;
    }

}