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

use Welfony\Repository\CouponRepository;

class CouponService
{

    public static function getCouponById($id)
    {
        return  CouponRepository::getInstance()->findCouponById( $id);

    }

    public static function listCoupon($pageNumber, $pageSize)
    {
        $result = array(
            'coupons' => array(),
            'total' => 0
        );

        $totalCount = CouponRepository::getInstance()->getAllCouponCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = CouponRepository::getInstance()->listCoupon( $pageNumber, $pageSize);

            $result['coupons']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['CouponId'] == 0) {

            $newId = CouponRepository::getInstance()->save($data);
            if ($newId) {
                $data['CouponId'] = $newId;

                $result['success'] = true;
                $result['coupon'] = $data;

                return $result;
            } else {
                $result['message'] = '添加优惠券失败！';

                return $result;
            }
        } else {

            $r = CouponRepository::getInstance()->update($data['CouponId'],$data);
            if ($r) {

                $result['success'] = true;
                $result['coupon'] = $data;

                return $result;
            } else {
                $result['message'] = '更新优惠券失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteCoupon($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = CouponRepository::getInstance()->delete($data['CouponId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除优惠券成功！';

            return $result;
        } else {
            $result['message'] = '删除优惠券失败！';

            return $result;
        }
    }

    public static function updateCouponStatus($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = CouponRepository::getInstance()->updateStatus($data['CouponId'], $data['IsActive']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '更新优惠券成功！';

            return $result;
        } else {
            $result['message'] = '更新优惠券失败！';

            return $result;
        }

    }

    public static function listCouponType()
    {
        $searchResult = CouponRepository::getInstance()->getAllCouponType();

        return $searchResult;
    }

    public static function listCouponPaymentType()
    {

        $searchResult = CouponRepository::getInstance()->getAllCouponPaymentType();

        return $searchResult;
    }

    public static function listCouponAmountLimitType()
    {

        $searchResult = CouponRepository::getInstance()->getAllCouponAmountLimitType();

        return $searchResult;
    }

    public static function listCouponAccountLimitType()
    {

        $searchResult = CouponRepository::getInstance()->getAllCouponAccountLimitType();

        return $searchResult;
    }

}
