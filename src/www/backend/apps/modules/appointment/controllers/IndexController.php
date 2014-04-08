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

        $page = intval($this->_request->getParam('page'));
        $searchResult = AppointmentService::listAllAppointments($page, $pageSize, $staffId, 0, -1);

        $this->view->dataList = $searchResult['appointments'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('appointment/index/search?s=' . ($staffId > 0 ? '&staff_id=' . $staffId : '')),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function infoAction()
    {
        $this->view->pageTitle = '预约详情';

        $appointment = array(
            'AppointmentId' => intval($this->_request->getParam('appointment_id')),
            'ServiceId' => 0,
            'ServiceTitle' => '',
            'AppointmentDate' => '',
            'Price' => 0,
            'Status' => AppointmentStatus::Pending
        );

        $staffId = intval($this->_request->getParam('staff_id'));

        if ($this->_request->isPost()) {
            $userId = intval($this->_request->getParam('user_id'));
            $serviceId = intval($this->_request->getParam('service_id'));
            $appointmentDate = htmlspecialchars($this->_request->getParam('appointment_date'));
            $status = intval($this->_request->getParam('status'));

            if ($appointment['AppointmentId'] > 0) {
                $appointment = AppointmentService::getAppointmentById($appointment['AppointmentId']);
            } else {
                $appointment['ServiceId'] = $serviceId;
            }

            $appointment['UserId'] = $userId;
            $appointment['StaffId'] = $staffId;
            $appointment['AppointmentDate'] = $appointmentDate;
            $appointment['Status'] = $status;

            $result = AppointmentService::save($appointment);
            if ($result['success']) {
                $this->getResponse()->setRedirect($this->view->baseUrl('appointment/index/search' . ($staffId > 0 ? '?staff_id=' . $staffId : '')));
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {
            $staff = array(
                'UserId' => 0,
                'Nickname' => '',
                'Username' => '',
                'AvatarUrl' => '',
                'Company' => array('Name' => ''),
                'Services' => array(),
                'Works' => array()
            );

            $user = array(
                'UserId' => 0,
                'Nickname' => '',
                'Username' => '',
                'AvatarUrl' => ''
            );

            if ($appointment['AppointmentId'] > 0) {
                $appointment = AppointmentService::getAppointmentById($appointment['AppointmentId']);
                if ($appointment) {
                    $staffId = $appointment['StaffId'];
                    $user = UserService::getUserById($appointment['UserId']);

                    $this->view->appointmentInfo = $appointment;
                }
            }

            if ($staffId > 0) {
                $staff = StaffService::getStaffDetail($staffId);
            }

            $this->view->userInfo = $user;
            $this->view->staffInfo = $staff;
        }

        $this->view->appointmentInfo = $appointment;
    }

}
