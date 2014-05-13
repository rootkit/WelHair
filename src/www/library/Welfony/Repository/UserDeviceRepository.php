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

    public function add($userId, $deviceToken)
    {
        try {
            return $this->conn->insert('UserDevice', array('UserId' => $userId, 'DeviceToken' =>$deviceToken));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);
            return false;
        }
    }

    public function remove($userId, $deviceToken)
    {
       try {
           return $this->conn->delete('UserDevice', array('UserId' => $userId, 'DeviceToken' => $deviceToken));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);
            return false;
        }
    }

     public function exists($userId, $deviceToken)
    {
        $strSql = 'SELECT
                       count(*) as count
                   FROM UserDevice 
                   WHERE UserId = ? and DeviceToken = ?';

        $result = $this->conn->fetchAssoc($strSql, array($userId, $deviceToken));
        return $result['count'] > 0;
    }

     public function getUserDeviceToken($userId)
    {
        $strSql = 'SELECT DeviceToken  FROM UserDevice  WHERE UserId = ?';

        $result = $this->conn->fetchAssoc($strSql, array($userId));
        return $result;
    }
}
