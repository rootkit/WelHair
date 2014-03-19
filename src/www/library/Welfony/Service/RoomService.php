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

use Welfony\Repository\RoomRepository;
use Welfony\Repository\RoomUserRepository;

class RoomService
{

    public static function listAllRoomsByUser($userId)
    {
        return RoomRepository::getInstance()->getAllRoomsByUser($userId);
    }

    public static function listAllUsersByRoom($roomId)
    {
        return RoomRepository::getInstance()->getAllUsersByRoomId($roomId);
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (!isset($data['Users']) || count($data['Users']) <= 0) {
            $result['message'] = '至少需要一个用户！';

            return $result;
        }

        if (!isset($data['CreatedBy']) || intval($data['CreatedBy']) <= 0) {
            $result['message'] = '缺少创建人！';

            return $result;
        }

        $roomData = array(
            'CreatedBy' => $data['CreatedBy'],
            'CreatedDate' => date('Y-m-d H:i:s')
        );

        $newId = RoomRepository::getInstance()->save($roomData);
        if ($newId) {
            $roomData['RoomId'] = $newId;

            foreach ($data['Users'] as $userId) {
                $existedRoomUser = RoomUserRepository::getInstance()->findRoomUserByRoomAndUser($roomData['RoomId'], $userId);
                if (!$existedRoomUser) {
                    $roomUserData = array(
                        'RoomId' => $roomData['RoomId'],
                        'UserId' => $userId
                    );
                    RoomUserRepository::getInstance()->save($roomUserData);
                }
            }

            $result['success'] = true;
            $result['room'] = $data;

            return $result;
        } else {
            $result['message'] = '添加消息组失败！';

            return $result;
        }
    }

}
