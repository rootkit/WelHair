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

namespace Welfony\Notification;

class Apple
{

    private static $passphrase = '111111';

    public static function send($deviceToken, $notification)
    {
        $config = \Zend_Registry::get('config');
        $logger = \Zend_Registry::get('logger');

        $ctx = stream_context_create();
        stream_context_set_option($ctx, 'ssl', 'local_cert', $config->cert->path . DS . 'apple_notification.pem');
        stream_context_set_option($ctx, 'ssl', 'passphrase', self::$passphrase);

        $fp = stream_socket_client(
            'ssl://gateway.sandbox.push.apple.com:2195', $err,
            $errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx
        );

        if (!$fp) {
            $logger->log("Failed to connect: $err $errstr" . PHP_EOL, \Zend_Log::ERR);
            return false;
        }

        $notification['sound'] = 'default';

        $body = array(
            'aps' => $notification
        );
        $payload = json_encode($body);
        $msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

        $result = fwrite($fp, $msg, strlen($msg));

        fclose($fp);

        return $result;
    }

}