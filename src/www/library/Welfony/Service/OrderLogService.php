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

namespace Welfony\Service;

use Welfony\Repository\OrderLogRepository;

class OrderLogService
{

    public static function getOrderLogById($id)
    {
        return  OrderLogRepository::getInstance()->findOrderLogById( $id);

    }
    public static function listOrderLog($orderId, $pageNumber, $pageSize)
    {
        $result = array(
            'orderlogs' => array(),
            'total' => 0
        );

        $totalCount = OrderLogRepository::getInstance()->getAllOrderLogCount($orderId);

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult =  OrderLogRepository::getInstance()->listOrderLog( $orderId, $pageNumber, $pageSize);

            $result['orderlogs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listOrderLogByOrder($orderId)
    {
        return $searchResult = OrderLogRepository::getInstance()->getOrderLogByOrder($orderId);

    }

    public static function listOrderLogByAction($orderId, $action)
    {
        return $searchResult = OrderLogRepository::getInstance()->getOrderLogByAction($orderId, $action);
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['Id'] == 0) {

            $newId = OrderLogRepository::getInstance()->save($data);
            if ($newId) {
                $data['Id'] = $newId;

                $result['success'] = true;
                $result['orderlog'] = $data;

                return $result;
            } else {
                $result['message'] = '添加订单日志失败！';

                return $result;
            }
        } else {
            $id = $data['Id'];
            $r = OrderLogRepository::getInstance()->update($id,$data);
            if ($r) {

                $result['success'] = true;
                $result['orderlog'] = $data;

                return $result;
            } else {
                $result['message'] = '更新订单日志失败！';

                return $result;
            }

            return true;
        }
    }

}
