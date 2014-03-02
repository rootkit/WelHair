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

class Company_StaffController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 1;

        $this->view->pageTitle = '发型师列表';
    }

    public function authenticationAction()
    {
        static $pageSize = 1;

        $this->view->pageTitle = '发型师认证';
    }

}