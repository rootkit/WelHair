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

namespace Welfony\Service;

use Welfony\Core\Enum\DeviceType;
use Welfony\Core\Enum\NotificationType;
use Welfony\Notification\Apple;
use Welfony\Service\UserDeviceService;

class NotificationService
{

    public static function send($type, $userId)
    {
        $tokens = UserDeviceService::getUserDeviceToken($userId);
        foreach ($tokens as $token) {
            if ($token['Type'] == DeviceType::iOS) {
                Apple::send($token['DeviceToken'], self::getAppleNotificationContent($type, $userId));
            }

            if ($token['Type'] == DeviceType::Android) {

            }
        }
    }

    private static function getAppleNotificationContent($type, $userId)
    {
        $rst = array(
            'type' => $type,
            'alert' => ''
        );

        switch ($type) {
            case NotificationType::AppointmentNew:
                $rst['alert'] = '您有一个新预约';
                break;

            default:
                break;
        }

        return $rst;
    }

}
