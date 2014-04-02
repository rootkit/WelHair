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

class AttributeRepository extends AbstractRepository
{

    public function getAllAttributeCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Attribute
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllAttribute()
    {
        $strSql = 'SELECT
                       *
                   FROM Attribute
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listAttribute($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT *
                     FROM Attribute
                     ORDER BY AttributeId
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function getAttributeCountByModel($modelId)
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Attribute
                   WHERE ModelId = $modelId
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function listAttributeByModel($modelId, $pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT *
                     FROM Attribute
                     WHERE   ModelId = $modelId
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function listAllAttributeByModel($modelId)
    {
        $strSql = "  SELECT *
                     FROM Attribute
                     WHERE   ModelId = $modelId
                     ORDER BY AttributeId
                   ";

        return $this->conn->fetchAll($strSql);

    }

    public function findAttributeById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Attribute
                   WHERE AttributeId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Attribute', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($attributeId, $data)
    {
        try {
            return $this->conn->update('Attribute', $data, array('AttributeId' => $attributeId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($attributeId)
    {
        try {
            return $this->conn->delete("Attribute", array('AttributeId'=> $attributeId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
