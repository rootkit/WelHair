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
use Welfony\Service\WorkService;

class Hair_IndexController extends AbstractFrontendController
{

    public function indexAction()
    {
    }

    public function detailAction()
    {
        $workId = intval($this->_request->getParam('hair_id'));
        $this->view->workDetail = WorkService::getWorkDetail($this->currentUser['UserId'], array('Latitude' => 0, 'Longitude' => 0), $workId);

        $rstComments = CommentService::listComment(0, $workId, 0, 0, 1, 20);
        $this->view->comments = $rstComments['comments'];
        $this->view->commentTotal = $rstComments['total'];

        // var_dump($this->view->comments);die();
    }

}