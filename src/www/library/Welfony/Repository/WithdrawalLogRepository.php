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

class WithdrawalLogRepository extends AbstractRepository
{


    public function getAllWithdrawalLog()
    {
        $strSql = 'SELECT
                       *
                   FROM WithdrawalLog
                  ';

        return $this->conn->fetchAll($strSql);
    }


    public function getAllWithdrawalLogCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM WithdrawalLog";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function listWithdrawalLog($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM WithdrawalLog
                   ORDER BY WithdrawalLogId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);
    }

    public function getAllWithdrawalLogCountByWithdrawal($withdrawalId)
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM WithdrawalLog
                   WHERE WithdrawalId = $withdrawalId";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function listWithdrawalLogByWithdrawal($withdrawalId,$pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM WithdrawalLog
                   WHERE WithdrawalId = $withdrawalId
                   ORDER BY WithdrawalLogId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findWithdrawalLogById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM WithdrawalLog
                   WHERE WithdrawalLogId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('WithdrawalLog', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($withdrawalLogId, $data)
    {
        try {
            $r= $this->conn->update('WithdrawalLog', $data, array('WithdrawalLogId' => $withdrawalLogId));

            return $r;
        } catch (\Exception $e) {

            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($withdrawalLogId)
    {
        try {
            return $this->conn->delete("WithdrawalLog",array('WithdrawalLogId' => $withdrawalLogId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }


}
