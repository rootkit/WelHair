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

class DeliveryRepository extends AbstractRepository
{

    public function getAllDeliveryCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Delivery
                   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllDelivery()
    {
        $strSql = 'SELECT
                       *
                   FROM Delivery
                   WHERE IsDeleted = 0
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listDelivery($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM Delivery
                   WHERE IsDeleted = 0
                   ORDER BY DeliveryId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findDeliveryById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Delivery
                   WHERE DeliveryId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Delivery', $data)) {
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
            $r= $this->conn->update('Delivery', $data, array('DeliveryId' => $deliveryId));

            return $r;
        } catch (\Exception $e) {

            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($deliveryId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE Delivery SET IsDeleted = 1 WHERE DeliveryId  = $deliveryId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
