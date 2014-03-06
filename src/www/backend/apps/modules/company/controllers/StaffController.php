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
use Welfony\Service\StaffService;

class Company_StaffController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '发型师列表';

        $company = array(
            'CompanyId' => 0
        );

        $companyId = intval($this->_request->getParam('company_id'));
        if ($companyId > 0) {
            $company = CompanyService::getCompanyById($companyId);
            $this->view->pageTitle .= (' - ' . $company['Name']);
        }

        $this->view->companyInfo = $company;

        $page = intval($this->_request->getParam('page'));
        $searchResult = StaffService::listAllStaff($page, $pageSize, $companyId);

        $this->view->dataList = $searchResult['staffes'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('company/staff/search?s=' . ($companyId > 0 ? '&company_id=' . $companyId : '')),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function addAction()
    {
        $this->view->pageTitle = '发型师';

        $company = array(
            'CompanyId' => 0,
            'Name' => '',
            'ProvinceName' => '',
            'CityName' => '',
            'DistrictName' => ''
        );

        $companyId = intval($this->_request->getParam('company_id'));
        if ($companyId > 0) {
            $company = CompanyService::getCompanyById($companyId);
        }

        $this->view->companyInfo = $company;

        if ($this->_request->isPost()) {
            $staffId = intval($this->_request->getParam('staff_id'));
            if ($companyId <= 0 || $staffId <= 0) {
                $this->view->errorMessage = "请选择沙龙或者发型师。";
                return;
            }

            $result = StaffService::saveCompanyStaff($staffId, $companyId, 1);
            if ($result) {
                $this->getResponse()->setRedirect($this->view->baseUrl('company/staff/search?company_id=' . $companyId));
            } else {
                $this->view->errorMessage = '保存失败！';
            }
        }

    }

    public function authenticationAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '发型师认证';
    }

}