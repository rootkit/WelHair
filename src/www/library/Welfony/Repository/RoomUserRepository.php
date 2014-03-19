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

class RoomUserRepository extends AbstractRepository
{

    public function findRoomUserByRoomAndUser($roomId, $userId)
    {
        $strSql = 'SELECT
                       *
                   FROM RoomUser RU
                   WHERE RU.RoomId = ? AND RU.UserId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($roomId, $userId));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('RoomUser', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($roomId, $userId, $data)
    {
        try {
            return $this->conn->update('RoomUser', $data, array('RoomId' => $roomId, 'UserId' => $userId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
