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

class Coupon_IndexController extends AbstractAdminController
{

    public function searchAction()
    {
        $this->view->pageTitle = '优惠券列表';
    }

    public function infoAction()
    {
    	$this->view->pageTitle = '添加优惠券';

    	$couponInfo = array(
    		'CouponId' => 0,
    		'CompanyName' => '',
    		'CompanyId' => '',
    		'CouponName' => '',
    	);


    	$this->view->couponInfo = $couponInfo;
    }

}