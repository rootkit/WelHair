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
use Welfony\Service\OrderService;
use Welfony\Service\AreaService;

class Order_IndexController extends AbstractAdminController
{

    public function searchAction()
    {
        $this->view->pageTitle = '订单列表';

        $pageSize = 10;
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = OrderService::listOrder($page, $pageSize);

        $this->view->rows = $result['orders'];

        $this->view->pagerHTML = $this->renderPager($this->view->baseUrl('/order/index/search'),
                                                    $page,
                                                    ceil($result['total'] / $pageSize));
    }

    public function infoAction()
    {
        $this->view->pageTitle = '添加订单';
        $this->view->orderno = date('YmdHis').rand(100000,999999);

        $orderId = $this->_request->getParam('order_id')?  intval($this->_request->getParam('order_id')) : 0;

        $order = array(
            'OrderId' => $orderId,
            'OrderNo' => '',
            'Province' => '',
            'City' => '',
            'IsDeleted' => 0
        );

        $this->view->provinceList = AreaService::listAreaByParent(0);
        $this->view->cityList = [];
        $this->view->districtList = [];
      
        if ($this->_request->isPost()) {
            $this->_helper->viewRenderer->setNoRender(true);
            $this->_helper->layout->disableLayout();
            $order['OrderNo']= htmlspecialchars($this->_request->getParam('orderno'));
            $order['IsDeleted']= '0';

           

            $result = OrderService::save($order);
            if ($result['success']) {
                $result['message'] = '保存订单成功！';
            }
            $this->_helper->json->sendJson($result);
        } else {

            if ($orderId > 0) {
                $this->view->cityList = intval($company['Province']) > 0 ? AreaService::listAreaByParent($company['Province']) : array();
                $this->view->districtList = intval($company['City']) > 0 ? AreaService::listAreaByParent($company['City']) : array();

                $order = OrderService::getOrderById($orderId);
                if (!$model) {
                    // process not exist logic;
                }
            }
        }

        $this->view->orderInfo = $order;

    }

	public function detailAction()
    {
        $this->view->pageTitle = '订单详情';
    }


}
