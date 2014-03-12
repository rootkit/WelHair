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

use Welfony\Controller\Base\AbstractAdminController;
use Welfony\Service\CompanyService;
use Welfony\Service\CouponService;

class Coupon_IndexController extends AbstractAdminController
{

    public function searchAction()
    {
        $this->view->pageTitle = '优惠券列表';

        $pageSize = 10;
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = CouponService::listCoupon($page, $pageSize);

        $this->view->rows = $result['coupons'];

        $this->view->pagerHTML =  $this->renderPager($this->view->baseUrl('/coupon/index/search?'),
                                                     $page,
                                                     ceil($result['total'] / $pageSize));


    }

    public function infoAction()
    {
    	$this->view->pageTitle = '添加优惠券';

    	

        $this->view->couponTypes = CouponService::listCouponType();
        $this->view->couponPaymentTypes = CouponService::listCouponPaymentType();
        $this->view->couponAmountLimitTypes = CouponService::listCouponAmountLimitType();
        $this->view->couponAccountLimitTypes = CouponService::listCouponAccountLimitType();
    	



        $couponId = $this->_request->getParam('coupon_id')?  intval($this->_request->getParam('coupon_id')) : 0;


        $coupon = array(
            'CouponId' => $couponId,
            'CompanyName' => '',
            'ImageUrl' => '',
            'CompanyId' => '',
            'CouponName' => '',
            'CouponTypeId' => 0,
            'CouponTypeValue' => '',
            'IsLiveActivity' =>0,
            'LiveActivityAmount' =>'',
            'LiveActivityAddress' =>'',
            'HasExpire' => 0,
            'ExpireDate' =>'',
            'CouponAmountLimitTypeId' => 0,
            'CouponAccountLimitTypeId' => 0,
            'CouponPaymentTypeId' => 0,
            'CouponPaymentValue' => '',
            'Usage' => '',
            'Commments' => '',
            'IsCouponCodeSecret' => 0,
            'IsDelete' => 0,
            'IsActive' => 1
        );


        if ($this->_request->isPost()) {
            $coupon['CouponName']= htmlspecialchars($this->_request->getParam('couponname'));
            $coupon['CompanyName']= htmlspecialchars($this->_request->getParam('companyname'));
            $coupon['CompanyId']= $this->_request->getParam('companyid');
            $coupon['ImageUrl']= htmlspecialchars($this->_request->getParam('imageurl'));
            $coupon['CouponTypeId']= $this->_request->getParam('coupontypeid');
            $coupon['CouponTypeValue']= htmlspecialchars($this->_request->getParam('coupontypevalue'));
            $coupon['IsLiveActivity']= $this->_request->getParam('isliveactivity');
            $coupon['LiveActivityAmount']= htmlspecialchars($this->_request->getParam('liveactivityamount'));
            $coupon['LiveActivityAddress']= htmlspecialchars($this->_request->getParam('liveactivityaddress'));
            $coupon['HasExpire']= $this->_request->getParam('hasexpire');
            $coupon['ExpireDate']= htmlspecialchars($this->_request->getParam('expiredate'));
            $coupon['CouponAccountLimitTypeId']= htmlspecialchars($this->_request->getParam('couponaccountlimittypeid'));
            $coupon['CouponAmountLimitTypeId']= htmlspecialchars($this->_request->getParam('couponamountlimittypeid'));
            $coupon['CouponPaymentTypeId']= $this->_request->getParam('couponpaymenttypeid');
            $coupon['CouponPaymentValue']= htmlspecialchars($this->_request->getParam('couponpaymentvalue'));
            $coupon['Usage']= htmlspecialchars($this->_request->getParam('usage'));
            $coupon['Commments']= htmlspecialchars($this->_request->getParam('comments'));
            $coupon['IsCouponCodeSecret']= $this->_request->getParam('iscouponcodesecret');


            $result = CouponService::save($coupon);
            if ($result['success']) {

            
                $this->view->successMessage = '保存优惠券成功！';
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {

            
            if ($couponId > 0) {
                $coupon = CouponService::getCouponById($couponId);
                if (!$coupon) {
                    // process not exist logic;
                }
            }
        }

        $this->view->couponInfo = $coupon;
    }

    

}