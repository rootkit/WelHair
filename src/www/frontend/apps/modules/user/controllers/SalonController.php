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

class User_SalonController extends AbstractFrontendController
{

    public function init()
    {
        $this->needloginActionList['user'] = array('salon' => array('index'));

        parent::init();
    }

    public function indexAction()
    {
        $this->view->pageTitle = '沙龙管理';
    }

}