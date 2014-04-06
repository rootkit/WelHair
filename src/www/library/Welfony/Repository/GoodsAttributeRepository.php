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

class GoodsAttributeRepository extends AbstractRepository
{

    
    public function getAll()
    {
        $strSql = 'SELECT
                       *
                   FROM GoodsAttribute
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listByGoods($goodsId)
    {

        $strSql = "  SELECT *
                     FROM GoodsAttribute                  
                     WHERE  GoodsId = $goodsId ";

        return $this->conn->fetchAll($strSql);

    }


    public function listExtendByGoods($goodsId)
    {

        $strSql = "  SELECT *
                     FROM GoodsAttribute GA
                     JOIN Attribute A ON GA.AttributeId = A.AttributeId
                     WHERE  GoodsId = $goodsId AND GA.AttributeId IS NOT NULL";

        return $this->conn->fetchAll($strSql);

    }

    

    public function findById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM GoodsAttribute
                   WHERE GoodsAttributeId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('GoodsAttribute', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($goodsAttributeId, $data)
    {
        try {
            return $this->conn->update('GoodsAttribute', $data, array("GoodsAttributeId" => $goodsAttributeId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($goodsAttributeId)
    {
        try {
            return $this->conn->delete("GoodsAttribute", array("GoodsAttributeId" => $goodsAttributeId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
