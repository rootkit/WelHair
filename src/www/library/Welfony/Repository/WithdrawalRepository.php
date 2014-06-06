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

    public function getUserWithrawalTotal($userId)
    {
        $strSql = "SELECT
                       SUM(Amount) `Total`
                   FROM Withdrawal
                   WHERE UserId = $userId AND Status = 0 ";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getCompanyWithrawalTotal($companyId)
    {
        $strSql = "SELECT
                       SUM(Amount) `Total`
                   FROM Withdrawal
                   WHERE CompanyId = $companyId AND Status = 0 ";

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

    public function getAllUserWithdrawalCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Withdrawal
                   WHERE UserId IS NOT NULL";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function listUserWithdrawal($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT W.*, U.Username AS Username, U.Nickname, U.Email
                   FROM Withdrawal W
                   LEFT JOIN Users U ON U.UserId = W.UserId
                   WHERE W.UserId IS NOT NULL
                   ORDER BY W.WithdrawalId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);
    }

    public function getAllCompanyWithdrawalCount($companyId)
    {
        $filter = '';
        $paramArr = array();
        if ($companyId !== null) {
            $filter .= ' AND W.CompanyId = ?';
            $paramArr[] = $companyId;
        } else {
            $filter .= ' AND W.CompanyId IS NOT NULL';
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Withdrawal W
                   WHERE W.WithdrawalId > 0 $filter";

        $row = $this->conn->fetchAssoc($strSql, $paramArr);

        return $row['Total'];
    }

    public function listCompanyWithdrawal($pageNumber, $pageSize, $companyId)
    {
        $filter = '';
        $paramArr = array();
        if ($companyId !== null) {
            $filter .= ' AND W.CompanyId = ?';
            $paramArr[] = $companyId;
        } else {
            $filter .= ' AND W.CompanyId IS NOT NULL';
        }

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT W.*, C.Name AS Name
                   FROM Withdrawal W
                   LEFT JOIN Company C ON C.CompanyId = W.CompanyId
                   WHERE W.WithdrawalId > 0 $filter
                   ORDER BY W.WithdrawalId DESC
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql, $paramArr);
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

    public function getAllWithdrawalCountByCompany($companyId)
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Withdrawal
                   WHERE CompanyId = $companyId";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function listWithdrawalByCompany($companyId,$pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM Withdrawal
                   WHERE CompanyId = $companyId
                   ORDER BY WithdrawalId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findWithdrawalById($id)
    {
        $strSql = 'SELECT
                       W.*,
                       U.Nickname,
                       U.Username,
                       C.Name
                   FROM Withdrawal W
                   LEFT JOIN Users U ON W.UserId = U.UserId
                   LEFT JOIN Company C ON C.CompanyId = W.CompanyId
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
            $withdrawal = $this->findWithdrawalById($withdrawalId);

            $amount = $withdrawal['Amount'];
            $userId = $withdrawal['UserId'];
            $companyId = $withdrawal['CompanyId'];

            $this->conn->update('Withdrawal', array('Status' => 1), array('WithdrawalId' => $withdrawalId));
            $this->conn->insert('WithdrawalLog', array(
              'WithdrawalId'=> $withdrawalId,
              'Action'=>'批准',
              'Reason'=>'批准',
              'CreateTime'=> date('Y-m-d H:i:s'))
            );

            if ($userId) {
              $existedUserBalanceLog = UserBalanceLogRepository::getInstance()->findUserBalanceLogByIncomeSrc(3, $withdrawal['WithdrawalNo']);
              if (!$existedUserBalanceLog) {
                $this->conn->executeUpdate("
                  UPDATE `Users` SET Balance = Balance - $amount WHERE UserId  = $userId;
               ");

                $this->conn->insert('UserBalanceLog', array(
                   'UserId' => $userId,
                   'Amount' => -$amount,
                   'Status' => 1,
                   'IncomeSrc' => 3,
                   'IncomeSrcId' => $withdrawal['WithdrawalNo'],
                   'CreateTime'=> date('Y-m-d H:i:s'),
                   'Description'=> sprintf('提现%.2f 【%s】', $amount, $withdrawal['WithdrawalNo'])
                ));
              }
            } else if($companyId) {
                $existedCompanyBalanceLog = CompanyBalanceLogRepository::getInstance()->findCompanyBalanceLogByIncomeSrc(3, $withdrawal['WithdrawalNo']);
                if (!$existedCompanyBalanceLog) {
                  $this->conn->executeUpdate("UPDATE `Company` SET Amount = Amount - $amount WHERE CompanyId  = $companyId;");

                  $this->conn->insert('CompanyBalanceLog', array(
                     'CompanyId' => $companyId,
                     'Amount' => -$amount,
                     'Status' => 1,
                     'IncomeSrc' => 3,
                     'IncomeSrcId' => $withdrawal['WithdrawalNo'],
                     'CreateTime'=> date('Y-m-d H:i:s'),
                     'Description'=> sprintf('提现%.2f 【%s】', $amount, $withdrawal['WithdrawalNo'])
                  ));
                }
            }
            $conn->commit();

            return true;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

    public function reject($withdrawalId, $reason)
    {
        $conn = $this->conn;
        $conn->beginTransaction();
        try {
            $this->conn->update('Withdrawal', array('Status' => 2), array('WithdrawalId' => $withdrawalId));
            $this->conn->insert('WithdrawalLog', array(
              'WithdrawalId'=>$withdrawalId,
              'Action'=>'拒绝',
              'Reason'=> $reason,
              'CreateTime'=> date('Y-m-d H:i:s'))
            );

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
