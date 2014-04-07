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

class OrderRepository extends AbstractRepository
{

    public function getAllOrderCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM `Order`
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllOrder()
    {
        $strSql = 'SELECT
                       *
                   FROM Order
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listOrder($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT *
                     FROM `Order`
                     ORDER BY OrderId
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findOrderById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Order
                   WHERE OrderId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Order', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($orderId, $data)
    {
        try {
            return $this->conn->update('Order', $data, array('OrderId' => $orderId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($orderId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE Order SET IsDeleted = 1 WHERE OrderId  = $orderId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
