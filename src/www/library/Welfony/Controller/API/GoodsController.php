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
use Welfony\Service\GoodsService;
use Welfony\Service\UserLikeService;

class GoodsController extends AbstractAPIController
{

    public function listComments($goodsId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $result = CommentService::listComment(null, null, null, $goodsId, $page, $pageSize);
        $this->sendResponse($result);
    }

    public function addComment($goodsId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['GoodsId'] = $goodsId;

        $result = CommentService::save($reqData);
        $this->sendResponse($result);
    }

    public function addGoodsLike($goodsId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['GoodsId'] = $goodsId;

        $result = UserLikeService::save($reqData);
        $this->sendResponse($result);
    }

    public function detail($goodsId)
    {
        $companyId = intval($this->app->request->get('companyId'));
        $goods = GoodsService::getGoodsDetail($goodsId, $companyId, $this->currentContext['UserId'], $this->currentContext['Location']);
        $this->sendResponse($goods);
    }

    public function search()
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $searchText = htmlspecialchars($this->app->request->get('searchText'));

        $city = intval($this->app->request->get('city'));
        $district = intval($this->app->request->get('district'));

        $sort = intval($this->app->request->get('sort'));

        $companyList = GoodsService::search($this->currentContext['UserId'], $searchText, $city, $district, $sort, $this->currentContext['Location'], $page, $pageSize);
        $this->sendResponse($companyList);
    }

    public function liked()
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $goodsList = GoodsService::listLikedGoods($this->currentContext['UserId'], $page, $pageSize);
        $this->sendResponse($goodsList);
    }

    public function listByCompany($companyId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $goodsList = GoodsService::listByCompany($companyId, $page, $pageSize);
        $this->sendResponse($goodsList);
    }

}
