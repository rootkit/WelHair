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
use Welfony\Service\OrderService;

class OrderController extends AbstractAPIController
{

    public function create()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['OrderId'] = 0;

        $result = OrderService::save($reqData);
        $this->sendResponse($result);
    }

}
