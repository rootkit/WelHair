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
use Welfony\Repository\OrderGoodsRepository;

class OrderGoodsService
{

    public static function getOrderGoodsById($id)
    {
        return  OrderGoodsRepository::getInstance()->findOrderGoodsById( $id);
    }

    public static function listOrderGoods($pageNumber, $pageSize)
    {
        $result = array(
            'products' => array(),
            'total' => 0
        );

        $totalCount = OrderGoodsRepository::getInstance()->getAllSpecCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = OrderGoodsRepository::getInstance()->listOrderGoods( $pageNumber, $pageSize);

            $result['products']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllProducts()
    {
        return $searchResult = OrderGoodsRepository::getInstance()->getAllOrderGoods();
    }
    
    public static function listAllOrderGoodsByOrder($orderId)
    {
        return $searchResult = OrderGoodsRepository::getInstance()->getAllOrderGoodsByOrder($orderId);
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['Id'] == 0) {

            $newId = OrderGoodsRepository::getInstance()->save($data);
            if ($newId) {
                $data['Id'] = $newId;

                $result['success'] = true;
                $result['message'] = '添加商品品成功！';
                $result['ordergoods'] = $data;

                return $result;
            } else {
                $result['message'] = '添加商品失败！';

                return $result;
            }
        } else {

            $r = OrderGoodsRepository::getInstance()->update($data['Id'],$data);
            if ($r) {

                $result['success'] = true;
                $result['message'] = '更新商品成功！';
                $result['ordergoods'] = $data;

                return $result;
            } else {
                $result['message'] = '更新商品失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteOrderGoods($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = OrderGoodsRepository::getInstance()->delete($data['Id']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除商品成功！';

            return $result;
        } else {
            $result['message'] = '删除商品失败！';

            return $result;
        }
    }

}
