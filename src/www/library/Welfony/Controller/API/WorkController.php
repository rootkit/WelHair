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
use Welfony\Service\UserLikeService;
use Welfony\Service\WorkService;

class WorkController extends AbstractAPIController
{

    public function create()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['WorkId'] = 0;
        $reqData['UserId'] = $this->currentContext['UserId'];

        $result = WorkService::save($reqData);
        $this->sendResponse($result);
    }

    public function getDetail($workId)
    {
        $workDetail = WorkService::getWorkDetail($this->currentContext['UserId'], $this->currentContext['Location'], $workId);
        $this->sendResponse($workDetail);
    }

    public function liked()
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $workList = WorkService::listLikedWork($this->currentContext['UserId'], $page, $pageSize);
        $this->sendResponse($workList);
    }

    public function search()
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $city = intval($this->app->request->get('city'));
        $gender = intval($this->app->request->get('gender'));
        $hairStyle = intval($this->app->request->get('hairStyle'));

        $sort = intval($this->app->request->get('sort'));

        $workList = WorkService::search($this->currentContext['UserId'], $city, $gender, $hairStyle, $sort, $page, $pageSize);
        $this->sendResponse($workList);
    }

    public function listComments($workId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $result = CommentService::listComment(null, $workId, null, null, $page, $pageSize);
        $this->sendResponse($result);
    }

    public function addComment($workId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['WorkId'] = $workId;

        $result = CommentService::save($reqData);
        $this->sendResponse($result);
    }

    public function addWorkLike($workId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['WorkId'] = $workId;

        $result = UserLikeService::save($reqData);
        $this->sendResponse($result);
    }

    public function remove($workId)
    {
        $result = array('success' => false, 'message' => '');
        $result['success'] = WorkService::removeById($workId);
        $this->sendResponse($result);
    }

}
