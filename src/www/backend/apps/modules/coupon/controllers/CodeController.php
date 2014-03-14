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
use Welfony\Service\CouponCodeService;

class Coupon_CodeController extends AbstractAdminController
{

    public function searchAction()
    {
        $this->view->pageTitle = '优惠码列表';

        $pageSize = 10;
        $page =  intval($this->_request->getParam('page'));
		$couponid =  intval($this->_request->getParam('coupon_id'));
        $this->view->couponid= $couponid;

        $page =  $page<=0? 1 : $page;

        $result = CouponCodeService::listCouponCode($couponid, $page, $pageSize);

        $this->view->rows = $result['couponcodes'];

        $this->view->pagerHTML =  $this->renderPager($this->view->baseUrl('/coupon/code/search?cid='.$couponid),
                                                     $page,
                                                     ceil($result['total'] / $pageSize));


    }

    public function infoAction()
    {
    	$this->view->pageTitle = '添加优惠码';

        $couponid =  intval($this->_request->getParam('coupon_id'));
        $this->view->couponid= $couponid;

    	if ($this->_request->isPost()) {

            $result = CouponCodeService::batchsave($this->_request->getParam('codes'));
            if ($result['success']) {
            
                $this->view->successMessage = '保存优惠码成功！';
            } else {
                $this->view->errorMessage = $result['message'];
            }
        }
    }

    

}