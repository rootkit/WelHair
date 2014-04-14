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
use Welfony\Service\OrderGoodsService;
use Welfony\Service\DeliveryService;
use Welfony\Service\PaymentService;

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
            'UserId' => 0,
            'PayType'=> 0,
            'Distribution'=>0,
            'AcceptName'=>'',
            'IsDeleted' => 0
        );

        $this->view->provinceList = AreaService::listAreaByParent(0);
        $this->view->cityList = [];
        $this->view->districtList = [];
        $this->view->ordergoods = [];
        $this->view->deliveries = DeliveryService::listAllDelivery();
        $this->view->payments = PaymentService::listActivePayment();
      
        if ($this->_request->isPost()) {
            $this->_helper->viewRenderer->setNoRender(true);
            $this->_helper->layout->disableLayout();
            $order['OrderNo']= htmlspecialchars($this->_request->getParam('orderno'));
            $order['AcceptName']= htmlspecialchars($this->_request->getParam('acceptname'));
            $order['Paytype']= $this->_request->getParam('paytype');
            $order['Distribution']= $this->_request->getParam('distribution');
            if( $this->_request->getParam('province') )
            {
                $order['Province'] = $this->_request->getParam('province');
            }
            if( $this->_request->getParam('city') )
            {
                $order['City'] = $this->_request->getParam('city');
            }
            if( $this->_request->getParam('area') )
            {
                $order['Area'] = $this->_request->getParam('area');
            }
            $goods = $this->_request->getParam('goods');
            $order['CreateTime']= date('Y-m-d H:i:s'),
            $order['IsDeleted']= '0';

           

            $result = OrderService::save($order, $goods);
            if ($result['success']) {
                $result['message'] = '保存订单成功！';
            }
            $this->_helper->json->sendJson($result);
        } else {

            if ($orderId > 0) {
         
                $this->view->ordergoods = OrderGoodsService::listAllOrderGoodsByOrder($orderId);
                $order = OrderService::getOrderById($orderId);
                $this->view->cityList = intval($order['Province']) > 0 ? AreaService::listAreaByParent($order['Province']) : array();
                $this->view->districtList = intval($order['City']) > 0 ? AreaService::listAreaByParent($order['City']) : array();

                if (!$order) {
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
