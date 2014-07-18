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

use Welfony\Controller\Base\AbstractFrontendController;
use Welfony\Core\Enum\StaffStatus;
use Welfony\Core\Enum\UserRole;
use Welfony\Service\AreaService;
use Welfony\Service\CompanyService;
use Welfony\Service\StaffService;
use Welfony\Service\WithdrawalService;

class User_SalonController extends AbstractFrontendController
{

    private $companyId;

    public function init()
    {
        $this->needloginActionList['user'] = array('salon' => array('index', 'info', 'stylist', 'request', 'account'));
        parent::init();
    }

    public function preDispatch()
    {
        parent::preDispatch();

        if ($this->currentUser['Role'] != UserRole::Manager) {
            $this->_redirect($this->view->baseUrl(''));
        }

        $staffDetail = StaffService::getStaffDetail($this->currentUser['UserId']);
        $this->companyId = $staffDetail['Company']['CompanyId'];
    }

    public function indexAction()
    {
        $this->view->pageTitle = '沙龙管理';
        $this->_redirect($this->view->baseUrl('user/salon/info'));
    }

    public function infoAction()
    {
        $this->view->pageTitle = '沙龙资料';

        $company = CompanyService::getCompanyById($this->companyId);

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

            unset($company['ProvinceName']);
            unset($company['CityName']);
            unset($company['DistrictName']);

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

    public function stylistAction()
    {
        $this->view->pageTitle = '沙龙发型师';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $rstStaffList = StaffService::listAllStaff($this->companyId, StaffStatus::Valid, $page, $pageSize);

        $this->view->staffList = $rstStaffList['staffes'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('user/salon/stylist?'),
                                                $page,
                                                ceil($rstStaffList['total'] / $pageSize));
    }

    public function requestAction()
    {
        $this->view->pageTitle = '发型师请求';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $rstStaffList = StaffService::listAllStaff($this->companyId, StaffStatus::Requested, $page, $pageSize);

        $this->view->staffList = $rstStaffList['staffes'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('user/salon/stylist?'),
                                                $page,
                                                ceil($rstStaffList['total'] / $pageSize));
    }

    public function accountAction()
    {
        $this->view->pageTitle = '沙龙账户';

        if ($this->_request->isPost()) {
            $reqData = array();
            $reqData['WithdrawalId'] = 0;
            $reqData['CompanyId'] = $this->companyId;
            $reqData['Status'] = 0;
            $reqData['Amount'] = floatval($this->_request->getParam('amount'));
            $reqData['Bank'] = htmlspecialchars($this->_request->getParam('bank'));
            $reqData['OpenAccountBank'] = htmlspecialchars($this->_request->getParam('openaccountbank'));
            $reqData['AccountNo'] = htmlspecialchars($this->_request->getParam('accountno'));
            $reqData['AccountName'] = htmlspecialchars($this->_request->getParam('accountname'));

            $result = WithdrawalService::save($reqData);
            if ($result['success']) {
                $this->view->successMessage = '提交请求成功！';
                $this->_redirect($this->view->baseUrl('user/salon/withdrawhistory'));
            } else {
                $this->view->errorMessage = $result['message'];
            }
        }
        $this->view->companyInfo = CompanyService::getCompanyById($this->companyId);
    }

    public function withdrawhistoryAction()
    {
        $this->view->pageTitle = '提现记录';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $rstWithdrawHistory = WithdrawalService::listCompanyWithdrawal($page, $pageSize, $this->companyId);

        $this->view->dataList = $rstWithdrawHistory['withdrawals'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('user/salon/withdrawhistory?'),
                                                $page,
                                                ceil($rstWithdrawHistory['total'] / $pageSize));
    }

    public function revenueAction()
    {
        $this->view->pageTitle = '沙龙收益';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $rstCompanyRevenue = CompanyService::getCompanyRevenue($this->companyId, $page, $pageSize);

        $this->view->dataList = $rstCompanyRevenue['revenues'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('user/salon/revenue?'),
                                                $page,
                                                ceil($rstCompanyRevenue['total'] / $pageSize));
    }

}