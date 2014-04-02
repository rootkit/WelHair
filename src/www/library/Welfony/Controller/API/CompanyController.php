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
use Welfony\Service\CompanyService;
use Welfony\Service\UserLikeService;

class CompanyController extends AbstractAPIController
{

    public function search()
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $city = intval($this->app->request->get('city'));
        $district = intval($this->app->request->get('district'));

        $sort = intval($this->app->request->get('sort'));

        $companyList = CompanyService::search($this->currentContext['UserId'], $city, $district, $sort, $this->currentContext['Location'], $page, $pageSize);
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

}
