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

use Welfony\Repository\PaymentRepository;

class PaymentService
{

    public static function getPaymentById($id)
    {
        return  PaymentRepository::getInstance()->findPaymentById( $id);

    }
    public static function listPayment($pageNumber, $pageSize)
    {
        $result = array(
            'payments' => array(),
            'total' => 0
        );

        $totalCount = PaymentRepository::getInstance()->getAllPaymentCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = PaymentRepository::getInstance()->listPayment( $pageNumber, $pageSize);

            $result['payments']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllPayment()
    {
        return $searchResult = PaymentRepository::getInstance()->getAllPayment();

    }

    public static function listActivePayment()
    {
        return $searchResult = PaymentRepository::getInstance()->getActivePayment();

    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['PaymentId'] == 0) {

            $newId = PaymentRepository::getInstance()->save($data);
            if ($newId) {
                $data['PaymentId'] = $newId;

                $result['success'] = true;
                $result['payment'] = $data;

                return $result;
            } else {
                $result['message'] = '添加支付方式失败！';

                return $result;
            }
        } else {
            $id = $data['PaymentId'];
            $r = PaymentRepository::getInstance()->update($id,$data);
            if ($r) {

                $result['success'] = true;
                $result['payment'] = $data;

                return $result;
            } else {
                $result['message'] = '更新支付方式失败！';

                return $result;
            }

            return true;
        }
    }

}
