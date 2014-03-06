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
use Welfony\Core\Enum\Face;
use Welfony\Core\Enum\Gender;
use Welfony\Core\Enum\HairAmount;
use Welfony\Core\Enum\HairStyle;
use Welfony\Service\CompanyService;
use Welfony\Service\StaffService;
use Welfony\Service\UserService;
use Welfony\Service\WorkService;

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

    public function workAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '发型师作品';

        $staff = array(
            'UserId' => 0
        );

        $staffId = intval($this->_request->getParam('staff_id'));
        if ($staffId > 0) {
            $staff = UserService::getUserById($staffId);
            $this->view->pageTitle = $staff['Nickname'] . '的作品';
        }

        $this->view->staffInfo = $staff;

        $page = intval($this->_request->getParam('page'));
        $searchResult = WorkService::listAllWorks($page, $pageSize, $staffId);

        $this->view->dataList = $searchResult['works'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('company/staff/work?s=' . ($staffId > 0 ? '&staff_id=' . $staffId : '')),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function workinfoAction()
    {
        $this->view->pageTitle = '作品';

        $work = array(
            'WorkId' => intval($this->_request->getParam('work_id')),
            'UserId' => intval($this->_request->getParam('staff_id')),
            'Title' => '',
            'Gender' => Gender::Male,
            'Face' => Face::Round,
            'HairAmount' => HairAmount::Normal,
            'HairStyle' => HairStyle::Normal,
            'PictureUrl' => array()
        );

        if ($this->_request->isPost()) {
            $title = htmlspecialchars($this->_request->getParam('title'));
            $pictureUrl = $this->_request->getParam('work_picture_url');
            $gender = intval($this->_request->getParam('gender'));
            $hairamount = intval($this->_request->getParam('hair_amount'));
            $hairstyle = intval($this->_request->getParam('hair_style'));
            $face = htmlspecialchars($this->_request->getParam('face'));

            $work['Title'] = $title;
            $work['PictureUrl'] = $pictureUrl;
            $work['Gender'] = $gender;
            $work['Face'] = $face;
            $work['HairAmount'] = $hairamount;
            $work['HairStyle'] = $hairstyle;

            $result = WorkService::save($work);
            if ($result['success']) {
                if ($work['WorkId'] <= 0) {
                    $work['WorkId'] = $result['work']['WorkId'];
                }

                $this->view->successMessage = '保存作品成功！';
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {
            if ($work['WorkId'] > 0) {
                $work = WorkService::getWorkById($work['WorkId']);
                if (!$work) {
                    // process not exist logic;
                }
            }
        }

        $this->view->workInfo = $work;
    }

}