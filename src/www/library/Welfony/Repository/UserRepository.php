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

class UserRepository extends AbstractRepository
{

    public function getAllUsersCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Users
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Users', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);
            return false;
        }

        return false;
    }

    public function update($userId, $data)
    {
        try {
            return $this->conn->update('Users', $data, array('UserId' => $userId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);
            return false;
        }
    }

}