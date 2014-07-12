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
use Welfony\Service\OrderService;

class User_OrderController extends AbstractFrontendController
{

    public function init()
    {
        $this->needloginActionList['user'] = array('order' => array('index'));

        parent::init();
    }

    public function indexAction()
    {
        $this->view->pageTitle = '我的订单';

        $this->view->status = htmlspecialchars($this->_request->getParam('status'));

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $this->view->params = array();
        if (!empty($this->view->status)) {
            $this->view->params['status'] = $this->view->status;
        }

        $statusParam = -1;
        if ($this->view->status == 'unpaid') {
            $statusParam = 0;
        }

        $rstOrder = OrderService::listAllOrdersByUserId($this->currentUser['UserId'], $statusParam, $page, $pageSize);
        $this->view->orderList = $rstOrder['orders'];


        $this->view->pager = $this->renderPager($this->view->baseUrl('user/order?' . http_build_query($this->view->params)),
                                                $page,
                                                ceil($rstOrder['total'] / $pageSize));
    }

}