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

use Welfony\Core\Enum\MessageType;
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
            $this->clients[$conn->resourceId]['User'] = array(
                'UserId' => $message['From']
            );

            // Check offline message;
        }

        if ($message['Type'] == MessageType::NewMessage) {
            $toClient = null;
            foreach ($this->clients as $client) {
                if ($client['User']['UserId'] == $message['To']) {
                    $toClient = $client;
                }
            }

            if ($toClient) {
                $toClient['Connection']->send($msg);
            } else {
                // Insert offline message;
            }

            // Insert message history;
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