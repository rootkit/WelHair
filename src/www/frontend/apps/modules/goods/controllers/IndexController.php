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
use Welfony\Service\AreaService;
use Welfony\Service\CommentService;
use Welfony\Service\GoodsService;

class Goods_IndexController extends AbstractFrontendController
{

    public function indexAction()
    {
        $this->view->pageTitle = '商城';

        $district = intval($this->_request->getParam('district'));
        $sort = intval($this->_request->getParam('sort'));

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $searchResult = GoodsService::search($this->currentUser['UserId'], '', $this->userContext->area['City']['AreaId'], $district, $sort, $this->userContext->location, $page, $pageSize);
        $this->view->goodsList = $searchResult['goods'];

        $this->view->params = array();
        if ($district > 0) {
            $this->view->params['district'] = $district;
        }
        if ($sort > 0) {
            $this->view->params['sort'] = $sort;
        }

        $this->view->districtList = AreaService::listAreaByParent($this->userContext->area['City']['AreaId']);

        $this->view->pager = $this->renderPager($this->view->baseUrl('goods?' . http_build_query($this->view->params)),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function contentAction()
    {
        $this->_helper->layout->disableLayout();

        $goodsId = intval($this->_request->getParam('goods_id'));
        if ($goodsId > 0) {
            $goods = GoodsService::getGoodsById($goodsId);
            $this->view->htmlContent = $goods['Content'];
        }
    }

    public function detailAction()
    {
        $goodsId = intval($this->_request->getParam('goods_id'));
        $companyId = intval($this->_request->getParam('company_id'));
        $this->view->goodsDetail = GoodsService::getGoodsDetail($goodsId, $companyId, $this->currentUser['UserId'], $this->userContext->location);

        $this->view->pageTitle = $this->view->goodsDetail['Name'];

        $rstComments = CommentService::listComment(0, 0, 0, $goodsId, 1, 20);
        $this->view->comments = $rstComments['comments'];
        $this->view->commentTotal = $rstComments['total'];
    }

}