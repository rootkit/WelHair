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

class UserBalanceLogRepository extends AbstractRepository
{

    public function getAllUserBalanceLogCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM UserBalanceLog";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllUserBalanceLog()
    {
        $strSql = 'SELECT
                       *
                   FROM UserBalanceLog
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listUserBalanceLog($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM UserBalanceLog
                   ORDER BY UserBalanceLogId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findUserBalanceLogById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM UserBalanceLog
                   WHERE UserBalanceLogId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('UserBalanceLog', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($userBalanceLogId, $data)
    {
        try {
            $r= $this->conn->update('UserBalanceLog', $data, array('UserBalanceLogId' => $userBalanceLogId));

            return $r;
        } catch (\Exception $e) {

            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($userBalanceLogId)
    {
        try {
            return $this->conn->delete("UserBalanceLog",array('UserBalanceLogId' => $userBalanceLogId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }


}
