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
use Welfony\Service\DeliveryService;
use Welfony\Service\FreightService;

class System_DeliveryController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '配送方式';
		
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = DeliveryService::listDelivery($page, $pageSize);

        $this->view->rows = $result['deliveries'];

        $this->view->pagerHTML = $this->renderPager($this->view->baseUrl('/sytem/delivery/search'),
                                                    $page,
                                                    ceil($result['total'] / $pageSize));
    }

    public function infoAction()
    {
        $this->view->pageTitle = '添加配送方式';

        $this->view->freights = FreightService::listAllFreight();
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


    public function deleteAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $deliveryId =  intval($this->_request->getParam('deliveryid')) ;

        $delivery = array('DeliveryId' => $deliveryId);

        if ($this->_request->isPost()) {

            $result = DeliveryService::deleteDelivery($deliveryId);
            $this->_helper->json->sendJson($result);
        }
    }

}
