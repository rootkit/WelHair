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
use Welfony\Service\FeedbackService;

class FeedbackController extends AbstractAPIController
{

    public function create()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['FeedbackId'] = 0;
        $reqData['UserId'] = $this->currentContext['UserId'];

        $result = FeedbackService::save($reqData);
        $this->sendResponse($result);
    }

    public function remove($serviceId)
    {
        $result = array('success' => false, 'message' => '');
        $result['success'] = ServiceService::removeById($serviceId);
        $this->sendResponse($result);
    }

}
