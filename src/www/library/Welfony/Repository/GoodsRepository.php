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

class GoodsRepository extends AbstractRepository
{

    public function getAllGoodsCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Goods
                   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllGoods()
    {
        $strSql = 'SELECT
                       *
                   FROM Goods
                   WHERE IsDeleted = 0
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listGoods($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT *
                     FROM Goods
                     WHERE IsDeleted = 0
                     ORDER BY GoodsId
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findGoodsById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Goods
                   WHERE GoodsId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Goods', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($goodsId, $data)
    {
        try {
            return $this->conn->update('Goods', $data, array('GoodsId' => $goodsId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($goodsId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE Goods SET IsDeleted = 1 WHERE GoodsId  = $goodsId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
