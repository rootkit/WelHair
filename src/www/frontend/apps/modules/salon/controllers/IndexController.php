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
use Welfony\Service\CompanyService;

class Salon_IndexController extends AbstractFrontendController
{

    public function indexAction()
    {
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
    }

}