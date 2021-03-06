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
use Welfony\Service\CommentService;
use Welfony\Service\ServiceService;
use Welfony\Service\StaffService;
use Welfony\Service\UserLikeService;
use Welfony\Service\WorkService;

class StaffController extends AbstractAPIController
{

    public function liked()
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $staffList = StaffService::listLikedStaff($this->currentContext['UserId'], $this->currentContext['Location'], $page, $pageSize);
        $this->sendResponse($staffList);
    }

    public function search()
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $searchText = htmlspecialchars($this->app->request->get('searchText'));

        $companyId = intval($this->app->request->get('companyId'));

        $city = intval($this->app->request->get('city'));
        $district = intval($this->app->request->get('district'));

        $sort = intval($this->app->request->get('sort'));

        $staffList = StaffService::search($this->currentContext['UserId'], $searchText, $companyId, $city, $district, $sort, $this->currentContext['Location'], $page, $pageSize);
        $this->sendResponse($staffList);
    }

    public function detail($staffId)
    {
        $this->sendResponse(StaffService::getStaffDetail($staffId, $this->currentContext['UserId'], $this->currentContext['Location']));
    }

    public function listClients($staffId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $clientList = StaffService::listAllClients($page, $pageSize, $staffId);
        $this->sendResponse($clientList);
    }

    public function listMyStaffs()
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $staffList = StaffService::listMyStaffs($page, $pageSize, $this->currentContext['UserId']);
        $this->sendResponse($staffList);
    }


    public function listWorks($userId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $workList = WorkService::listAllWorks($page, $pageSize, $userId);
        $this->sendResponse($workList);
    }

    public function listServices($userId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $serviceList = ServiceService::listAllServices($page, $pageSize, $userId);
        $this->sendResponse($serviceList);
    }

    public function listComments($staffId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $result = CommentService::listComment(null, null, $staffId, null, $page, $pageSize);
        $this->sendResponse($result);
    }

    public function addComment($staffId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['UserId'] = $staffId;

        $result = CommentService::save($reqData);
        $this->sendResponse($result);
    }

    public function addStaffLike($staffId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['UserId'] = $staffId;

        $result = UserLikeService::save($reqData);
        $this->sendResponse($result);
    }

}
