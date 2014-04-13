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

class OrderGoodsRepository extends AbstractRepository
{

    public function getAllOrderGoodsCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM OrderGoods
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllOrderGoods()
    {
        $strSql = 'SELECT
                       *
                   FROM OrderGoods
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function getAllOrderGoodsByOrder($orderId)
    {
        $strSql = "SELECT
                       *
                   FROM OrderGoods
                   WHERE OrderId = $orderId
                  ";

        return $this->conn->fetchAll($strSql);
    }

    public function listOrderGoods($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT *
                     FROM OrderGoods
                     ORDER BY Id
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findOrderGoodsById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM OrderGoods
                   WHERE Id = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('OrderGoods', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($id, $data)
    {
        try {
            return $this->conn->update('OrderGoods', $data, array('Id' => $id));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($id)
    {
        try {
            return $this->conn->delete('OrderGoods',  array('Id' => $id));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
