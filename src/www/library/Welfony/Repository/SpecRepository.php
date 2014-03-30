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

class SpecRepository extends AbstractRepository
{

    public function getAllSpecCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Spec
                   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllSpec()
    {
        $strSql = 'SELECT
                       *
                   FROM Spec
                   WHERE IsDeleted = 0
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listSpec( $pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT *
                     FROM Spec
                     WHERE IsDeleted = 0
                     ORDER BY SpecId
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function getSpecCountByModel($modelId)
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Spec
                   WHERE IsDeleted = 0 AND SpecId IN (SELECT SpecIds FROM Model WHERE ModelId = $modelId )
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }


    public function listSpecByModel($modelId, $pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT *
                     FROM Spec
                     WHERE  IsDeleted = 0  SpecId IN (SELECT SpecIds FROM Model WHERE ModelId = $modelId )
                     ORDER BY CouponCodeId
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findSpecById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Spec
                   WHERE SpecId = ? 
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Spec', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($specId, $data)
    {
        try {
            return $this->conn->update('Spec', $data, array('SpecId' => $specId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($specId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE Spec SET IsDeleted = 1 WHERE SpecId  = $specId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
