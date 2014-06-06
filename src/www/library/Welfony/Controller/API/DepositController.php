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
use Welfony\Service\DepositService;

class DepositController extends AbstractAPIController
{

    public function listByUser($userId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));
        $dataList = DepositService::listDeposit($page, $pageSize, $this->currentContext['UserId'] != $userId ? 0 : $userId);
        $this->sendResponse($dataList);
    }

    public function create($userId)
    {
        $response = array('success' => false);

        if ($userId <=0 || $this->currentContext['UserId'] != $userId) {
            $response['message'] = '不合法的用户信息！';
            $this->sendResponse($response);
        }

        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['DepositId'] = 0;
        $reqData['UserId'] = $this->currentContext['UserId'];

        $response = DepositService::save($reqData);
        $this->sendResponse($response);
    }

}
