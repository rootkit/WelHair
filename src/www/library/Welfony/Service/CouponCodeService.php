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

use Welfony\Repository\CouponCodeRepository;

class CouponCodeService
{

    /*public static function get($id)
    {
        return  BrandCategoryRepository::getInstance()->findCategoryById( $id);

    }
    */
    public static function listCouponCode($couponId, $pageNumber, $pageSize)
    {
        $result = array(
            'couponcodes' => array(),
            'total' => 0
        );

        $totalCount = CouponCodeRepository::getInstance()->getAllCouponCodeCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = CouponCodeRepository::getInstance()->listCouponCode( $couponId, $pageNumber, $pageSize);

            $result['couponcodes']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['CouponCodeId'] == 0) {

            $newId = CouponCodeRepository::getInstance()->save($data);
            if ($newId) {
                $data['CouponCodeId'] = $newId;

                $result['success'] = true;
                $result['couponcode'] = $data;

                return $result;
            } else {
                $result['message'] = '优惠券码失败！';

                return $result;
            }
        } else {

            $r = CouponCodeRepository::getInstance()->update($data['CouponCodeId'],$data);
            if ($r) {

                $result['success'] = true;
                $result['couponcode'] = $data;

                return $result;
            } else {
                $result['message'] = '优惠券码失败！';

                return $result;
            }

            return true;
        }
    }

    public static function batchsave($data)
    {
         $r =CouponCodeRepository::getInstance()->batchsave($data);
         if ($r) {

            $result['success'] = true;
            $result['couponcode'] = $data;

            return $result;
         } else {
            $result['message'] = '优惠券码失败！';

            return $result;
         }

         return true;
    }

    public static function deleteCouponCode($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = CouponCodeRepository::getInstance()->delete($data['CouponCodeId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除优惠码成功！';

            return $result;
        } else {
            $result['message'] = '删除优惠码失败！';

            return $result;
        }
    }

}
