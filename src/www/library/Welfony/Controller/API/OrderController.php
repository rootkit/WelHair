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

namespace Welfony\Controller\API;

use Welfony\Controller\Base\AbstractAPIController;
use Welfony\Service\OrderGoodsService;
use Welfony\Service\OrderService;
use Welfony\Service\UserService;

class OrderController extends AbstractAPIController
{

    public function listAllOrdersByUserId($userId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $status = intval($this->app->request->get('status'));

        $this->sendResponse(OrderService::listAllOrdersByUserId($userId, $status, $page, $pageSize));
    }

    public function create()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['OrderId'] = 0;

        $result = OrderService::create($reqData);
        $this->sendResponse($result);
    }

    public function pay($orderId)
    {
        $response = array('success' => false);

        $orderDetail = OrderService::getOrderDetailById($orderId);

        $userId = $this->currentContext['UserId'];

        if ($userId != $orderDetail['User']['UserId']) {
            $response['message'] = '不合法的用户信息！';
            $this->sendResponse($response);
        }

        $user = UserService::getUserById($userId);
        if (!$user) {
            $response['message'] = '不合法的用户信息！';
            $this->sendResponse($response);
        }

        if (floatval($user['Balance']) < $orderDetail['OrderAmount']) {
            $response['message'] = '用户账户余额不足，请充值！';
            $this->sendResponse($response);
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

        $this->sendResponse($response);
    }

}
