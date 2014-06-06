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
use Welfony\Repository\UserBalanceLogRepository;

class DepositRepository extends AbstractRepository
{

    public function getAllDeposit()
    {
        $strSql = 'SELECT
                       *
                   FROM Deposit
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function getAllDepositCount($userId)
    {
        $filter = '';
        $paramArr = array();
        if ($userId !== null) {
            $filter .= ' AND D.UserId = ?';
            $paramArr[] = $userId;
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Deposit D
                   WHERE D.DepositId > 0 $filter";

        $row = $this->conn->fetchAssoc($strSql, $paramArr);

        return $row['Total'];
    }

    public function listDeposit($pageNumber, $pageSize, $userId)
    {
        $filter = '';
        $paramArr = array();
        if ($userId !== null) {
            $filter .= ' AND W.UserId = ?';
            $paramArr[] = $userId;
        }

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT W.*, U.Username AS Username, U.Nickname
                   FROM Deposit W
                   LEFT JOIN Users U ON U.UserId = W.UserId
                   WHERE W.DepositId > 0 $filter
                   ORDER BY W.DepositId DESC
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql, $paramArr);
    }

    public function findDepositById($id)
    {
        $strSql = 'SELECT
                       W.*,
                       U.Nickname,
                       U.Username
                   FROM Deposit W
                   LEFT JOIN Users U ON W.UserId = U.UserId
                   WHERE W.DepositId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        if( isset($data['Nickname'])) unset($data['Nickname']);
        if( isset($data['Username'])) unset($data['Username']);

        $conn = $this->conn;
        $conn->beginTransaction();
        try {
            $newId = 0;
            if ($this->conn->insert('Deposit', $data)) {
               $newId = $this->conn->lastInsertId();
            }

            $amount = $data['Amount'];
            $userId = $data['UserId'];

            if ($data['Status'] == '1') {
                $existedUserBalanceLog = UserBalanceLogRepository::getInstance()->findUserBalanceLogByIncomeSrc(4, $data['DepositNo']);
                if (!$existedUserBalanceLog) {
                  $this->conn->executeUpdate("
                      UPDATE `Users` SET Balance = Balance + $amount WHERE UserId  = $userId;
                  ");

                  $this->conn->insert('UserBalanceLog', array(
                      'UserId' => $userId,
                      'Amount' => $amount,
                      'Status' => 1,
                      'IncomeSrc' => 4,
                      'IncomeSrcId' => $data['DepositNo'],
                      'CreateTime'=> date('Y-m-d H:i:s'),
                      'Description'=> sprintf('充值%.2f 【%s】', $amount, $data['DepositNo'])
                  ));
                }
            }
            $conn->commit();

            return $newId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($depositId, $data)
    {
        if( isset($data['Nickname'])) unset($data['Nickname']);
        if( isset($data['Username'])) unset($data['Username']);

        $conn = $this->conn;
        $conn->beginTransaction();
        try {
            $strSql = 'SELECT
                       *
                   FROM Deposit
                   WHERE DepositId = ?
                   LIMIT 1';

            $existing = $this->conn->fetchAssoc($strSql, array($depositId));

            $r= $this->conn->update('Deposit', $data, array('DepositId' => $depositId));
            if ($existing['Status'] == '0' && isset($data['Status']) && $data['Status'] == '1') {
                $amount = $existing['Amount'];
                $userId = $existing['UserId'];

                $existedUserBalanceLog = UserBalanceLogRepository::getInstance()->findUserBalanceLogByIncomeSrc(4, $data['DepositNo']);
                if (!$existedUserBalanceLog) {
                  $this->conn->executeUpdate("
                    UPDATE `Users` SET Balance = Balance + $amount WHERE UserId  = $userId;
                  ");

                  $this->conn->insert('UserBalanceLog', array(
                    'UserId' => $userId,
                    'Amount' => $amount,
                    'Status' => 1,
                    'IncomeSrc' => 4,
                    'IncomeSrcId' => $data['DepositNo'],
                    'CreateTime'=> date('Y-m-d H:i:s'),
                    'Description'=> sprintf('充值%.2f 【%s】', $amount, $existing['DepositNo'])
                  ));
                }
            }
            $conn->commit();

            return $r;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($depositId)
    {
        try {
            return $this->conn->delete("Deposit",array('DepositId' => $depositId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function succeed($depositId)
    {

        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            $strSql = 'SELECT
                       *
                   FROM Deposit
                   WHERE DepositId = ?
                   LIMIT 1';

            $deposit = $this->conn->fetchAssoc($strSql, array($depositId));

            $amount = $deposit['Amount'];
            $userId = $deposit['UserId'];

            $this->conn->update('Deposit', array('Status'=>1), array('DepositId' => $depositId));



            $this->conn->executeUpdate("
                        UPDATE `Users` SET Balance = Balance + $amount WHERE UserId  = $userId;
                 ");

            $this->conn->insert('UserBalanceLog', array('UserId' => $userId,
                                                       'Amount' => -$amount,
                                                       'Status' => 1,
                                                       'CreateTime'=> date('Y-m-d H:i:s'),
                                                       'Description'=>'充值'.$amount.' 【'.$depositId.'】'
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

}
