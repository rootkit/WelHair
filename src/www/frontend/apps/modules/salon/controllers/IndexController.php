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
use Welfony\Service\CompanyService;
use Welfony\Service\GoodsService;
use Welfony\Service\StaffService;

class Salon_IndexController extends AbstractFrontendController
{

    public function indexAction()
    {
        $this->view->pageTitle = '沙龙';

        $district = intval($this->_request->getParam('district'));
        $sort = intval($this->_request->getParam('sort'));

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $searchResult = CompanyService::search($this->currentUser['UserId'], '', $this->userContext->area['City']['AreaId'], $district, $sort, $this->userContext->location, $page, $pageSize);
        $this->view->companyList = $searchResult['companies'];

        $this->view->params = array();
        if ($district > 0) {
            $this->view->params['district'] = $district;
        }
        if ($sort > 0) {
            $this->view->params['sort'] = $sort;
        }

        $this->view->districtList = AreaService::listAreaByParent($this->userContext->area['City']['AreaId']);

        $this->view->pager = $this->renderPager($this->view->baseUrl('salon?' . http_build_query($this->view->params)),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function detailAction()
    {
        $companyId = intval($this->_request->getParam('salon_id'));
        $this->view->companyDetail = CompanyService::getCompanyDetail($companyId, $this->currentUser['UserId'], $this->userContext->location);

        $this->view->pageTitle = $this->view->companyDetail['CompanyName'];

        $rstStaffList = StaffService::search($this->currentUser['UserId'], '', $companyId, 0, 0, 0, $this->userContext->location, 1, 1000);
        $this->view->staffList = $rstStaffList['staffs'];

        $rstGoodsList = GoodsService::listByCompany($companyId, 1, 1000);
        $this->view->goodsList = $rstGoodsList['goods'];

        $rstComments = CommentService::listComment($companyId, 0, 0, 0, 1, 20);
        $this->view->comments = $rstComments['comments'];
        $this->view->commentTotal = $rstComments['total'];
    }

}