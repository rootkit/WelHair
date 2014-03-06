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

    }

    public function authenticationAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '发型师认证';
    }

}