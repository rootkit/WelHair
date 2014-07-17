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

use Welfony\Controller\Base\AbstractFrontendController;
use Welfony\Core\Enum\AppointmentStatus;
use Welfony\Service\AppointmentService;
use Welfony\Service\StaffService;

class Ajax_AppointmentController extends AbstractFrontendController
{

    public function indexAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $reqData = array();
        $reqData['AppointmentId'] = 0;
        $reqData['UserId'] = $this->currentUser['UserId'];
        $reqData['StaffId'] = intval($this->_request->getParam('stylist_id'));
        $reqData['ServiceId'] = intval($this->_request->getParam('service_id'));
        $reqData['AppointmentDate'] = $this->_request->getParam('date');

        $this->_helper->json->sendJson(AppointmentService::save($reqData));
    }

    public function completeAction()
    {
        $appointmentId = intval($this->_request->getParam('appointment_id'));
        $reqData = array('Status' => AppointmentStatus::Completed);
        $this->_helper->json->sendJson(AppointmentService::update($appointmentId, $reqData));
    }

    public function cancelAction()
    {
        $appointmentId = intval($this->_request->getParam('appointment_id'));
        $reqData = array('Status' => AppointmentStatus::Cancelled);
        $this->_helper->json->sendJson(AppointmentService::update($appointmentId, $reqData));
    }

    public function likeAction()
    {
        $appointmentId = intval($this->_request->getParam('appointment_id'));
        $reqData = array('IsLiked' => 1);
        $this->_helper->json->sendJson(AppointmentService::update($appointmentId, $reqData));
    }

    public function formAction()
    {
        $staffId = intval($this->_request->getParam('stylist_id'));

        $this->view->staffDetail = StaffService::getStaffDetail($staffId, $this->currentUser['UserId'], $this->userContext->location);

        $ajaxContext = $this->_helper->getHelper('AjaxContext');
        $ajaxContext->addActionContext('form', 'html')
            ->initContext();
    }

}
