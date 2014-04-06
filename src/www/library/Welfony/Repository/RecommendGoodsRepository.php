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

class RecommendGoodsRepository extends AbstractRepository
{

    
    public function getAll()
    {
        $strSql = 'SELECT
                       *
                   FROM RecommendGoods
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listByGoods($goodsId)
    {

        $strSql = "  SELECT *
                     FROM RecommendGoods
                     WHERE  GoodsId = $goodsId ";

        return $this->conn->fetchAll($strSql);

    }

    

    public function findById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM RecommendGoods
                   WHERE RecommendGoodsId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('RecommendGoods', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($recommendGoodsId, $data)
    {
        try {
            return $this->conn->update('RecommendGoods', $data, array("RecommendGoodsId" => $recommendGoodsId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($recommendGoodsId)
    {
        try {
            return $this->conn->delete("RecommendGoods", array("RecommendGoodsId" => $recommendGoodsId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
