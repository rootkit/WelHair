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
use Welfony\Service\CommentService;
use Welfony\Service\StaffService;
use Welfony\Service\WorkService;

class Hair_IndexController extends AbstractFrontendController
{

    public function indexAction()
    {
        $gender = intval($this->_request->getParam('gender'));
        $hairStyle = intval($this->_request->getParam('hair_style'));
        $sort = intval($this->_request->getParam('sort'));

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $searchResult = WorkService::search($this->currentUser['UserId'], $this->userContext->area['City']['AreaId'], $gender, $hairStyle, $sort, $page, $pageSize);
        $this->view->workList = $searchResult['works'];

        $this->view->params = array();
        if ($gender > 0) {
            $this->view->params['gender'] = $gender;
        }
        if ($hairStyle > 0) {
            $this->view->params['hair_style'] = $hairStyle;
        }
        if ($sort > 0) {
            $this->view->params['sort'] = $sort;
        }

        $this->view->pager = $this->renderPager($this->view->baseUrl('hair?' . http_build_query($this->view->params)),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function detailAction()
    {
        $workId = intval($this->_request->getParam('hair_id'));
        $this->view->workDetail = WorkService::getWorkDetail($this->currentUser['UserId'], $this->userContext->location, $workId);

        $rstComments = CommentService::listComment(0, $workId, 0, 0, 1, 20);
        $this->view->comments = $rstComments['comments'];
        $this->view->commentTotal = $rstComments['total'];

        $this->view->staffDetail = StaffService::getStaffDetail($this->view->workDetail['Staff']['UserId'], $this->currentUser['UserId'], $this->userContext->location);
    }

}