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

use Welfony\Repository\MessageConversationRepository;
use Welfony\Repository\MessageRepository;
use Welfony\Repository\MessageOfflineRepository;

class MessageService
{

    public static function listMessages($fromId, $toId, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = MessageRepository::getInstance()->listMessagesCount($fromId, $toId);
        $messageList = MessageRepository::getInstance()->listMessages($fromId, $toId, $page, $pageSize);

        return array('total' => $total, 'messages' => $messageList);
    }

    public static function listConversationsByUser($userId)
    {
        return MessageConversationRepository::getInstance()->listByTo($userId);
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        $newId = MessageRepository::getInstance()->save($data);
        if ($newId) {
            $data['MessageId'] = $newId;

            $existedConversation = null;
            if ($data['RoomId'] <= 0) {
                $existedConversation = MessageConversationRepository::getInstance()->getByFromAndTo($data['FromId'], $data['ToId']);
            } else {

            }

            if (!$existedConversation) {
                $conversationData = array(
                    'FromId' => $data['FromId'],
                    'ToId' => $data['ToId'],
                    'RoomId' => $data['RoomId'],
                    'NewMessageCount' => 1,
                    'LastMessageId' => $newId
                );
                MessageConversationRepository::getInstance()->save($conversationData);
            } else {
                $existedConversation['NewMessageCount'] += 1;
                $existedConversation['LastMessageId'] = $newId;
                MessageConversationRepository::getInstance()->updateByFromAndTo($data['FromId'], $data['ToId'], $existedConversation);
            }

            $result['success'] = true;
            $result['message'] = $data;

            return $result;
        } else {
            $result['message'] = '添加消息失败！';

            return $result;
        }
    }

    public static function updateConversation($data)
    {
        $result = array('success' => false, 'message' => '');
        if (!isset($data['MessageConversationId']) || intval($data['MessageConversationId']) <= 0) {
            $result['message'] = '不合法的回话';

            return $result;
        }

        $result['success'] = MessageConversationRepository::getInstance()->update($data['MessageConversationId'], $data);

        return $result;
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

    public static function removeConversationsById($conversationId)
    {
        return MessageConversationRepository::getInstance()->remove($conversationId);
    }

}
