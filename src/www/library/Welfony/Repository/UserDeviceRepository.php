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

namespace Welfony\Repository;

use Welfony\Repository\Base\AbstractRepository;

class UserDeviceRepository extends AbstractRepository
{

    public function add($userId, $type, $deviceToken)
    {
        try {
            if ($this->conn->insert('UserDevice', array('UserId' => $userId, 'Type' => $type, 'DeviceToken' => $deviceToken))) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);
        }

        return false;
    }

    public function remove($userId, $type, $deviceToken)
    {
        try {
            return $this->conn->delete('UserDevice', array('UserId' => $userId, 'Type' => $type, 'DeviceToken' => $deviceToken));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);
            return false;
        }
    }

    public function exists($userId, $type, $deviceToken)
    {
        $strSql = 'SELECT
                       COUNT(1) `Total`
                   FROM UserDevice UD
                   WHERE UD.UserId = ? AND UD.Type = ? and UD.DeviceToken = ?';

        $result = $this->conn->fetchAssoc($strSql, array($userId, $type, $deviceToken));

        return $result['Total'] > 0;
    }

    public function getUserDeviceToken($userId)
    {
        $strSql = 'SELECT UD.*
                   FROM UserDevice UD
                   WHERE UD.UserId = ?';

        $result = $this->conn->fetchAll($strSql, array($userId));

        return $result;
    }
}
