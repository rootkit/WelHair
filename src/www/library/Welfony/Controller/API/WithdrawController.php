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
use Welfony\Service\WithdrawalService;

class WithdrawController extends AbstractAPIController
{

    public function listHistoryByCompany($companyId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $result = WithdrawalService::listCompanyWithdrawal($page, $pageSize, $companyId);
        $this->sendResponse($result);
    }

    public function create($companyId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['WithdrawalId'] = 0;
        $reqData['CompanyId'] = $companyId;
        $reqData['Status'] = 0;

        $result = WithdrawalService::save($reqData);
        $this->sendResponse($result);
    }

}