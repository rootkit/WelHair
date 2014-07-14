
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
use Welfony\Service\AddressService;
use Welfony\Service\GoodsService;
use Welfony\Service\OrderGoodsService;
use Welfony\Service\OrderService;
use Welfony\Service\UserService;

class Ajax_OrderController extends AbstractFrontendController
{

    public function indexAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $reqData = array();
        $reqData['OrderId'] = 0;
        $reqData['UserId'] = $this->currentUser['UserId'];
        $reqData['PayType'] = 1;
        $reqData['Distribution'] = 1;
        $reqData['AddressId'] = intval($this->_request->getParam('address_id'));
        $reqData['Items'] = array(array(
            'GoodsId' => intval($this->_request->getParam('goods_id')),
            'CompanyId' => intval($this->_request->getParam('company_id')),
            'ProductId' => intval($this->_request->getParam('product_id')),
            'Num' => intval($this->_request->getParam('goods_count'))
        ));

        $rstOrderCreate = OrderService::create($reqData);
        if ($rstOrderCreate['success']) {
            $this->payOrder($rstOrderCreate['order']['OrderId']);
        } else {
            $this->_helper->json->sendJson($rstOrderCreate);
        }
    }

    public function formAction()
    {
        $goodsId = intval($this->_request->getParam('goods_id'));
        $companyId = intval($this->_request->getParam('company_id'));
        $this->view->goodsDetail = GoodsService::getGoodsDetail($goodsId, $companyId, $this->currentUser['UserId'], $this->userContext->location);

        $rstAddressList = AddressService::listAllAddressesByUser($this->currentUser['UserId']);
        $this->view->addressList = $rstAddressList['addresses'];

        $ajaxContext = $this->_helper->getHelper('AjaxContext');
        $ajaxContext->addActionContext('form', 'html')
            ->initContext();
    }

    public function payAction()
    {
        $this->payOrder(intval($this->_request->getParam('order_id')));
    }

    private function payOrder($orderId)
    {
        $orderDetail = OrderService::getOrderDetailById($orderId);
        $userId = $this->currentUser['UserId'];

        if ($userId != $orderDetail['User']['UserId']) {
            $response['message'] = '不合法的用户信息！';
            $this->_helper->json->sendJson($response);
        }

        $user = UserService::getUserById($userId);
        if (!$user) {
            $response['message'] = '不合法的用户信息！';
            $this->_helper->json->sendJson($response);
        }

        if (floatval($user['Balance']) < $orderDetail['OrderAmount']) {
            $response['message'] = '用户账户余额不足，请充值！';
            $response['code'] = 2301;
            $this->_helper->json->sendJson($response);
        }

        $log= array(
            'OrderId' => $orderId,
            'User' => $user['Username'],
            'Action'=>'付款',
            'AddTime'=>date('Y-m-d H:i:s'),
            'Result'=> '成功',
            'Note' => '订单【'. $orderDetail['OrderNo'] .'】付款' . $orderDetail['OrderAmount'] . '元'
        );

        $doc = array(
            'OrderId' => $orderId,
            'UserId' => $userId,
            'Amount' => $orderDetail['OrderAmount'],
            'CreateTime'=>date('Y-m-d H:i:s'),
            'PaymentId'=> 1,
            'AdminId' => 0,
            'PayStatus'=> 1,
            'Note' => '用户付款'
        );

        $userbalancelog = array(
            'OrderId' => $orderId,
            'UserId' => $userId,
            'Amount' => -$orderDetail['OrderAmount'],
            'IncomeSrc' => 1,
            'IncomeSrcId' => $orderDetail['OrderNo'],
            'CreateTime'=>date('Y-m-d H:i:s'),
            'Status'=> 1,
            'Description'=> sprintf('订单【%s】付款%.2f元', $orderDetail['OrderNo'], floatval($orderDetail['OrderAmount']))
        );

        $ordergoods = OrderGoodsService::listAllOrderGoodsByOrder($orderId);
        $companyId = 0;

        foreach ($ordergoods as $goods) {
            if (intval($goods['CompanyId']) > 0) {
                $companyId = $goods['CompanyId'];
            } else {
                $companyId = 0;
            }
        }

        $companybalancelog = array(
            'OrderId' => $orderId,
            'CompanyId' => $companyId,
            'Amount' => $orderDetail['OrderAmount'],
            'CreateTime'=> date('Y-m-d H:i:s'),
            'Status'=> 1,
            'Description'=> sprintf('订单【%s】付款%.2f元', $orderDetail['OrderNo'], floatval($orderDetail['OrderAmount'])),
            'IncomeSrc' => 1,
            'IncomeSrcId' => $orderDetail['OrderNo']
        );

        $order = array('Status'=> 2, 'PayStatus'=> 1);
        $response = OrderService::payOrder($orderId, $order, $log, $doc, $userbalancelog, $companybalancelog, null);
        $this->_helper->json->sendJson($response);
    }

}
