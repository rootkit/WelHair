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

class WithdrawalRepository extends AbstractRepository
{


    public function getAllWithdrawal()
    {
        $strSql = 'SELECT
                       *
                   FROM Withdrawal
                  ';

        return $this->conn->fetchAll($strSql);
    }


    public function getAllWithdrawalCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Withdrawal";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function listWithdrawal($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM Withdrawal
                   ORDER BY WithdrawalId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);
    }

    public function getAllWithdrawalCountByUser($userId)
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Withdrawal
                   WHERE UserId = $userId";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function listWithdrawalByUser($userId,$pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM Withdrawal
                   WHERE UserId = $userId
                   ORDER BY WithdrawalId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findWithdrawalById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Withdrawal
                   WHERE WithdrawalId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Withdrawal', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($withdrawalId, $data)
    {
        try {
            $r= $this->conn->update('Withdrawal', $data, array('WithdrawalId' => $withdrawalId));

            return $r;
        } catch (\Exception $e) {

            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($withdrawalId)
    {
        try {
            return $this->conn->delete("Withdrawal",array('WithdrawalId' => $withdrawalId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }


}
