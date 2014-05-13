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

    public static function add($userId, $deviceToken)
    {
        $result = array('success' => false, 'message' => '');

        if (!$userId || !$deviceToken) {
            $result['message'] = '不合法用户或设备号';
            return $result;
        }
        if(UserDeviceRepository::getInstance()->exists($userId, $deviceToken)){
            $result['success'] = false;
            $result['message'] = '用户设备已存在';
        }else{
            $result['success'] =  UserDeviceRepository::getInstance()->add($userId, $deviceToken);    
        }
        return $result;
    }

    public static function remove($userId, $deviceToken)
    {
        $result = array('success' => false, 'message' => '');

        if (!$userId || !$deviceToken) {
            $result['message'] = '不合法用户或设备号';
            return $result;
        }
        $result['success'] =  UserDeviceRepository::getInstance()->remove($userId, $deviceToken);
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
