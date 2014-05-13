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

class OrderRepository extends AbstractRepository
{

    public function getAllOrderCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM `Order`
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllOrder()
    {
        $strSql = 'SELECT
                       *
                   FROM `Order`
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listOrder($pageNumber, $pageSize)
    {
        $offset = ($pageNumber - 1) * $pageSize;

        $strSql = "  SELECT O.*, CASE U.Username
                                    WHEN  NULL THEN 'Admin'
                                    ELSE U.Username
                                END AS UserName,
                                D.Name AS DeliveryName,
                                P.Name AS PaymentName
                     FROM `Order` O
                     LEFT JOIN Users U ON U.UserId = O.UserId
                     LEFT JOIN Delivery D ON O.Distribution = D.DeliveryId
                     LEFT JOIN Payment P ON P.PaymentId = O.PayType
                     ORDER BY O.OrderId DESC
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);
    }

    public function getAllOrdersCountByUserId($userId, $status)
    {
        $filter = '';
        if ($status > 0) {
            $filter = ' AND O.Status = ' . intval($status);
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM `Order` O
                   WHERE O.IsDeleted = 0 AND O.UserId = ? $filter
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($userId));

        return $row['Total'];
    }

    public function getAllOrdersByUserId($userId, $status, $page, $pageSize)
    {
        $offset = ($page - 1) * $pageSize;

        $filter = '';
        if ($status > 0) {
            $filter = ' AND O.Status = ' . intval($status);
        }

        $strSql = "SELECT
                     O.OrderId,
                     O.OrderNo,
                     O.Postscript,

                     O.Status,
                     O.PayType,
                     O.PayStatus,

                     O.Distribution,
                     O.DistributionStatus,

                     O.Country,
                     O.Province,
                     PA.Name ProvinceName,
                     O.City,
                     PC.Name CityName,
                     O.Area District,
                     IFNULL(PD.Name, '') DistrictName,
                     O.Postcode,
                     O.Address,

                     O.AcceptName,
                     O.Mobile,

                     O.OrderAmount,
                     O.PayableAmount,
                     O.PayableFreight,

                     O.CreateTime,
                     O.SendTime,
                     O.CompletionTime,
                     O.AcceptTime,

                     U.UserId,
                     U.Username,
                     U.Nickname,
                     U.Email,
                     U.AvatarUrl,

                     OG.Id OrderGoodsId,
                     OG.GoodsId,
                     OG.ProductsId,
                     OG.Img,
                     OG.RealPrice GoodsPrice,
                     OG.GoodsNums,
                     OG.GoodsWeight,
                     OG.GoodsArray

                   FROM `Order` O
                   INNER JOIN Area PA ON PA.AreaId = O.Province
                   INNER JOIN Area PC ON PC.AreaId = O.City
                   LEFT OUTER JOIN Area PD ON PD.AreaId = O.Area
                   INNER JOIN Users U ON U.UserId = O.UserId
                   INNER JOIN OrderGoods OG ON OG.OrderId = O.OrderId
                   WHERE O.IsDeleted = 0 AND O.UserId = ? $filter
                   ORDER BY O.OrderId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql, array($userId));
    }

    public function findOrderById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM `Order`
                   WHERE OrderId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data, $goods = null)
    {
        /*
        try {
            if ($this->conn->insert('Order', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
        */

        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            if ($this->conn->insert('`Order`', $data)) {
                $orderId= $this->conn->lastInsertId();
            } else {
              return false;
            }

            if ($goods) {
               $this->conn->delete('OrderGoods', array('OrderId'=> $orderId));
              foreach ($goods as $row) {
                $row['OrderId'] = $orderId;
                $this->conn->insert('OrderGoods', $row);
              }
            }

            $conn->commit();

            return $orderId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

    public function update($orderId, $data, $goods=null)
    {
        /*
        try {
            return $this->conn->update('Order', $data, array('OrderId' => $orderId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
        */
        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            $this->conn->update('`Order`', $data, array('OrderId' => $orderId));

            if ($goods) {
               $this->conn->delete('OrderGoods', array('OrderId'=> $orderId));
               foreach ($goods as $row) {
                 $row['OrderId'] = $orderId;
                 $this->conn->insert('OrderGoods', $row);
               }
            } else {
                $this->conn->delete('OrderGoods', array('OrderId'=> $orderId));
            }

            $conn->commit();

            return $orderId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

    public function delete($orderId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE `Order` SET IsDeleted = 1 WHERE OrderId  = $orderId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

    }

    public function updateOrder($orderId, $data)
    {

        try {
            return $this->conn->update('`Order`', $data, array('OrderId' => $orderId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function payOrder($orderId, $data, $log, $doc, $userbalancelog, $companybalancelog, $paymentTransaction )
    {

        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            $this->conn->update('`Order`', $data, array('OrderId' => $orderId));

            if ($log) {

                 $this->conn->insert('OrderLog', $log);

            }

            if ($doc) {

                 $this->conn->insert('CollectionDoc', $doc);

            }

            if ($userbalancelog) {

                 $amount = $userbalancelog['Amount'];
                 $userId = $userbalancelog['UserId'];

                 $this->conn->executeUpdate(" 
                        UPDATE `Users` SET Balance = Balance + $amount WHERE UserId  = $userId; 
                 ");

                 $this->conn->insert('UserBalanceLog', $userbalancelog);

            }

            if ($companybalancelog) {

                 $amount = $companybalancelog['Amount'];
                 $companyId = $companybalancelog['CompanyId'];

                 $this->conn->executeUpdate(" 
                        UPDATE `Company` SET Amount = Amount + $amount WHERE CompanyId  = $companyId; 
                 ");


                 $this->conn->insert('CompanyBalanceLog', $companybalancelog);

            }

            if( $paymentTransaction )
            {
                $this->conn->insert('paymentTransaction',$paymentTransaction );
            }

            $conn->commit();

            return $orderId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function deliverOrder($orderId, $data, $log, $doc)
    {

        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            $this->conn->update('`Order`', $data, array('OrderId' => $orderId));

            if ($log) {

                 $this->conn->insert('OrderLog', $log);

            }
            if ($doc) {
                 $this->conn->insert('DeliveryDoc', $doc);
            }

            $conn->commit();

            return $orderId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function refundOrder($orderId, $data, $log, $doc, $userbalancelog, $companybalancelog, $paymentTransaction )
    {

        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            $this->conn->update('`Order`', $data, array('OrderId' => $orderId));

            if ($log) {

                 $this->conn->insert('OrderLog', $log);

            }
            if ($doc) {
                 $this->conn->insert('RefundmentDoc', $doc);
            }

            if ($userbalancelog) {

                 $amount = $userbalancelog['Amount'];
                 $userId = $userbalancelog['UserId'];

                 $this->conn->executeUpdate(" 
                        UPDATE `Users` SET Balance = Balance + $amount WHERE UserId  = $userId; 
                 ");

                 $this->conn->insert('UserBalanceLog', $userbalancelog);

            }

            if ($companybalancelog) {

                 $amount = $companybalancelog['Amount'];
                 $companyId = $companybalancelog['CompanyId'];

                 $this->conn->executeUpdate(" 
                        UPDATE `Company` SET Amount = Amount + $amount WHERE CompanyId  = $companyId; 
                 ");

                 $this->conn->insert('CompanyBalanceLog', $companybalancelog);

            }

            if( $paymentTransaction )
            {
                $this->conn->insert('paymentTransaction',$paymentTransaction );
            }

            $conn->commit();

            return $orderId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function completeOrder($orderId, $data, $log)
    {

        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            $this->conn->update('`Order`', $data, array('OrderId' => $orderId));

            if ($log) {

                 $this->conn->insert('OrderLog', $log);

            }
            $conn->commit();

            return $orderId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
