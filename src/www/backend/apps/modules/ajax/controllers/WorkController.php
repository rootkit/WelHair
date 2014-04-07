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
use Welfony\Service\WorkService;

class Ajax_WorkController extends AbstractAdminController
{

    public function batchAction()
    {
        $action = htmlspecialchars($this->_request->getParam('act'));
        $ids = htmlspecialchars($this->_request->getParam('ids'));
        $idList = explode(',', $ids);

        $result = array('success' => true, 'message' => '');
        switch($action) {
            case 'remove': {
                foreach ($idList as $id) {
                    WorkService::removeById($id);
                }
                break;
            }
            default: {
                break;
            }
        }

        $this->_helper->json->sendJson($result);
    }

}
