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
use Welfony\Service\StaffService;

class Ajax_StaffController extends AbstractAdminController
{

    public function searchAction()
    {
        $searchText = htmlspecialchars($this->_request->getParam('search'));
        $includeClient = intval($this->_request->getParam('include_client'));
        $response = array();

        $userList = StaffService::seachByNameAndPhone($searchText, $includeClient);
        foreach ($userList as $user) {
            $response[] = array(
                'value' => $user['UserId'],
                'title' => $user['Nickname'],
                'detail' => $user['Username'],
                'icon' => $user['AvatarUrl'],
                'company' => $user['Company'],
                'services' => $user['Services']
            );
        }
        $this->_helper->json->sendJson($response);
    }

}
