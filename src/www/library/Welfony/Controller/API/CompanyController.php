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

namespace Welfony\Controller\API;

use Welfony\Controller\Base\AbstractAPIController;
use Welfony\Core\Enum\CompanyStatus;
use Welfony\Core\Enum\StaffStatus;
use Welfony\Service\AreaService;
use Welfony\Service\CommentService;
use Welfony\Service\CompanyService;
use Welfony\Service\StaffService;
use Welfony\Service\UserLikeService;
use Welfony\Service\CompanyBalanceLogService;

class CompanyController extends AbstractAPIController
{

    public function create()
    {
        $staff = StaffService::getStaffDetail($this->currentContext['UserId']);
        if ($staff['Company'] != null) {
            $result = array('success' => false, 'message' => '您已经在一个沙龙中了。');
            $this->sendResponse($result);
        }

        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['CompanyId'] = 0;
        if (isset($reqData['City']) && $reqData['City'] > 0) {
            $province = AreaService::findParentAreaByChild($reqData['City']);
            $reqData['Province'] = $province['AreaId'];
        } else {
            $reqData['Province'] = 0;
        }
        $reqData['District'] = 0;
        $reqData['Status'] = CompanyStatus::Requested;
        $reqData['CreatedBy'] = $this->currentContext['UserId'];

        $result = CompanyService::save($reqData);
        if ($result['success']) {
            StaffService::saveCompanyStaff($this->currentContext['UserId'], $result['company']['CompanyId'], StaffStatus::Requested);
        }
        $this->sendResponse($result);
    }

    public function join($companyId)
    {
        $result = array('success' => false, 'message' => '');
        $staff = StaffService::getStaffDetail($this->currentContext['UserId']);
        if ($staff && $staff['Company']) {
            if ($staff['Status'] == StaffStatus::Requested) {
                $result['message'] = '您的请求正在审核中，请耐心等待。';
            } else if ($staff['Status'] == StaffStatus::Invalid) {
                $saveRst = StaffService::saveCompanyStaff($this->currentContext['UserId'], $companyId, StaffStatus::Requested);
                if (!$saveRst) {
                    $result['message'] = '操作失败请重试。';
                } else {
                    $result['success'] = true;
                    $result['message'] = '您的请求正在审核中，请耐心等待。';
                }
            } else {
                $result['message'] = '您已经在一个沙龙中了。';
            }
        } else {
            $saveRst = StaffService::saveCompanyStaff($this->currentContext['UserId'], $companyId, StaffStatus::Requested);
            if (!$saveRst) {
                $result['message'] = '操作失败请重试。';
            } else {
                $result['success'] = true;
                $result['message'] = '您的请求正在审核中，请耐心等待。';
            }
        }

        $this->sendResponse($result);
    }

    public function listStaffs($companyId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));
        $isApproved = intval($this->app->request->get('isApproved'));

        $staffList = StaffService::listAllStaff($companyId, $isApproved ? StaffStatus::Valid : StaffStatus::Requested, $page, $pageSize);
        $this->sendResponse($staffList);
    }

    public function update($companyId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        $response = array('success' => false);

        $reqData['CompanyId'] = $companyId;

        $response = CompanyService::update($reqData);

        $this->sendResponse($response);
    }

    public function liked()
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $companyList = CompanyService::listLikedCompany($this->currentContext['UserId'], $this->currentContext['Location'], $page, $pageSize);
        $this->sendResponse($companyList);
    }

    public function nearby()
    {
        $maxDistance = intval($this->app->request->get('distance'));
        $maxDistance = $maxDistance > 0 ? $maxDistance : 100000;

        $companyList = CompanyService::nearby($maxDistance, $this->currentContext['Location']);
        $this->sendResponse($companyList);
    }

    public function search()
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $searchText = htmlspecialchars($this->app->request->get('searchText'));

        $city = intval($this->app->request->get('city'));
        $district = intval($this->app->request->get('district'));

        $sort = intval($this->app->request->get('sort'));

        $companyList = CompanyService::search($this->currentContext['UserId'], $searchText, $city, $district, $sort, $this->currentContext['Location'], $page, $pageSize);
        $this->sendResponse($companyList);
    }

    public function listComments($companyId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $result = CommentService::listComment($companyId, null, null, null, $page, $pageSize);
        $this->sendResponse($result);
    }

    public function addComment($companyId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['CompanyId'] = $companyId;

        $result = CommentService::save($reqData);
        $this->sendResponse($result);
    }

    public function addCompanyLike($companyId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['CompanyId'] = $companyId;

        $result = UserLikeService::save($reqData);
        $this->sendResponse($result);
    }

    public function getDetail($companyId)
    {
        $this->sendResponse(CompanyService::getCompanyDetail($companyId, $this->currentContext['UserId'], $this->currentContext['Location']));
    }

    public function changeStaffStatusByCompanyAndUser($companyId, $userId)
    {
        $result = array('success' => false, 'message' => '');

        $reqData = $this->getDataFromRequestWithJsonFormat();

        $staff = StaffService::getStaffByCompanyAndUser($companyId, $userId);
        if (!$staff) {
            $result['message'] = '发型师不存在！';
            $this->sendResponse($result);
        }

        if (isset($reqData['IsApproved'])) {
            $result['success'] = StaffService::saveCompanyStaffByCompanyUser($staff['CompanyUserId'], intval($reqData['IsApproved']) > 0 ? StaffStatus::Valid : StaffStatus::Invalid);
        }
        $result['message'] = $result['success'] ? '更新成功。' : '更新失败。';

        $this->sendResponse($result);
    }

    public function removeStaffByCompanyAndUser($companyId, $userId)
    {
        $result = array('success' => false, 'message' => '');

        $staff = StaffService::getStaffByCompanyAndUser($companyId, $userId);
        if (!$staff) {
            $result['message'] = '发型师不存在！';
            $this->sendResponse($result);
        }

        $result['success'] = StaffService::removeCompanyStaffByCompanyUser($staff['CompanyUserId']);
        $result['message'] = $result['success'] ? '操作成功。' : '操作失败。';

        $this->sendResponse($result);
    }

    public function listCompanyWithdraw()
    {
        $companyId = intval($this->app->request->get('companyId'));
        $balanceType = 3;
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $result = CompanyBalanceLogService::listBalanceLogByCompanyAndType($companyId, $balanceType,$page, $pageSize);
        $balance = CompanyService::getCompanyBalance($companyId);
        $result['balance'] = $balance;
        $this->sendResponse($result);
    }
}
