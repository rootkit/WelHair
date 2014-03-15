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

class CouponRepository extends AbstractRepository
{

    public function getAllCouponCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Coupon
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllCoupon()
    {
        $strSql = 'SELECT
                       *
                   FROM Coupon
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listCoupon($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "   SELECT C.*,
                      ( SELECT count(*) FROM CouponCode WHERE CouponId = C.CouponId ) AS CouponCodeCount,
                      ( SELECT count(*) FROM CouponCode WHERE CouponId = C.CouponId AND ReceiveTime IS NOT NULL ) AS ReceivedCouponCodeCount
                      FROM Coupon C
                      ORDER BY CouponId
                      LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findCouponById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Coupon
                   WHERE CouponId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Coupon', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($couponId, $data)
    {
        try {
            return $this->conn->update('Coupon', $data, array('CouponId' => $couponId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($couponId)
    {
        try {
            return $this->conn->executeUpdate(" DELETE FROM Coupon WHERE CouponId  = $couponId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function getAllCouponType()
    {
        $strSql = 'SELECT
                       *
                   FROM CouponType
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function getAllCouponPaymentType()
    {
        $strSql = 'SELECT
                       *
                   FROM CouponPaymentType
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function getAllCouponAmountLimitType()
    {
        $strSql = 'SELECT
                       *
                   FROM CouponAmountLimitType
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function getAllCouponAccountLimitType()
    {
        $strSql = 'SELECT
                       *
                   FROM CouponAccountLimitType
                  ';

        return $this->conn->fetchAll($strSql);
    }

}
