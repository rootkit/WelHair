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

use Welfony\Repository\AddressRepository;
use Welfony\Repository\GoodsRepository;
use Welfony\Repository\OrderRepository;
use Welfony\Repository\ProductsRepository;

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

    public static function create($data)
    {
        $result = array('success' => false, 'message' => '');

        if (!isset($data['UserId']) || intval($data['UserId']) <= 0) {
            $result['message'] = '用户不合法。';

            return $result;
        }

        if (!isset($data['AddressId']) || intval($data['AddressId']) <= 0) {
            $result['message'] = '请选择收货地址。';

            return $result;
        }

        if (!isset($data['PayType']) || intval($data['PayType']) <= 0) {
            $result['message'] = '请选择支付方式。';

            return $result;
        }

        if (!isset($data['Distribution']) || intval($data['Distribution']) <= 0) {
            $result['message'] = '请选择快递方式。';

            return $result;
        }

        $address = AddressRepository::getInstance()->findAddressById(intval($data['AddressId']));
        if (!$address) {
            $result['message'] = '请选择收货地址。';

            return $result;
        }

        if (!isset($data['Items']) || count($data['Items']) <= 0) {
            $result['message'] = '请选择商品。';

            return $result;
        }

        $orderGoodsList = array();
        foreach ($data['Items'] as $item) {
            if (!isset($item['Num']) || intval($item['Num']) <= 0) {
                continue;
            }

            if (isset($item['GoodsId']) && intval($item['GoodsId']) > 0) {
                $goods = GoodsRepository::getInstance()->findGoodsById($item['GoodsId']);
                if ($goods) {
                    $orderGoods =  array(
                        'GoodsId' => $goods['GoodsId'],
                        'Img' => $goods['Img'],
                        'ProductsId' => 0,
                        'GoodsPrice' => $goods['SellPrice'],
                        'RealPrice' => $goods['SellPrice'],
                        'GoodsNums' => $item['Num'],
                        'GoodsWeight' => $goods['Weight'],
                        'GoodsArray' => json_encode(array(
                            'Name' => $goods['Name'],
                            'Value' => ''
                        ))
                    );

                    if (isset($item['ProductId']) && intval($item['ProductId']) > 0) {
                        $product = ProductsRepository::getInstance()->findProductsById($item['ProductId']);
                        if ($product) {
                            $orderGoods['ProductsId'] = $product['ProductsId'];
                            $orderGoods['GoodsPrice'] = $product['SellPrice'];
                            $orderGoods['RealPrice'] = $product['SellPrice'];
                            $orderGoods['GoodsWeight'] = $product['Weight'];
                            $orderGoods['GoodsArray'] = json_encode(array(
                                'Name' => $goods['Name'],
                                'Value' => ''
                            ));
                        }
                    }

                    $orderGoodsList[] = $orderGoods;
                }
            }
        }

        $totalPrice = 0;
        $totalWeight = 0;
        $totalFreight = 10;
        foreach ($orderGoodsList as $og) {
            $totalPrice += abs($og['RealPrice'] * $og['GoodsNums']);
            $totalWeight += abs($og['GoodsWeight']);
        }

        $orderData = array(
            'OrderNo' => date('YmdHis').rand(100000, 999999),
            'PayableAmount' => $totalPrice,
            'RealAmount' => $totalPrice,

            'UserId' => intval($data['UserId']),
            'Postscript' => isset($data['Postscript']) ? htmlspecialchars($data['Postscript']) : '',

            'AcceptName' => $address['ShippingName'],
            'Province' => $address['Province'],
            'City' => $address['City'],
            'Area' => $address['District'],
            'Address' => $address['Address'],
            'Postcode' => '',
            'Mobile' => $address['Mobile'],
            'Telphone' => '',

            'PayType' => intval($data['PayType']),
            'PayFee' => 0,

            'IfInsured' => 0,
            'Insured' => 0,

            'Distribution' => intval($data['Distribution']),
            'PayableFreight' => $totalFreight,
            'RealFreight' => $totalFreight,

            'Invoice' => 0,
            'InvoiceTitle' => '',

            'OrderAmount' => $totalPrice + $totalFreight,
            'Discount' => 0,

            'CreateTime' => date('Y-m-d H:i:s'),
            'IsDeleted' => 0
        );

        return OrderService::save($orderData, $orderGoodsList);
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

    public static function updateOrder($orderId, $data)
    {
        $result = array('success' => false, 'message' => '');
        $r = OrderRepository::getInstance()->updateOrder($orderId,$data);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '更新订单成功！';
            $result['order'] = $data;

            return $result;
        } else {
            $result['message'] = '更新订单失败！';

            return $result;
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

    public static function payOrder($orderId, $data, $log, $doc)
    {
        $result = array('success' => false, 'message' => '');
        $r = OrderRepository::getInstance()->payOrder($orderId,$data, $log, $doc);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '付款成功！';
            //$result['order'] = $data;
            return $result;
        } else {
            $result['message'] = '付款失败！';

            return $result;
        }
    }

    public static function deliverOrder($orderId, $data, $log, $doc)
    {
        $result = array('success' => false, 'message' => '');
        $r = OrderRepository::getInstance()->deliverOrder($orderId,$data, $log, $doc);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '发货成功！';
            //$result['order'] = $data;
            return $result;
        } else {
            $result['message'] = '发货失败！';

            return $result;
        }
    }

    public static function refundOrder($orderId, $data, $log, $doc)
    {
        $result = array('success' => false, 'message' => '');
        $r = OrderRepository::getInstance()->refundOrder($orderId,$data, $log, $doc);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '退款成功！';
            //$result['order'] = $data;
            return $result;
        } else {
            $result['message'] = '退款失败！';

            return $result;
        }
    }

    public static function completeOrder($orderId, $data, $log)
    {
        $result = array('success' => false, 'message' => '');
        $r = OrderRepository::getInstance()->completeOrder($orderId,$data, $log);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '完成成功！';
            //$result['order'] = $data;
            return $result;
        } else {
            $result['message'] = '完成失败！';

            return $result;
        }
    }

    public static function discardOrder($orderId, $data, $log)
    {
        $result = array('success' => false, 'message' => '');
        $r = OrderRepository::getInstance()->completeOrder($orderId,$data, $log);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '作废成功！';
            //$result['order'] = $data;
            return $result;
        } else {
            $result['message'] = '作废失败！';

            return $result;
        }
    }

}
