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
                   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllModel()
    {
        $strSql = 'SELECT
                       *
                   FROM Model
                   WHERE IsDeleted = 0
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listModel($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM Model
                   WHERE IsDeleted = 0
                   ORDER BY ModelId
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

    /*
    public function save($data, $attributes = null)
    {
        try {
            if ($this->conn->insert('Model', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }
    */

    public function save($data, $attributes= null)
    {
        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            if ($this->conn->insert('Model', $data)) {
                $modelId= $this->conn->lastInsertId();
            } else {
              return false;
            }
            if ($attributes) {
              foreach ($attributes as $row) {
                $row['ModelId'] = $modelId;
                $this->conn->insert('Attribute', $row);
              }
            }
            $conn->commit();

            return $modelId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

    /*
    public function update($modelId, $data)
    {
        try {
            return $this->conn->update('Model', $data, array('ModelId' => $modelId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
    */

    public function update($modelId, $data, $attributes = null)
    {
        try {
            if ($attributes) {
                $this->conn->delete('Attribute', array('ModelId' => $modelId));
                foreach ($attributes as $attr) {
                    $attr['ModelId'] = $modelId;
                    $this->conn->insert('Attribute', $attr);
                }

            } else {
                $this->conn->delete('Attribute', array('ModelId' => $modelId));
            }

            $this->conn->update('Model', $data, array('ModelId' => $modelId));

            return true;
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($modelId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE Model SET IsDeleted = 1 WHERE ModelId  = $modelId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
