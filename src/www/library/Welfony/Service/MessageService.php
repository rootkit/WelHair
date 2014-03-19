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

use Welfony\Repository\MessageRepository;
use Welfony\Repository\MessageOfflineRepository;

class MessageService
{

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        $newId = MessageRepository::getInstance()->save($data);
        if ($newId) {
            $data['MessageId'] = $newId;

            $result['success'] = true;
            $result['message'] = $data;

            return $result;
        } else {
            $result['message'] = '添加消息失败！';

            return $result;
        }
    }

    public static function saveOfflineMessage($data)
    {
        $result = array('success' => false, 'message' => '');

        $newId = MessageOfflineRepository::getInstance()->save($data);
        if ($newId) {
            $data['MessageOfflineId'] = $newId;

            $result['success'] = true;
            $result['message'] = $data;

            return $result;
        } else {
            $result['message'] = '添加离线消息失败！';

            return $result;
        }
    }

    public static function removeOfflineMessage($messageOfflineId)
    {
        MessageOfflineRepository::getInstance()->remove($messageOfflineId);
    }

    public static function getAllOfflineMessages($userId)
    {
        return MessageOfflineRepository::getInstance()->getAllOfflineMessagesByUser($userId);
    }

}
