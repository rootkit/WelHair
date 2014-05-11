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
        $strSql = "SELECT W.*, U.Username AS Username
                   FROM Withdrawal W
                   LEFT JOIN Users U ON U.UserId = W.UserId
                   ORDER BY W.WithdrawalId
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

    public function approve($withdrawalId)
    {

        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            $strSql = 'SELECT
                       *
                   FROM Withdrawal
                   WHERE WithdrawalId = ?
                   LIMIT 1';

            $withdrawal = $this->conn->fetchAssoc($strSql, array($withdrawalId));

            $amount = $withdrawal['Amount'];
            $userId = $withdrawal['UserId'];

            $this->conn->update('Withdrawal', array('Status'=>1), array('WithdrawalId' => $withdrawalId));
            $this->conn->insert('WithdrawalLog', array('WithdrawalId'=>$withdrawalId, 
                                                      'Action'=>'批准',
                                                      'Reason'=>'批准',
                                                      'CreateTime'=> date('Y-m-d H:i:s')));
            $this->conn->executeUpdate(" 
                        UPDATE `Users` SET Balance = Balance - $amount WHERE UserId  = $userId; 
                 ");

            $this->conn->insert('UserBalanceLog', array('UserId' => $userId, 
                                                       'Amount' => -$amount,
                                                       'Status' => 1,
                                                       'CreateTime'=> date('Y-m-d H:i:s'),
                                                       'Description'=>'提现'.$amount.' 【'.$withdrawalId.'】'
              ));
            $conn->commit();

            return true;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

    public function reject($withdrawalId)
    {

        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            $strSql = 'SELECT
                       *
                   FROM Withdrawal
                   WHERE WithdrawalId = ?
                   LIMIT 1';

            $withdrawal = $this->conn->fetchAssoc($strSql, array($withdrawalId));

            $amount = $withdrawal['Amount'];
            $userId = $withdrawal['UserId'];

            $this->conn->update('Withdrawal', array('Status'=>2), array('WithdrawalId' => $withdrawalId));
            $this->conn->insert('WithdrawalLog', array('WithdrawalId'=>$withdrawalId, 
                                                      'Action'=>'拒绝',
                                                      'Reason'=>'拒绝',
                                                      'CreateTime'=> date('Y-m-d H:i:s')));
  
            $conn->commit();

            return true;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }



}
