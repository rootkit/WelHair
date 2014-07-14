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
use Welfony\Service\CompanyService;
use Welfony\Service\GoodsService;
use Welfony\Service\StaffService;
use Welfony\Service\WorkService;

class User_FavoriteController extends AbstractFrontendController
{

    public function init()
    {
        $this->needloginActionList['user'] = array('favorite' => array('index'));

        parent::init();
    }

    public function indexAction()
    {
        $this->view->pageTitle = '我的收藏';
        $this->view->filter = htmlspecialchars($this->_request->getParam('filter'));

        $this->view->params = array();
        if (!empty($this->view->filter)) {
            $this->view->params['filter'] = $this->view->filter;
        }

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $rstList = array('total' => 0);

        switch ($this->view->filter) {
            case 'salon': {
                $rstList = CompanyService::listLikedCompany($this->currentUser['UserId'], $this->userContext->location, $page, $pageSize);
                $this->view->dataList = $rstList['companies'];
                break;
            }
            case 'stylist': {
                $rstList = StaffService::listLikedStaff($this->currentUser['UserId'], $this->userContext->location, $page, $pageSize);
                $this->view->dataList = $rstList['staffs'];
                break;
            }
            case 'goods': {
                $rstList = GoodsService::listLikedGoods($this->currentUser['UserId'], $page, $pageSize);
                $this->view->dataList = $rstList['goods'];
                break;
            }
            default: {
                $rstList = WorkService::listLikedWork($this->currentUser['UserId'], $page, $pageSize);
                $this->view->dataList = $rstList['works'];
                break;
            }
        }

        $this->view->pager = $this->renderPager($this->view->baseUrl('user/favorite?' . http_build_query($this->view->params)),
                                                $page,
                                                ceil($rstList['total'] / $pageSize));
    }

}