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

use Welfony\Controller\Base\AbstractAdminController;
use Welfony\Service\AreaService;

class Ajax_AreaController extends AbstractAdminController
{

    public function listAction()
    {
        $parentId = intval($this->_request->getParam('pid'));
        $this->_helper->json->sendJson(AreaService::listAreaByParent($parentId));
    }

}
