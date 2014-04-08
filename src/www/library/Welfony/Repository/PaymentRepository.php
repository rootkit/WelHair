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

class PaymentRepository extends AbstractRepository
{

    public function getAllPaymentCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Payment
                   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllPayment()
    {
        $strSql = 'SELECT
                       *
                   FROM Payment
                   WHERE IsDeleted = 0
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listPayment($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM Payment
                   WHERE IsDeleted = 0
                   ORDER BY PaymentId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findPaymentById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Payment
                   WHERE PaymentId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    
    public function save($data)
    {
        try {
            if ($this->conn->insert('Payment', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }
    
    
    public function update($paymentId, $data)
    {
        try {
            return $this->conn->update('Payment', $data, array('PaymentId' => $paymentId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
    

    /*
    public function delete($freightId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE Freight SET IsDeleted = 1 WHERE FreightId  = $freightId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
    */

}
