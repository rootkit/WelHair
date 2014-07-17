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
use Welfony\Core\Enum\Face;
use Welfony\Core\Enum\Gender;
use Welfony\Core\Enum\HairAmount;
use Welfony\Core\Enum\HairStyle;
use Welfony\Core\Enum\StaffStatus;
use Welfony\Service\AppointmentService;
use Welfony\Service\ServiceService;
use Welfony\Service\WorkService;

class User_StylistController extends AbstractFrontendController
{

    public function init()
    {
        $this->needloginActionList['user'] = array('stylist' => array('index', 'hair', 'service', 'client', 'appointment'));
        parent::init();
    }

    public function indexAction()
    {
        $this->view->pageTitle = '发型师管理';

        $this->_redirect($this->view->baseUrl('user/stylist/hair'));
    }

    public function hairAction()
    {
        $this->view->pageTitle = '我的作品';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $searchResult = WorkService::listAllWorks($page, $pageSize, $this->currentUser['UserId']);

        $this->view->dataList = $searchResult['works'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('user/stylist/hair?'),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function haireditAction()
    {
        $this->view->pageTitle = '发型信息';

        $work = array(
            'WorkId' => intval($this->_request->getParam('hair_id')),
            'UserId' => $this->currentUser['UserId'],
            'Title' => '',
            'Gender' => Gender::Male,
            'Face' => Face::Round,
            'HairAmount' => HairAmount::Normal,
            'HairStyle' => HairStyle::Normal,
            'PictureUrl' => array()
        );

        if ($this->_request->isPost()) {
            $title = htmlspecialchars($this->_request->getParam('title'));
            $pictureUrl = $this->_request->getParam('work_picture_url');
            $gender = intval($this->_request->getParam('gender'));
            $hairamount = intval($this->_request->getParam('hair_amount'));
            $hairstyle = intval($this->_request->getParam('hair_style'));
            $face = htmlspecialchars($this->_request->getParam('face'));

            $work['Title'] = $title;
            $work['PictureUrl'] = $pictureUrl;
            $work['Gender'] = $gender;
            $work['Face'] = $face;
            $work['HairAmount'] = $hairamount;
            $work['HairStyle'] = $hairstyle;

            $result = WorkService::save($work);
            if ($result['success']) {
                if ($work['WorkId'] <= 0) {
                    $work['WorkId'] = $result['work']['WorkId'];
                }

                $this->view->successMessage = '保存作品成功！';

                $this->_redirect($this->view->baseUrl('user/stylist/hair'));
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {
            if ($work['WorkId'] > 0) {
                $work = WorkService::getWorkById($work['WorkId']);
                if (!$work) {
                    // process not exist logic;
                }
            }
        }

        $this->view->workInfo = $work;
    }

    public function serviceAction()
    {
        $this->view->pageTitle = '我的服务';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $rstServiceList = ServiceService::listAllServices($page, $pageSize, $this->currentUser['UserId']);
        $this->view->dataList = $rstServiceList['services'];

        $this->view->pager = $this->renderPager($this->view->baseUrl('user/stylist/service?'),
                                                $page,
                                                ceil($rstServiceList['total'] / $pageSize));
    }

    public function serviceeditAction()
    {
        $this->view->pageTitle = '服务信息';

        $service = array(
            'ServiceId' => intval($this->_request->getParam('service_id')),
            'UserId' => $this->currentUser['UserId'],
            'Title' => '',
            'OldPrice' => 0,
            'Price' => 0
        );

        if ($this->_request->isPost()) {
            $title = htmlspecialchars($this->_request->getParam('title'));
            $oldPrice = floatval($this->_request->getParam('old_price'));
            $price = floatval($this->_request->getParam('price'));

            $service['Title'] = $title;
            $service['OldPrice'] = $oldPrice;
            $service['Price'] = $price;

            $result = ServiceService::save($service);
            if ($result['success']) {
                if ($service['ServiceId'] <= 0) {
                    $service['ServiceId'] = $result['service']['ServiceId'];
                }

                $this->view->successMessage = '保存作品成功！';

                $this->_redirect($this->view->baseUrl('user/stylist/service'));
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {
            if ($service['ServiceId'] > 0) {
                $service = ServiceService::getServiceById($service['ServiceId']);
                if (!$service) {
                    // process not exist logic;
                }
            }
        }

        $this->view->serviceInfo = $service;
    }

    public function clientAction()
    {
        $this->view->pageTitle = '我的客户';
    }

    public function appointmentAction()
    {
        $this->view->pageTitle = '我的客户预约';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $userId = intval($this->_request->getParam('user_id'));

        $rstAppointment = AppointmentService::listAllAppointments($page, $pageSize, $this->currentUser['UserId'], $userId, array(AppointmentStatus::Paid, AppointmentStatus::Cancelled, AppointmentStatus::Completed));

        $this->view->appointmentList = $rstAppointment['appointments'];

        $this->view->pager = $this->renderPager($this->view->baseUrl('user/stylist/appointment?'),
                                                $page,
                                                ceil($rstAppointment['total'] / $pageSize));
    }

}