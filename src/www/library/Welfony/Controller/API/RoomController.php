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

namespace Welfony\Controller\API;

use Welfony\Controller\Base\AbstractAPIController;
use Welfony\Service\RoomService;

class RoomController extends AbstractAPIController
{

    public function addNewRoom()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        $response = RoomService::save($reqData);
        $this->sendResponse($response);
    }

    public function listAllRoomsByUserId($userId)
    {
        $this->sendResponse(RoomService::listAllRoomsByUser($userId));
    }

}
