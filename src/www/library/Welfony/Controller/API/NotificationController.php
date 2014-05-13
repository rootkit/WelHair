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

use Welfony\Service\UserDeviceService;
use Welfony\Controller\Base\AbstractAPIController;
use welfony\Notification\Apple;


class NotificationController extends AbstractAPIController
{

    public function registerDeivceToken()
    {
        $data = $this->getDataFromRequestWithJsonFormat();
        $token = $data['deviceToken'];
        $userId = $this->currentContext['UserId'];
        $rst = UserDeviceService::add($userId, $token);
        $this->sendResponse(!$rst ? array() : $rst);
    }

    public function removeDeivceToken()
    {
        $data = $this->getDataFromRequestWithJsonFormat();
        $token = $data['deviceToken'];
        $userId = $data['userId'];
        $rst = UserDeviceService::remove($userId, $token);
        $this->sendResponse(!$rst ? array() : $rst);
    }

    public function pushNotification($userId, $type, $content)
    {
        $userTokens = UserDeviceService::getUserDeviceToken($userId);
        foreach ($userTokens as $token) {
            Apple::send($token, array( 'type' => NotificationType::NotificationTypeStaffGetAppointment . '', 'alert' => '使用打扮吧'));     
        }
    }
}
