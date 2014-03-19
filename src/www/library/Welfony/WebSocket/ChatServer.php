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

namespace Welfony\WebSocket;

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;

use Welfony\Core\Enum\MessageMediaType;
use Welfony\Core\Enum\MessageStatus;
use Welfony\Core\Enum\MessageType;
use Welfony\Service\MessageService;
use Welfony\Service\RoomService;
use Welfony\Service\UserService;

class ChatServer implements MessageComponentInterface
{

    protected $clients;

    public function __construct()
    {
        $this->clients = array();
    }

    public function onOpen(ConnectionInterface $conn)
    {
        $this->clients[$conn->resourceId] = array(
            'Connection' => $conn,
            'User' => array('UserId' => 0)
        );
        echo "New connection! ({$conn->resourceId})\n";
    }

    public function onMessage(ConnectionInterface $conn, $msg)
    {
        $message = json_decode($msg, true);
        if($message === null) {
            return;
        }

        if ($message['Type'] == MessageType::UserConnected) {
            if (isset($message['UserId']) && intval($message['UserId']) > 0) {
                $this->clients[$conn->resourceId]['User'] = array(
                    'UserId' => $message['UserId']
                );

                $offlineMessages = MessageService::getAllOfflineMessages($message['UserId']);
                foreach($offlineMessages as $msg) {
                    $messageOfflineId = $msg['MessageOfflineId'];
                    unset($msg['MessageOfflineId']);
                    $this->clients[$conn->resourceId]['Connection']->send(json_encode($msg));

                    MessageService::removeOfflineMessage($messageOfflineId);
                }
            }
        }

        if ($message['Type'] == MessageType::NewMessage) {
            if (isset($message['RoomId']) && intval($message['RoomId']) > 0) {
                $message['ToId'] = 0;
                $message['CreatedDate'] = date('Y-m-d H:i:s');
                $message['Status'] = MessageStatus::Sent;
                $rst = MessageService::save($message);

                $usersInRoom = RoomService::listAllUsersByRoom($message['RoomId']);
                foreach($usersInRoom as $toUser) {
                    if ($toUser['UserId'] != $message['FromId']) {
                        $toClient = null;
                        foreach ($this->clients as $client) {
                            if ($client['User']['UserId'] == $toUser['UserId']) {
                                $toClient = $client;
                            }
                        }

                        if ($toClient) {
                            $toClient['Connection']->send(json_encode($rst['message']));
                        } else {
                            MessageService::saveOfflineMessage(array('MessageId' => $rst['message']['MessageId'], 'UserId' => $toUser['UserId']));
                        }
                    }
                }

            } elseif (isset($message['ToId']) && intval($message['ToId']) > 0) {
                $message['RoomId'] = 0;
                $message['CreatedDate'] = date('Y-m-d H:i:s');
                $message['Status'] = MessageStatus::Sent;
                $rst = MessageService::save($message);

                $toClient = null;
                foreach ($this->clients as $client) {
                    if ($client['User']['UserId'] == $message['ToId']) {
                        $toClient = $client;
                    }
                }

                if ($toClient) {
                    $toClient['Connection']->send(json_encode($rst['message']));
                } else {
                    if ($rst['success']) {
                        MessageService::saveOfflineMessage(array('MessageId' => $rst['message']['MessageId'], 'UserId' => $message['ToId']));
                    }
                }
            }

        }
    }

    public function onClose(ConnectionInterface $conn)
    {
        echo "User {$this->clients[$conn->resourceId]['User']['UserId']} has disconnected\n";
        unset($this->clients[$conn->resourceId]);
    }

    public function onError(ConnectionInterface $conn, \Exception $e)
    {
        echo "An error has occurred: {$e->getMessage()}\n";
        $conn->close();
    }
}