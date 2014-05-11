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
use Welfony\Service\PaymentTransactionService;
use Welfony\Utility\Util;

class IndexController extends AbstractAdminController
{

    public function indexAction()
    {
        $this->view->pageTitle = '后台管理系统';
    }

    public function paymenttransactionsearchAction()
    {
        //$userId = intval($this->_request->getParam('user_id'));
        static $pageSize = 10;

        
        $this->view->sum = PaymentTransactionService::getPaymentTransactionSum();

        $this->view->pageTitle = '收支列表'.' 余额:'. number_format( $this->view->sum,2);


        $page = $this->_request->getParam('page')? intval($this->_request->getParam('page')) : 1;
        $searchResult = PaymentTransactionService::listPaymentTransaction($page, $pageSize);

        $this->view->dataList = $searchResult['paymenttransactions'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('default/index/paymenttransactionsearch?s='),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

}
