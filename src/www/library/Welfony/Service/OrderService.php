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

use Welfony\Repository\OrderRepository;

class OrderService
{

    public static function getOrderById($id)
    {
        return  OrderRepository::getInstance()->findOrderById( $id);

    }

    public static function listOrder($pageNumber, $pageSize)
    {
        $result = array(
            'orders' => array(),
            'total' => 0
        );

        $totalCount = OrderRepository::getInstance()->getAllOrderCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = OrderRepository::getInstance()->listOrder( $pageNumber, $pageSize);

            $result['orders']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllOrder()
    {
        return $searchResult = OrderRepository::getInstance()->getAllOrder();
    }


    public static function save($data, $goods=null)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['OrderId'] == 0) {

            $newId = OrderRepository::getInstance()->save($data, $goods);
            if ($newId) {
                $data['OrderId'] = $newId;

                $result['success'] = true;
                $result['message'] = '添加订单成功！';
                $result['order'] = $data;

                return $result;
            } else {
                $result['message'] = '添加订单失败！';

                return $result;
            }
        } else {

            $r = OrderRepository::getInstance()->update($data['OrderId'],$data, $goods);
            if ($r) {

                $result['success'] = true;
                $result['message'] = '更新订单成功！';
                $result['order'] = $data;

                return $result;
            } else {
                $result['message'] = '更新订单失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteOrder($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = OrderRepository::getInstance()->delete($data['OrderId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除订单成功！';

            return $result;
        } else {
            $result['message'] = '删除订单失败！';

            return $result;
        }
    }

}
