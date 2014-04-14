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
                   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllOrder()
    {
        $strSql = 'SELECT
                       *
                   FROM `Order`
                   WHERE IsDeleted = 0
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listOrder($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT O.*, CASE U.Username
                                    WHEN  NULL THEN 'Admin'
                                    ELSE U.Username
                                END AS UserName,
                                D.Name AS DeliveryName,
                                P.Name AS PaymentName
                     FROM `Order` O
                     LEFT JOIN Users U ON U.UserId = O.UserId
                     LEFT JOIN Delivery D ON O.Distribution = D.DeliveryId
                     LEFT JOIN Payment P ON P.PaymentId = O.PayType
                     WHERE O.IsDeleted = 0
                     ORDER BY O.OrderId
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findOrderById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM `Order`
                   WHERE OrderId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data, $goods = null)
    {
        /*
        try {
            if ($this->conn->insert('Order', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
        */

        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            if ($this->conn->insert('`Order`', $data)) {
                $orderId= $this->conn->lastInsertId();
            } else {
              return false;
            }

            if ($goods) {
               $this->conn->delete('OrderGoods', array('OrderId'=> $orderId));
              foreach ($goods as $row) {
                $row['OrderId'] = $orderId;
                $this->conn->insert('OrderGoods', $row);
              }
            }

            $conn->commit();

            return $orderId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

    public function update($orderId, $data, $goods=null)
    {
        /*
        try {
            return $this->conn->update('Order', $data, array('OrderId' => $orderId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
        */
        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            $this->conn->update('`Order`', $data, array('OrderId' => $orderId));

            if ($goods) {
               $this->conn->delete('OrderGoods', array('OrderId'=> $orderId));
               foreach ($goods as $row) {
                 $row['OrderId'] = $orderId;
                 $this->conn->insert('OrderGoods', $row);
               }
            }
            else
            {
                $this->conn->delete('OrderGoods', array('OrderId'=> $orderId));
            }

            $conn->commit();

            return $orderId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

    public function delete($orderId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE `Order` SET IsDeleted = 1 WHERE OrderId  = $orderId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
