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

    /*public static function get($id)
    {
        return  BrandCategoryRepository::getInstance()->findCategoryById( $id);

    }
    */
    public static function listCoupon($pageNumber, $pageSize)
    {
        $result = array(
            'coupons' => array(),
            'total' => 0
        );

        $totalCount = CouponRepository::getInstance()->getAllCouponCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = CouponRepository::getInstance()->listCoupon( $pageNumber, $pageSize);

            $result['brands']= $searchResult;
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

}
