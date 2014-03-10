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

class RosterRepository extends AbstractRepository
{

    public function getAllRostersByToId($toId, $status)
    {
        $strSql = 'SELECT
                       R.RosterId,

                       U.UserId,
                       U.Username,
                       U.Nickname,
                       U.AvatarUrl,
                       U.Role
                   FROM Roster R
                   INNER JOIN Users U ON U.UserId = R.FromId
                   WHERE R.ToId = ? AND R.Status = ?';

        return $this->conn->fetchAll($strSql, array($toId, $status));
    }

    public function findRosterById($rosterId)
    {
        $strSql = 'SELECT
                       *
                   FROM Roster R
                   WHERE R.RosterId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($rosterId));
    }

    public function findRosterByFromAndTo($from, $to)
    {
        $strSql = 'SELECT
                       *
                   FROM Roster R
                   WHERE R.FromId = ? AND R.ToId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($from, $to));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Roster', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($rosterId, $data)
    {
        try {
            return $this->conn->update('Roster', $data, array('RosterId' => $rosterId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
