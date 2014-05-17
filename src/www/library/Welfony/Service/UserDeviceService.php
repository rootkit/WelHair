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

use Welfony\Repository\UserDeviceRepository;

class UserDeviceService
{

    public static function add($userId, $type, $deviceToken)
    {
        $result = array('success' => false, 'message' => '');

        if (!$deviceToken) {
            $result['message'] = '不合法设备号';

            return $result;
        }

        if ($userId > 0 && !UserDeviceRepository::getInstance()->exists($userId, $type, $deviceToken)) {
            $result['success'] = UserDeviceRepository::getInstance()->add($userId, $type, $deviceToken) > 0;
        } else {
            $result['success'] = true;
        }

        return $result;
    }

    public static function remove($userId, $type, $deviceToken)
    {
        $result = array('success' => false, 'message' => '');

        if (!$deviceToken) {
            $result['message'] = '不合法设备号';

            return $result;
        }
        $result['success'] = $userId <= 0 ? true : UserDeviceRepository::getInstance()->remove($userId, $type, $deviceToken);

        return $result;
    }

    public static function getUserDeviceToken($userId)
    {
        $result = array();
        if ($userId ) {
            $result = UserDeviceRepository::getInstance()->getUserDeviceToken($userId);
        }

        return $result;
    }
}
