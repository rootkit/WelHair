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

class RoomRepository extends AbstractRepository
{

    public function getAllUsersByRoomId($roomId)
    {
        $strSql = 'SELECT
                       R.RoomId,

                       U.UserId,
                       U.Username,
                       U.Nickname,
                       U.AvatarUrl,
                       U.Role
                   FROM Room R
                   INNER JOIN RoomUser RU ON RU.RoomId = R.RoomId
                   INNER JOIN Users U ON U.UserId = RU.UserId
                   WHERE R.RoomId = ?';

        return $this->conn->fetchAll($strSql, array($roomId));
    }

    public function getAllRoomsByUser($userId)
    {
        $strSql = 'SELECT
                       R.RoomId,
                       GROUP_CONCAT(U.Nickname) Name
                   FROM Users U
                   INNER JOIN RoomUser RU ON U.UserId = RU.UserId
                   INNER JOIN Room R ON R.RoomId = RU.RoomId
                   WHERE R.RoomId IN (SELECT RUI.RoomId FROM RoomUser RUI WHERE RUI.UserId = ?)
                   GROUP BY R.RoomId';

        return $this->conn->fetchAll($strSql, array($userId));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Room', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($roomId, $data)
    {
        try {
            return $this->conn->update('Room', $data, array('RoomId' => $roomId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
