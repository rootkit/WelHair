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

class RefundmentDocRepository extends AbstractRepository
{

    public function getAllRefundmentDocCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM RefundmentDoc
                   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllRefundmentDoc()
    {
        $strSql = 'SELECT
                       *
                   FROM RefundmentDoc
                   WHERE IsDeleted = 0
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listRefundmentDoc($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM RefundmentDoc
                   WHERE IsDeleted = 0
                   ORDER BY RefundmentDocId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findRefundmentDocById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM RefundmentDoc
                   WHERE RefundmentDocId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    
    public function save($data)
    {
        try {
            if ($this->conn->insert('RefundmentDoc', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }
    

    public function update($refundmentDocId, $data)
    {
        try {
            $r= $this->conn->update('RefundmentDoc', $data, array('RefundmentDocId' => $refundmentDocId));
            return $r;
        } catch (\Exception $e) {

            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
    


    public function delete($refundmentDocId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE RefundmentDoc SET IsDeleted = 1 WHERE RefundmentDocId  = $refundmentDocId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function findRefundmentDocByOrder($orderid)
    {
        $strSql = 'SELECT
                       *
                   FROM RefundmentDoc
                   WHERE OrderId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($orderid));
    }

}
