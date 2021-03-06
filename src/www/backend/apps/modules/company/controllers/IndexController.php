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
use Welfony\Core\Enum\CompanyStatus;
use Welfony\Service\AreaService;
use Welfony\Service\CompanyService;
use Welfony\Service\CompanyBalanceLogService;
use Welfony\Service\GoodsService;
use Welfony\Service\WithdrawalService;
use Welfony\Service\WithdrawalLogService;
use Welfony\Service\DepositService;

class Company_IndexController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '沙龙列表';

        $page = intval($this->_request->getParam('page'));
        $searchResult = CompanyService::listAllCompanies(array(
            CompanyStatus::Invalid,
            CompanyStatus::Valid
        ), $page, $pageSize);

        $this->view->dataList = $searchResult['companies'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('company/index/search?s='),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function infoAction()
    {
        $this->view->pageTitle = '沙龙信息';

        $company = array(
            'CompanyId' => intval($this->_request->getParam('company_id')),
            'LogoUrl' => '',
            'Name' => '',
            'Status' => CompanyStatus::Invalid,
            'Tel' => '',
            'Mobile' => '',
            'Province' => '',
            'City' => '',
            'District' => '',
            'Address' => '',
            'Latitude' => 36.682785,
            'Longitude' => 117.024967,
            'PictureUrl' => array()
        );

        if ($this->_request->isPost()) {
            $companyName = htmlspecialchars($this->_request->getParam('companyname'));
            $logoUrl = $this->_request->getParam('logo_url');
            $tel = htmlspecialchars($this->_request->getParam('tel'));
            $mobile = htmlspecialchars($this->_request->getParam('mobile'));
            $province = intval($this->_request->getParam('province'));
            $city = intval($this->_request->getParam('city'));
            $district = intval($this->_request->getParam('district'));
            $address = htmlspecialchars($this->_request->getParam('address'));
            $latitude = doubleval($this->_request->getParam('latitude'));
            $longitude = doubleval($this->_request->getParam('longitude'));
            $pictureUrl = $this->_request->getParam('company_picture_url');
            $status = htmlspecialchars($this->_request->getParam('status'));

            $company['Name'] = $companyName;
            $company['LogoUrl'] = $logoUrl;
            $company['Tel'] = $tel;
            $company['Mobile'] = $mobile;
            $company['Province'] = $province;
            $company['City'] = $city;
            $company['District'] = $district;
            $company['Address'] = $address;
            $company['Latitude'] = $latitude;
            $company['Longitude'] = $longitude;
            $company['PictureUrl'] = $pictureUrl ? $pictureUrl : array();
            $company['Status'] = $status;

            $result = CompanyService::save($company);
            if ($result['success']) {
                if ($company['CompanyId'] <= 0) {
                    $company['CompanyId'] = $result['company']['CompanyId'];
                }

                $this->view->successMessage = '保存用户成功！';
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {
            if ($company['CompanyId'] > 0) {
                $company = CompanyService::getCompanyById($company['CompanyId']);
                if (!$company) {
                    // process not exist logic;
                }
            }
        }

        $this->view->companyInfo = $company;
        $this->view->provinceList = AreaService::listAreaByParent(0);
        $this->view->cityList = intval($company['Province']) > 0 ? AreaService::listAreaByParent($company['Province']) : array();
        $this->view->districtList = intval($company['City']) > 0 ? AreaService::listAreaByParent($company['City']) : array();
    }

    public function authenticationAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '沙龙请求';

        $page = intval($this->_request->getParam('page'));
        $searchResult = CompanyService::listAllCompanies(array(
            CompanyStatus::Requested
        ), $page, $pageSize);

        $this->view->dataList = $searchResult['companies'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('company/index/authentication?s='),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function selectAction()
    {
        $this->_helper->layout->disableLayout();

        static $pageSize = 10;

        $page = intval($this->_request->getParam('page'));
        $func = $this->_request->getParam('func');
        $searchResult = CompanyService::listAllCompanies(CompanyStatus::Valid, $page, $pageSize);

        $this->view->dataList = $searchResult['companies'];
        $this->view->pager = $this->renderPager('',
                                                $page,
                                                ceil($searchResult['total'] / $pageSize), $func);
    }

    public function balancelogAction()
    {
        $companyId = intval($this->_request->getParam('company_id'));
        static $pageSize = 10;

        $this->view->pageTitle = '余额历史记录';

        $page = $this->_request->getParam('page')? intval($this->_request->getParam('page')) : 1;
        $searchResult = CompanyBalanceLogService::listCompanyBalanceLogByCompany($companyId, $page, $pageSize);

        $this->view->dataList = $searchResult['companybalancelogs'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('company/index/balancelog?s='),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function withdrawalsearchAction()
    {

        //$userId = intval($this->_request->getParam('user_id'));
        static $pageSize = 10;

        $this->view->pageTitle = '提现请求';

        $page = $this->_request->getParam('page')? intval($this->_request->getParam('page')) : 1;
        $searchResult = WithdrawalService::listCompanyWithdrawal($page, $pageSize);

        $this->view->dataList = $searchResult['withdrawals'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('company/index/withdrawal?s='),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function withdrawalinfoAction()
    {
        $this->view->pageTitle = '提现详情';
        $withdrawalid = intval($this->_request->getParam('withdrawal_id'));
        if ($withdrawalid) {
            $withdrawal = WithdrawalService::getWithdrawalById($withdrawalid);
            $this->view->withdrawalInfo= $withdrawal;
            $logs = WithdrawalLogService::listWithdrawalLogByWithdrawal($withdrawalid, 1, 1000);
            $this->view->logs = $logs['withdrawallogs'];
        }
    }

}
