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
use Welfony\Service\StaffService;
use Welfony\Service\WorkService;

class IndexController extends AbstractFrontendController
{

    public function indexAction()
    {
        $rstStaffList = StaffService::search(0, '', 0, $this->userContext->area['City']['AreaId'], 0, 0, $this->userContext->location, 1, 10);
        $this->view->staffList = $rstStaffList['staffs'];

        $rstWorkList = WorkService::search($this->currentUser['UserId'], $this->userContext->area['City']['AreaId'], 0, 0, 0, 1, 12);
        $this->view->workList = $rstWorkList['works'];
    }

}