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

class UserPointRepository extends AbstractRepository
{

    public function getAllPointsByUserAndType($userId, $type)
    {
        $strSql = 'SELECT
                       *
                   FROM UserPoint UP
                   WHERE UP.UserId = ? AND UP.Type = ?';

        return $this->conn->fetchAll($strSql, array($userId, $type));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('UserPoint', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($userPointId, $data)
    {
        try {
            return $this->conn->update('UserPoint', $data, array('UserPointId' => $userPointId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
