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
use Welfony\Service\CompanyBalanceLogService;

class System_RevenueController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 10;


        $page = $this->_request->getParam('page')? intval($this->_request->getParam('page')) : 1;
        $searchResult = CompanyBalanceLogService::listCompanyBalanceLogByCompany(0, $page, $pageSize);


        $this->view->pageTitle = '收支列表 - 余额：'. number_format($searchResult['totalamount'], 2) . '元';
        $this->view->dataList = $searchResult['companybalancelogs'];

        $this->view->pager = $this->renderPager($this->view->baseUrl('system/revenue/search?s='),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));

    }

}
