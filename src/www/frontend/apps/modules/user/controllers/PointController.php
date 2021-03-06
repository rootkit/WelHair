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
use Welfony\Service\UserPointService;

class User_PointController extends AbstractFrontendController
{

    public function init()
    {
        $this->needloginActionList['user'] = array('point' => array('index'));

        parent::init();
    }

    public function indexAction()
    {
        $this->view->pageTitle = '我的积分';
        $this->view->pointList = UserPointService::listAllPointsByUserAndType($this->currentUser['UserId']);
    }

}