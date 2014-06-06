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
use Welfony\Service\GoodsService;

class Company_GoodsController extends AbstractAdminController
{

    public function searchAction()
    {
        $this->view->pageTitle = '商品列表';

        $companyId = intval($this->_request->getParam('company_id'));
        if ($companyId > 0) {
            $company = CompanyService::getCompanyById($companyId);
            $this->view->pageTitle .= (' - ' . $company['Name']);
        }

        static $pageSize = 10;

        $page = intval($this->_request->getParam('page'));

        $searchResult = GoodsService::listGoodsAndProducts($page, $pageSize, $companyId);
        $this->view->rows = $searchResult['goods'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('company/goods/search?s='),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

}