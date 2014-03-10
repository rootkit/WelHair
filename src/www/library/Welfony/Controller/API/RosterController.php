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
use Welfony\Core\Enum\RosterStatus;
use Welfony\Service\RosterService;

class RosterController extends AbstractAPIController
{

    public function listAllRostersByUserId($userId)
    {
        $status = intval($this->app->request->get('status'));
        $status = $status > 0 ? $status : RosterStatus::Accepted;

        $this->sendResponse(RosterService::listAllRostersByUserId($userId, $status));
    }

    public function add()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        $response = array('success' => false);

        if (!isset($reqData['From']) || !isset($reqData['To'])) {
            $error = '信息不完善！';
        }

        if (!empty($error)) {
            $response['message'] = $error;
        } else {
            $from = intval($reqData['From']);
            $to = intval($reqData['To']);

            $data = array(
                'FromId' => $from,
                'ToId' => $to,
                'Status' => RosterStatus::Request,
                'CreatedDate' => date('Y-m-d H:i:s')
            );

            $response = RosterService::save($data);
        }

        $this->sendResponse($response);
    }

    public function update($rosterId)
    {
        $response = array('success' => false);

        $existedRoster = RosterService::getRosterById($rosterId);
        if (!$existedRoster) {
            $response['message'] = '信息不完善！';
            $this->sendResponse($response);
        }

        $reqData = $this->getDataFromRequestWithJsonFormat();
        if (isset($reqData['Status'])) {
            $existedRoster['Status'] = intval($reqData['Status']);
            $response = RosterService::save($existedRoster);
        }

        $this->sendResponse($response);
    }

}
