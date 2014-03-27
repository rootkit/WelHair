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

    public function search()
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $area = intval($this->app->request->get('area'));
        $gender = intval($this->app->request->get('gender'));
        $hairStyle = intval($this->app->request->get('hair-style'));

        $sort = intval($this->app->request->get('sort'));

        $workList = WorkService::search($area, $gender, $hairStyle, $sort, $page, $pageSize);
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

}
