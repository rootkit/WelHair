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

class OrderLogRepository extends AbstractRepository
{

    public function getAllOrderLogCount($orderId)
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM OrderLog
                   WHERE OrderId = $orderId
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllOrderLog()
    {
        $strSql = 'SELECT
                       *
                   FROM OrderLog
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function getOrderLogByAction($orderId, $action)
    {
         $strSql = "SELECT
                       *
                   FROM OrderLog
                   WHERE Action = $action AND OrderId = $orderId
                  ";

        return $this->conn->fetchAll($strSql);

    }

    public function getOrderLogByOrder($orderId)
    {
         $strSql = "SELECT
                       *
                   FROM OrderLog
                   WHERE OrderId = $orderId
                  ";

        return $this->conn->fetchAll($strSql);

    }

    public function listOrderLog($orderId, $pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM OrderLog
                   WHERE OrderId = $orderId
                   ORDER BY OrderLogId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findOrderLogById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM OrderLog
                   WHERE Id = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('OrderLog', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($orderLogId, $data)
    {
        try {
            return $this->conn->update('OrderLog', $data, array('Id' => $orderLogId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    /*
    public function delete($paymentId)
    {
        try {
            return $this->conn->delete('Payment', array('PaymentId' => $paymentId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
    */

}
