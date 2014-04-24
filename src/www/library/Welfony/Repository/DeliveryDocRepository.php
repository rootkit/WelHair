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

class DeliveryDocRepository extends AbstractRepository
{

    public function getAllDeliveryDocCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM DeliveryDoc
                   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllDeliveryDoc()
    {
        $strSql = 'SELECT
                       *
                   FROM DeliveryDoc
                   WHERE IsDeleted = 0
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listDeliveryDoc($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM DeliveryDoc
                   WHERE IsDeleted = 0
                   ORDER BY DeliveryDocId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findDeliveryDocById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM DeliveryDoc
                   WHERE DeliveryDocId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('DeliveryDoc', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($deliveryId, $data)
    {
        try {
            $r= $this->conn->update('DeliveryDoc', $data, array('DeliveryId' => $deliveryId));

            return $r;
        } catch (\Exception $e) {

            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($deliverydocId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE DeliveryDoc SET IsDeleted = 1 WHERE DeliveryDocId  = $deliverydocId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function findDeliveryDocByOrder($oid)
    {
        $strSql = 'SELECT
                       DD.*, D.Name AS DeliveryName
                   FROM DeliveryDoc DD
                   LEFT JOIN Delivery D ON D.DeliveryId = DD.DeliveryType
                   WHERE DD.OrderId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($oid));
    }

}
