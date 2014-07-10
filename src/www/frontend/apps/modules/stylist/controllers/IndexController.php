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
use Welfony\Service\StaffService;

class Stylist_IndexController extends AbstractFrontendController
{

    public function indexAction()
    {
        $this->view->pageTitle = '发型师';

        $district = intval($this->_request->getParam('district'));
        $sort = intval($this->_request->getParam('sort'));

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $searchResult = StaffService::search($this->currentUser['UserId'], '', 0, $this->userContext->area['City']['AreaId'], $district, $sort, $this->userContext->location, $page, $pageSize);
        $this->view->staffList = $searchResult['staffs'];

        $this->view->params = array();
        if ($district > 0) {
            $this->view->params['district'] = $district;
        }
        if ($sort > 0) {
            $this->view->params['sort'] = $sort;
        }

        $this->view->districtList = AreaService::listAreaByParent($this->userContext->area['City']['AreaId']);

        $this->view->pager = $this->renderPager($this->view->baseUrl('stylist?' . http_build_query($this->view->params)),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function detailAction()
    {
        $staffId = intval($this->_request->getParam('stylist_id'));
        $this->view->staffDetail = StaffService::getStaffDetail($staffId, $this->currentUser['UserId'], $this->userContext->location);

        $this->view->pageTitle = $this->view->staffDetail['Nickname'];
    }

}