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
use Welfony\Utility\Util;

class OrderService
{

    public static function listAllOrdersByUserId($userId, $status, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = OrderRepository::getInstance()->getAllOrdersCountByUserId($userId, $status);
        $orderList = OrderRepository::getInstance()->getAllOrdersByUserId($userId, $status, $page, $pageSize);

        return array('total' => $total, 'orders' => self::composeOrderDetail($orderList));
    }

    public static function getOrderById($id)
    {
        return  OrderRepository::getInstance()->findOrderById($id);
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
                        'CompanyId' => isset($item['CompanyId']) ? intval($item['CompanyId']) : 0,
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

                            $specArr = array();
                            $specJsonArr = json_decode($product['SpecArray'], true);
                            if (isset($specJsonArr['Name'])) {
                                $specArr[] = $specJsonArr['Name'] . '：' . $specJsonArr['Value'];
                            } else {
                                foreach($specJsonArr as $spec) {
                                    $specArr[] = $spec['Name'] . '：' . $spec['Value'];
                                }
                            }

                            $orderGoods['GoodsArray'] = json_encode(array(
                                'Name' => $goods['Name'],
                                'Value' => implode('，', $specArr)
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
            'OrderId' => isset($data['OrderId']) ? intval($data['OrderId']) : 0,
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

    public static function payOrder($orderId, $data, $log, $doc, $userbalancelog, $companybalancelog)
    {
        $result = array('success' => false, 'message' => '');
        $r = OrderRepository::getInstance()->payOrder($orderId,$data, $log, $doc, $userbalancelog, $companybalancelog);
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

    public static function refundOrder($orderId, $data, $log, $doc, $userbalancelog, $companybalancelog)
    {
        $result = array('success' => false, 'message' => '');
        $r = OrderRepository::getInstance()->refundOrder($orderId,$data, $log, $doc, $userbalancelog, $companybalancelog);
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

     private static function composeOrderDetail($dataset)
    {
        $result = array();

        foreach ($dataset as $row) {
            $orderDetailIndex = Util::keyValueExistedInArray($result, 'OrderId', $row['OrderId']);
            if ($orderDetailIndex === false) {
                $orderDetail = array(
                    'OrderId' => 0,
                    'User' => null,
                    'Goods' => array()
                );
            } else {
                $orderDetail = $result[$orderDetailIndex];
            }

            $orderDetail['OrderId'] = $row['OrderId'];
            $orderDetail['OrderNo'] = $row['OrderNo'];
            $orderDetail['Postscript'] = $row['Postscript'];

            $orderDetail['Status'] = $row['Status'];
            $orderDetail['PayType'] = $row['PayType'];
            $orderDetail['PayStatus'] = $row['PayStatus'];

            $orderDetail['Distribution'] = $row['Distribution'];
            $orderDetail['DistributionStatus'] = $row['DistributionStatus'];

            $orderDetail['ProvinceName'] = $row['ProvinceName'];
            $orderDetail['CityName'] = $row['CityName'];
            $orderDetail['DistrictName'] = $row['DistrictName'];
            $orderDetail['Address'] = $row['Address'];

            $orderDetail['AcceptName'] = $row['AcceptName'];
            $orderDetail['Mobile'] = $row['Mobile'];

            $orderDetail['OrderAmount'] = $row['OrderAmount'];
            $orderDetail['PayableAmount'] = $row['PayableAmount'];
            $orderDetail['PayableFreight'] = $row['PayableFreight'];

            $orderDetail['CreateTime'] = $row['CreateTime'];
            $orderDetail['SendTime'] = $row['SendTime'];
            $orderDetail['CompletionTime'] = $row['CompletionTime'];
            $orderDetail['AcceptTime'] = $row['AcceptTime'];

            if ($row['UserId'] > 0) {
                $orderDetail['User']['UserId'] =  $row['UserId'];
                $orderDetail['User']['Username'] = $row['Username'];
                $orderDetail['User']['Nickname'] = $row['Nickname'];
                $orderDetail['User']['Email'] = $row['Email'];
                $orderDetail['User']['AvatarUrl'] = $row['AvatarUrl'];
            }

            if ($row['OrderGoodsId'] > 0 && Util::keyValueExistedInArray($orderDetail['Goods'], 'OrderGoodsId', $row['OrderGoodsId']) === false) {
                $goods = array(
                    'OrderGoodsId' => $row['OrderGoodsId'],
                    'GoodsId' => $row['GoodsId'],
                    'ProductsId' => $row['ProductsId'],
                    'Img' => $row['Img'],
                    'GoodsNums' => $row['GoodsNums'],
                    'GoodsWeight' => $row['GoodsWeight'],
                    'GoodsPrice' => $row['GoodsPrice']
                );

                $goodsArray = json_decode($row['GoodsArray'], true);
                $goods['Name'] = $goodsArray['Name'];
                $goods['SpecDetail'] = $goodsArray['Value'];

                $orderDetail['Goods'][] = $goods;
            }

            if ($orderDetailIndex === false) {
                $result[] = $orderDetail;
            } else {
                $result[$orderDetailIndex] = $orderDetail;
            }
        }

        return $result;
    }

}
