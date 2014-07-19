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

class Ajax_CommentController extends AbstractFrontendController
{

    public function createAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $reqData = array();
        $reqData['WorkId'] = intval($this->_request->getParam('hair_id'));
        $reqData['CompanyId'] = intval($this->_request->getParam('salon_id'));
        $reqData['StaffId'] = intval($this->_request->getParam('stylist_id'));
        $reqData['GoodsId'] = intval($this->_request->getParam('goods_id'));
        $reqData['Rate'] = intval($this->_request->getParam('rate'));
        $reqData['Body'] = htmlspecialchars($this->_request->getParam('body'));
        $reqData['CreatedBy'] = $this->currentUser['UserId'];

        if (json_decode($this->_request->getParam('picture_url'), true)) {
            $reqData['PictureUrl'] = json_decode($this->_request->getParam('picture_url'), true);
        }

        $this->_helper->json->sendJson(CommentService::save($reqData));
    }

    public function formAction()
    {
        $this->_helper->layout->disableLayout();

        $ajaxContext = $this->_helper->getHelper('AjaxContext');
        $ajaxContext->addActionContext('form', 'html')
            ->initContext();
    }

    public function listAction()
    {
        $this->_helper->layout->disableLayout();

        $workId = intval($this->_request->getParam('hair_id'));
        $companyId = intval($this->_request->getParam('salon_id'));
        $staffId = intval($this->_request->getParam('stylist_id'));
        $goodsId = intval($this->_request->getParam('goods_id'));

        $page = intval($this->_request->getParam('page'));
        $pageSize = 10;

        $rstComments = CommentService::listComment($companyId, $workId, $staffId, $goodsId, $page, $pageSize);
        $this->view->comments = $rstComments['comments'];

        $this->view->pager = $this->renderPager('', $page, ceil($rstComments['total'] / $pageSize), 'refreshComment');

        $ajaxContext = $this->_helper->getHelper('AjaxContext');
        $ajaxContext->addActionContext('list', 'html')
            ->initContext();
    }

}
