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

class User_AppointmentController extends AbstractFrontendController
{

    public function init()
    {
        $this->needloginActionList['user'] = array('appointment' => array('index'));

        parent::init();
    }

    public function indexAction()
    {
        $this->view->pageTitle = '我的预约';

        $this->view->status = htmlspecialchars($this->_request->getParam('status'));

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $this->view->params = array();
        if (!empty($this->view->status)) {
            $this->view->params['status'] = $this->view->status;
        }

        $statusParam = -1;
        if ($this->view->status == 'unpaid') {
            $statusParam = AppointmentStatus::Pending;
        }
        if ($this->view->status == 'completed') {
            $statusParam = AppointmentStatus::Completed;
        }

        $rstAppointment = AppointmentService::listAllAppointments($page, $pageSize, 0, $this->currentUser['UserId'], $statusParam);
        $this->view->appointmentList = $rstAppointment['appointments'];


        $this->view->pager = $this->renderPager($this->view->baseUrl('user/appointment?' . http_build_query($this->view->params)),
                                                $page,
                                                ceil($rstAppointment['total'] / $pageSize));
    }

}