
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
use Welfony\Service\UserLikeService;

class Ajax_HairController extends AbstractFrontendController
{

    public function likeAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $userLike = array(
            'CreatedBy' => $this->currentUser['UserId'],
            'WorkId' => intval($this->_request->getParam('work_id')),
            'IsLike' => intval($this->_request->getParam('is_like'))
        );

        $this->_helper->json->sendJson(UserLikeService::save($userLike));
    }

}
