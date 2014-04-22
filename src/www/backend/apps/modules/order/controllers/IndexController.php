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
use Welfony\Service\UserService;
use Welfony\Service\OrderLogService;

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
            'AcceptTime'=>'',
            'Province' => 0,
            'Postscript' =>'',
            'IfInsured' => 0,
            'Invoice' => 0,
            'InvoiceTitle'=>null,
            'Discount' => 0,
            'Address' => '',
            'Mobile' => '',
            'Postcode' =>'',
            'Telphone' => '',
            'IsDeleted' => 0,
            'Taxes'=>0,
            'PayFee' => 0
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
            $order['PayType']= $this->_request->getParam('paytype');
            $order['Distribution']= $this->_request->getParam('distribution');
            $order['Postscript']= htmlspecialchars($this->_request->getParam('postscript'));
            $order['IfInsured']= $this->_request->getParam('ifinsured');
            $order['Invoice']= $this->_request->getParam('invoice');
            $order['InvoiceTitle']= $this->_request->getParam('invoicetitle');
            $order['AcceptTime']= $this->_request->getParam('accepttime');
            $order['Address']= $this->_request->getParam('address');
            $order['Mobile']= $this->_request->getParam('mobile');
            $order['Telphone']= $this->_request->getParam('telphone');
            $order['Postcode']= $this->_request->getParam('postcode');
            $order['Discount']= $this->_request->getParam('discount');
            if( $this->_request->getParam('username'))
            {
                $user = UserService::getUserByName($this->_request->getParam('username'));
                if( $user && !empty($user))
                {
                    $order['UserId'] = $user['UserId'];
                }
            }


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
            $payable = 0; //总价格
            $goodTotalWeight = 0; //总重量
            if( !empty($goods) )           
            {
                foreach( $goods as $g)
                {
                    $payable += $g['GoodsPrice'] * $g["GoodsNums"];
                    $goodTotalWeight  += $g['GoodsWeight'];
                }
            }

            $goodTotalWeight = $goodTotalWeight * 1000;

            $order["PayableAmount"] = $payable;
            $order['RealAmount'] = $payable;



            $order['CreateTime']= date('Y-m-d H:i:s');
            $order['IsDeleted']= '0';

            $payableFreight = 0;
            $realFreight = 0;

            $insured = 0;

            if( $this->_request->getParam('distribution'))
            {
                $distributionDetail = DeliveryService::getDeliveryById($this->_request->getParam('distribution'));

                $firstPrice = $distributionDetail['FirstPrice'];
                $secondPrice = $distributionDetail['FirstPrice'];

                if( $distributionDetail['Type']) //制定地区
                {
                    if( $distributionDetail['AreaGroupId'])
                    {
                        $areaGroupIds = json_decode($distributionDetail['AreaGroupId'],true);
                        $areaFirstPrices = json_decode($distributionDetail['AreaFirstPrice'],true);
                        $areaSecondPrices = json_decode($distributionDetail['AreaSecondPrice'],true);
                        foreach( $areaGroupIds as $areaIndex=>$areaId)
                        {
                            if( $this->_request->getParam('province') === $areaId )
                            {
                                $firstPrice = $areaFirstPrices[$areaIndex];
                                $secondPrice = $areaSecondPrices[$areaIndex];
                            }
                        }
                    }
                }
               

                if( $goodTotalWeight <= $distributionDetail['FirstWeight'] )
                {
                    $payableFreight = $firstPrice;
                    $realFreight =  $firstPrice;
                }
                else
                {
                    $payableFreight = $firstPrice +  ceil( ( $goodTotalWeight - $distributionDetail['FirstWeight'])/$distributionDetail['SecondWeight']) * $secondPrice;
                    $realFreight = $firstPrice +  ceil( ( $goodTotalWeight - $distributionDetail['FirstWeight'])/$distributionDetail['SecondWeight']) * $secondPrice;
                }

                if($this->_request->getParam('ifinsured'))
                {
                    if( $distributionDetail['IsSavePrice'])
                    {
                        $insured = $distributionDetail['SaveRate'] * $payable;
                        if($insured < $distributionDetail['LowPrice'])
                        {
                            $insured = $distributionDetail['LowPrice'];
                        }
                        $insured = number_format($insured,2);
                    }
                }
            }

            $order['PayableFreight'] = $payableFreight;
            $order['RealFreight'] = $realFreight;
            $order['Insured'] = $insured;
            $order['OrderAmount'] = $order['PayableAmount'] + $order['PayableFreight'] + $order['Insured'] + $order['PayFee'] + $order['Taxes'] + $order['Discount'];

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

                if( $order['UserId'])
                {
                    $user = UserService::getUserById($order['UserId']);
                    if( $user && !empty($user))
                    {
                        $order['UserName'] = $user['Username'];
                    }
                    else
                    {
                        $order['UserName'] = '';
                    }
                }
                else
                {
                    $order['UserName'] = '';
                }
                if (!$order) {
                    // process not exist logic;
                }
            }
            else
            {
                $order['UserName'] = '';
            }
        }

        $this->view->orderInfo = $order;

    }

	public function detailAction()
    {
        $this->view->pageTitle = '订单详情';

        $orderId = $this->_request->getParam('order_id')?  intval($this->_request->getParam('order_id')) : 0;


        if ($orderId > 0) {
     
            $this->view->deliveries = DeliveryService::listAllDelivery();
            $this->view->payments = PaymentService::listActivePayment();
            $this->view->ordergoods = OrderGoodsService::listAllOrderGoodsByOrder($orderId);
            $order = OrderService::getOrderById($orderId);
            $this->view->provinceList = AreaService::listAreaByParent(0);
            $this->view->cityList = $order['Province'] ? AreaService::listAreaByParent($order['Province']) : array();
            $this->view->districtList = $order['City']? AreaService::listAreaByParent($order['City']) : array();

            if( $order['UserId'])
            {
                $user = UserService::getUserById($order['UserId']);
                if( $user && !empty($user))
                {
                    $order['UserName'] = $user['Username'];
                }
                else
                {
                    $order['UserName'] = '';
                }
            }
            else
            {
                $order['UserName'] = '';
            }
            $this->view->orderInfo = $order;
            $this->view->delivery = DeliveryService::getDeliveryById($order['Distribution']);
            $this->view->payment = PaymentService::getPaymentById($order['PayType']);
            $this->view->province = AreaService::getAreaById($order['Province']);
            $this->view->city = AreaService::getAreaById($order['City']);
            $this->view->area = AreaService::getAreaById($order['Area']);
            $this->view->logs = OrderLogService::listOrderLogByOrder($orderId);

        }
        else
        {
            $this->_redirect('/order/index/search');
        }
    }

    public function deleteAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $orderId =  intval($this->_request->getParam('orderid')) ;

        $order = array('OrderId' => $orderId);

        if ($this->_request->isPost()) {

            $result = OrderService::deleteOrder($order);
            $this->_helper->json->sendJson($result);
        }
    }

    public function savenoteAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $orderId =  intval($this->_request->getParam('order_id')) ;
        $orderNote =  $this->_request->getParam('note') ;

        $order = array('Note'=>$orderNote);

        if ($this->_request->isPost()) {

            $result = OrderService::updateOrder($orderId, $order);
            $this->_helper->json->sendJson($result);
        }
    }

    public function payorderAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $currentUser = $this->getCurrentUser();
        if( !$currentUser )
        {
            $this->_helper->json->sendJson(array('success' => false, 'message' => 'Need login' ));
            return;
        }

        $orderId =  intval($this->_request->getParam('order_id')) ;
        $orderNo =  $this->_request->getParam('order_no') ;
        $payNote =  $this->_request->getParam('note') ;
        $log= array(
                'OrderId' => $orderId,
                'User' => $currentUser["Username"],
                'Action'=>'付款',
                'AddTime'=>date('Y-m-d H:i:s'),
                'Result'=> '成功',
                'Note' => '订单【'.$orderNo.'】付款'.$this->_request->getParam('payamount')
            );
        $doc = array(
                'OrderId' => $orderId,
                'UserId' => $this->_request->getParam('userid'),
                'Amount' => $this->_request->getParam('orderamount'),
                'CreateTime'=>date('Y-m-d H:i:s'),
                'PaymentId'=> $this->_request->getParam('paymentid'),
                'AdminId' => $currentUser["UserId"],
                'PayStatus'=> 1,
                'Note' => $payNote
            );

        $order = array('Status'=> 2, 'PayStatus'=> 1);

        if ($this->_request->isPost()) {

            $result = OrderService::payOrder($orderId, $order, $log, $doc);
            $this->_helper->json->sendJson($result);
        }
    }

    public function deliverorderAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $currentUser = $this->getCurrentUser();
        if( !$currentUser )
        {
            $this->_helper->json->sendJson(array('success' => false, 'message' => 'Need login' ));
            return;
        }

        $orderId =  intval($this->_request->getParam('order_id')) ;
        $orderNo =  $this->_request->getParam('order_no') ;
        $deliveryNote =  $this->_request->getParam('note') ;
        $log= array(
                'OrderId' => $orderId,
                'User' => $currentUser["Username"],
                'Action'=>'发货',
                'AddTime'=>date('Y-m-d H:i:s'),
                'Result'=> '成功',
                'Note' => '订单【'.$orderNo.'】发货成功'
            );
        $doc = array(
                'OrderId' => $orderId,
                'AdminId' => $currentUser["UserId"],
                'UserId' => $this->_request->getParam('userid'),
                'Name' => $this->_request->getParam('name'),
                'Postcode' => $this->_request->getParam('postcode'),
                'Telphone' => $this->_request->getParam('telphone'),
                'Country' => 0,
                'Province'=>$this->_request->getParam('province'),
                'City'=>$this->_request->getParam('city'),
                'Area'=>$this->_request->getParam('area'),
                'Address'=>$this->_request->getParam('address'),
                'Mobile'=>$this->_request->getParam('mobile'),
                'CreateTime'=>date('Y-m-d H:i:s'),
                'Freight'=> $this->_request->getParam('freight'),
                'DeliveryCode' => $this->_request->getParam("deliverycode"),
                'DeliveryType' => $this->_request->getParam("deliverytype"),
                'Note' => $deliveryNote,
                'IsDeleted' => 0
            );

        $order = array( 'DistributionStatus'=> 1);

        if ($this->_request->isPost()) {

            $result = OrderService::deliverOrder($orderId, $order, $log, $doc);
            $this->_helper->json->sendJson($result);
        }
    }


    public function refundorderAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $currentUser = $this->getCurrentUser();
        if( !$currentUser )
        {
            $this->_helper->json->sendJson(array('success' => false, 'message' => 'Need login' ));
            return;
        }

        $orderId =  intval($this->_request->getParam('order_id')) ;
        $orderNo =  $this->_request->getParam('order_no') ;
        $log= array(
                'OrderId' => $orderId,
                'User' => $currentUser["Username"],
                'Action'=>'退款',
                'AddTime'=>date('Y-m-d H:i:s'),
                'Result'=> '成功',
                'Note' => '订单【'.$orderNo.'】退款'.$this->_request->getParam('refundamount')
            );
        $doc = array(
                'OrderId' => $orderId,
                'OrderNo' => $orderNo,
                'UserId' => $this->_request->getParam('userid'),
                'Amount' => $this->_request->getParam('refundamount'),
                'CreateTime'=>date('Y-m-d H:i:s'),
                'AdminId' => $currentUser["UserId"],
                'PayStatus'=> 2,
                'DisposeTime'=>date('Y-m-d H:i:s'),
                'DisposeIdea' => '退款成功'
            );

        $order = array('Status'=> 5, 'PayStatus'=> 2);

        if ($this->_request->isPost()) {

            $result = OrderService::refundOrder($orderId, $order, $log, $doc);
            $this->_helper->json->sendJson($result);
        }
    }

    public function completeorderAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $currentUser = $this->getCurrentUser();
        if( !$currentUser )
        {
            $this->_helper->json->sendJson(array('success' => false, 'message' => 'Need login' ));
            return;
        }

        $orderId =  intval($this->_request->getParam('order_id')) ;
        $orderNo =  $this->_request->getParam('order_no') ;
        $log= array(
                'OrderId' => $orderId,
                'User' => $currentUser["Username"],
                'Action'=>'完成',
                'AddTime'=>date('Y-m-d H:i:s'),
                'Result'=> '成功',
                'Note' => '订单【'.$orderNo.'】完成成功'
            );
    
        $order = array('Status'=> 5);

        if ($this->_request->isPost()) {

            $result = OrderService::completeOrder($orderId, $order, $log);
            $this->_helper->json->sendJson($result);
        }
    }

    public function discardorderAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $currentUser = $this->getCurrentUser();
        if( !$currentUser )
        {
            $this->_helper->json->sendJson(array('success' => false, 'message' => 'Need login' ));
            return;
        }

        $orderId =  intval($this->_request->getParam('order_id')) ;
        $orderNo =  $this->_request->getParam('order_no') ;
        $log= array(
                'OrderId' => $orderId,
                'User' => $currentUser["Username"],
                'Action'=>'作废',
                'AddTime'=>date('Y-m-d H:i:s'),
                'Result'=> '成功',
                'Note' => '订单【'.$orderNo.'】作废成功'
            );
    
        $order = array('Status'=> 4);

        if ($this->_request->isPost()) {

            $result = OrderService::discardOrder($orderId, $order, $log);
            $this->_helper->json->sendJson($result);
        }
    }


}
