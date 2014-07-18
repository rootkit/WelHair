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
use Welfony\Core\Enum\AppointmentStatus;
use Welfony\Core\Enum\CompanyStatus;
use Welfony\Core\Enum\Face;
use Welfony\Core\Enum\Gender;
use Welfony\Core\Enum\HairAmount;
use Welfony\Core\Enum\HairStyle;
use Welfony\Core\Enum\StaffStatus;
use Welfony\Core\Enum\UserRole;
use Welfony\Service\AreaService;
use Welfony\Service\AppointmentNoteService;
use Welfony\Service\AppointmentService;
use Welfony\Service\CompanyService;
use Welfony\Service\ServiceService;
use Welfony\Service\StaffService;
use Welfony\Service\UserService;
use Welfony\Service\WorkService;

class User_StylistController extends AbstractFrontendController
{

    private $staffStatus;

    public function init()
    {
        $this->needloginActionList['user'] = array('stylist' => array('index', 'hair', 'service', 'client', 'clientnote', 'clientappointment', 'appointment', 'createsalon', 'joinsalon', 'salon'));
        parent::init();
    }

    public function preDispatch()
    {
        parent::preDispatch();

        if ($this->currentUser['Role'] != UserRole::Staff) {
            $this->_redirect($this->view->baseUrl(''));
        }

        $this->staffStatus = StaffStatus::Unknown;

        $staff = StaffService::getStaffDetail($this->currentUser['UserId']);
        if ($staff && $staff['Company']) {
            $this->staffStatus = $staff['Status'];
        }

        if (!in_array($this->view->action, array('salon', 'createsalon', 'joinsalon'))) {
            $this->checkPermission($this->view->action == 'index' ? $this->view->baseUrl('user/stylist/hair') : '');
        }
    }

    public function indexAction()
    {
        $this->view->pageTitle = '发型师管理';
    }

    public function hairAction()
    {
        $this->view->pageTitle = '我的作品';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $searchResult = WorkService::listAllWorks($page, $pageSize, $this->currentUser['UserId']);

        $this->view->dataList = $searchResult['works'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('user/stylist/hair?'),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function haireditAction()
    {
        $this->view->pageTitle = '发型信息';

        $work = array(
            'WorkId' => intval($this->_request->getParam('hair_id')),
            'UserId' => $this->currentUser['UserId'],
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

                $this->_redirect($this->view->baseUrl('user/stylist/hair'));
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

    public function serviceAction()
    {
        $this->view->pageTitle = '我的服务';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $rstServiceList = ServiceService::listAllServices($page, $pageSize, $this->currentUser['UserId']);
        $this->view->dataList = $rstServiceList['services'];

        $this->view->pager = $this->renderPager($this->view->baseUrl('user/stylist/service?'),
                                                $page,
                                                ceil($rstServiceList['total'] / $pageSize));
    }

    public function serviceeditAction()
    {
        $this->view->pageTitle = '服务信息';

        $service = array(
            'ServiceId' => intval($this->_request->getParam('service_id')),
            'UserId' => $this->currentUser['UserId'],
            'Title' => '',
            'OldPrice' => 0,
            'Price' => 0
        );

        if ($this->_request->isPost()) {
            $title = htmlspecialchars($this->_request->getParam('title'));
            $oldPrice = floatval($this->_request->getParam('old_price'));
            $price = floatval($this->_request->getParam('price'));

            $service['Title'] = $title;
            $service['OldPrice'] = $oldPrice;
            $service['Price'] = $price;

            $result = ServiceService::save($service);
            if ($result['success']) {
                if ($service['ServiceId'] <= 0) {
                    $service['ServiceId'] = $result['service']['ServiceId'];
                }

                $this->view->successMessage = '保存作品成功！';

                $this->_redirect($this->view->baseUrl('user/stylist/service'));
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {
            if ($service['ServiceId'] > 0) {
                $service = ServiceService::getServiceById($service['ServiceId']);
                if (!$service) {
                    // process not exist logic;
                }
            }
        }

        $this->view->serviceInfo = $service;
    }

    public function clientAction()
    {
        $this->view->pageTitle = '我的客户';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $rstClientList = StaffService::listAllClients($page, $pageSize, $this->currentUser['UserId']);

        $this->view->dataList = $rstClientList['clients'];

        $this->view->pager = $this->renderPager($this->view->baseUrl('user/stylist/client?'),
                                                $page,
                                                ceil($rstClientList['total'] / $pageSize));
    }

    public function clientappointmentAction()
    {
        $this->view->pageTitle = '客户预约';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $userId = intval($this->_request->getParam('client_id'));

        $rstAppointment = AppointmentService::listAllAppointments($page, $pageSize, $this->currentUser['UserId'], $userId, array(AppointmentStatus::Paid, AppointmentStatus::Cancelled, AppointmentStatus::Completed));

        $this->view->appointmentList = $rstAppointment['appointments'];

        $this->view->pager = $this->renderPager($this->view->baseUrl('user/stylist/clientappointment?client_id=' . $userId),
                                                $page,
                                                ceil($rstAppointment['total'] / $pageSize));
    }

    public function clientnoteAction()
    {
        $this->view->pageTitle = '客户效果图';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $userId = intval($this->_request->getParam('client_id'));
        $this->view->userInfo = UserService::getUserById($userId);

        $rstNotes = AppointmentNoteService::listNoteByStaffAndUser($this->currentUser['UserId'], $userId, $page, $pageSize);
        $this->view->dataList = $rstNotes['appointmentNotes'];

        $this->view->pager = $this->renderPager($this->view->baseUrl('user/stylist/clientnote?client_id=' . $userId),
                                                $page,
                                                ceil($rstNotes['total'] / $pageSize));
    }

    public function appointmentAction()
    {
        $this->view->pageTitle = '我的客户预约';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $userId = intval($this->_request->getParam('user_id'));

        $rstAppointment = AppointmentService::listAllAppointments($page, $pageSize, $this->currentUser['UserId'], $userId, array(AppointmentStatus::Paid, AppointmentStatus::Cancelled, AppointmentStatus::Completed));

        $this->view->appointmentList = $rstAppointment['appointments'];

        $this->view->pager = $this->renderPager($this->view->baseUrl('user/stylist/appointment?'),
                                                $page,
                                                ceil($rstAppointment['total'] / $pageSize));
    }

    public function salonAction()
    {
        $this->view->pageTitle = '我的沙龙';

        $this->view->staffStatus = $this->staffStatus;
    }

    public function createsalonAction()
    {
        $this->view->pageTitle = '创建沙龙';

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
            $company['Status'] = CompanyStatus::Requested;
            $company['CreatedBy'] = $this->currentUser['UserId'];

            $result = CompanyService::save($company);
            if ($result['success']) {
                if ($company['CompanyId'] <= 0) {
                    $company['CompanyId'] = $result['company']['CompanyId'];
                }

                StaffService::saveCompanyStaff($this->currentUser['UserId'], $company['CompanyId'], StaffStatus::Requested);

                $this->_redirect($this->view->baseUrl('user/stylist/salon'));
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

    public function joinsalonAction()
    {
        $this->view->pageTitle = '加入沙龙';

        $this->view->searchText = htmlspecialchars($this->_request->getParam('s'));

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $searchResult = CompanyService::search($this->currentUser['UserId'], $this->view->searchText, $this->userContext->area['City']['AreaId'], 0, 0, $this->userContext->location, $page, $pageSize);
        $this->view->dataList = $searchResult['companies'];

        $this->view->params = array('s' => $this->view->searchText);

        $this->view->pager = $this->renderPager($this->view->baseUrl('user/stylist/joinsalon?' . http_build_query($this->view->params)),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    private function checkPermission($redirectUrl = '')
    {
        if ($this->staffStatus == StaffStatus::Valid) {
            if ($redirectUrl) {
                $this->_redirect($redirectUrl);
            }
        } else {
            $this->_redirect($this->view->baseUrl('user/stylist/salon'));
        }
    }

}