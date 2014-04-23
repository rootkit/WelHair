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

class CollectionDocRepository extends AbstractRepository
{

    public function getAllCollectionDocCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM CollectionDoc
                   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllCollectionDoc()
    {
        $strSql = 'SELECT
                       *
                   FROM CollectionDoc
                   WHERE IsDeleted = 0
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listCollectionDoc($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM CollectionDoc
                   WHERE IsDeleted = 0
                   ORDER BY CollectionDocId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findCollectionDocById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM CollectionDoc
                   WHERE CollectionDocId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    
    public function save($data)
    {
        try {
            if ($this->conn->insert('CollectionDoc', $data)) {
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
            $r= $this->conn->update('CollectionDoc', $data, array('CollectionDocId' => $deliveryId));
            return $r;
        } catch (\Exception $e) {

            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
    


    public function delete($dollectionDocId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE CollectionDoc SET IsDeleted = 1 WHERE CollectionDocId  = $collectionDocId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function findCollectionDocByOrder($orderid)
    {
        $strSql = "SELECT
                       CD.*, P.Name
                   FROM CollectionDoc CD
                   LEFT JOIN Payment P ON CD.PaymentId = CD.PaymentId
                   WHERE CD.IsDeleted = 0 AND CD.OrderId = $orderid
                  ";

        return $this->conn->fetchAssoc($strSql);
    }

}
