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
use Welfony\Service\PaymentService;

class System_PaymentController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 20;

        $this->view->pageTitle = '支付方式列表';
		
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = PaymentService::listPayment($page, $pageSize);

        $this->view->rows = $result['payments'];

        $this->view->pagerHTML = $this->renderPager($this->view->baseUrl('/sytem/payment/search'),
                                                    $page,
                                                    ceil($result['total'] / $pageSize));
												
    }

    public function infoAction()
    {
        $this->view->pageTitle = '添加支付方式';

		/*
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
		*/
    }

}
