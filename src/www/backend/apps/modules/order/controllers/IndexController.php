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

class Order_IndexController extends AbstractAdminController
{

    public function searchAction()
    {
        $this->view->pageTitle = '订单列表';
        $this->view->rows = [];
    }

    public function infoAction()
    {
        $this->view->pageTitle = '添加订单';
        $this->view->orderno = date('YmdHis').rand(100000,999999);
    }

	public function detailAction()
    {
        $this->view->pageTitle = '订单详情';
    }


}
