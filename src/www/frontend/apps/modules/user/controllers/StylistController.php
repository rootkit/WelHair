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
use Welfony\Service\ServiceService;

class User_StylistController extends AbstractFrontendController
{

    public function init()
    {
        $this->needloginActionList['user'] = array('stylist' => array('index'));
        $this->needloginActionList['user'] = array('stylist' => array('hair'));
        $this->needloginActionList['user'] = array('stylist' => array('service'));
        $this->needloginActionList['user'] = array('stylist' => array('client'));
        $this->needloginActionList['user'] = array('stylist' => array('appointment'));

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

    }

    public function clientAction()
    {
        $this->view->pageTitle = '我的客户';
    }

    public function appointmentAction()
    {
        $this->view->pageTitle = '我的客户预约';
    }

}