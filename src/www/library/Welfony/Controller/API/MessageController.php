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

use Welfony\Core\Enum\MessageStatus;
use Welfony\Controller\Base\AbstractAPIController;
use Welfony\Service\MessageService;

class MessageController extends AbstractAPIController
{

    public function listMessages($fromId, $toId)
    {
        $page = intval($this->app->request->get('page'));
        $pageSize = intval($this->app->request->get('pageSize'));

        $rst = MessageService::listMessages($fromId, $toId, $page, $pageSize);
        $this->sendResponse(!$rst ? array() : $rst);
    }

    public function listConversationsByUserId($userId)
    {
        $rst = MessageService::listConversationsByUser($userId);
        $this->sendResponse(array(
            'total' => count(!$rst ? array() : $rst),
            'conversations' => !$rst ? array() : $rst
        ));
    }

    public function create()
    {
        $message = $this->getDataFromRequestWithJsonFormat();

        if (isset($message['RoomId']) && intval($message['RoomId']) > 0) {
            $message['ToId'] = 0;
            $message['CreatedDate'] = date('Y-m-d H:i:s');
            $message['Status'] = MessageStatus::Sent;
            $rst = MessageService::save($message);
        } elseif (isset($message['ToId']) && intval($message['ToId']) > 0) {
            $message['RoomId'] = 0;
            $message['CreatedDate'] = date('Y-m-d H:i:s');
            $message['Status'] = MessageStatus::Sent;
            $rst = MessageService::save($message);
        }
        $this->sendResponse($rst);
    }

    public function updateConversation()
    {
        $messageConversation = $this->getDataFromRequestWithJsonFormat();
        $result['success'] = MessageService::updateConversation($messageConversation);
        $this->sendResponse($result);
    }

    public function removeConversationsById($conversationId)
    {
        $result = array('success' => false, 'message' => '');
        $result['success'] = MessageService::removeConversationsById($conversationId);
        $this->sendResponse($result);
    }

}
