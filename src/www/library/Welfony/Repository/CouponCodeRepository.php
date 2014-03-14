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

class CouponCodeRepository extends AbstractRepository
{

    public function getAllCouponCodeCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM CouponCode
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllCouponCode()
    {
        $strSql = 'SELECT
                       *
                   FROM CouponCode
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listCouponCode($couponId, $pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT *
                     FROM CouponCode
                     WHERE CouponId = $couponId
                     ORDER BY CouponCodeId
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findCouponCodeById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM CouponCode
                   WHERE CouponCodeId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('CouponCode', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function batchsave($data)
    {
        $conn = $this->conn;
        $conn->beginTransaction();
        try {
            foreach( $data as $row )
            {
              error_log(serialize($row));
              $this->conn->insert('CouponCode', $row);
            }
            $conn->commit();
            return true;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

    public function update($couponId, $data)
    {
        try {
            return $this->conn->update('CouponCode', $data, array('CouponCodeId' => $couponId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($couponId)
    {
        try {
            return $this->conn->executeUpdate(" DELETE FROM CouponCode WHERE CouponId  = $couponId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
