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

class ProductsRepository extends AbstractRepository
{

    public function getAllProductsCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Products
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllProducts()
    {
        $strSql = 'SELECT
                       *
                   FROM Products
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listProducts($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT *
                     FROM Products
                     ORDER BY ProductsId
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findProductsById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Products
                   WHERE ProductsId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Products', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($productsId, $data)
    {
        try {
            return $this->conn->update('Products', $data, array('ProductsId' => $productsId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($produtsId)
    {
        try {
            return $this->conn->delete('Products',  array('ProductsId' => $productsId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
