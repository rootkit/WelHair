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

class ModelRepository extends AbstractRepository
{

    public function getAllModelCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Model
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllModel()
    {
        $strSql = 'SELECT
                       *
                   FROM Model
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listModel($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM Model
                   ORDER BY BrandId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findModelById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Model
                   WHERE ModelId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Brand', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($brandId, $data)
    {
        try {
            return $this->conn->update('Brand', $data, array('BrandId' => $brandId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($brandId)
    {
        try {
            return $this->conn->executeUpdate(" DELETE FROM Brand WHERE BrandId  = $brandId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
