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

class GoodsRepository extends AbstractRepository
{

    public function getAllGoodsCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Goods
                   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllGoods()
    {
        $strSql = 'SELECT
                       *
                   FROM Goods
                   WHERE IsDeleted = 0
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function getAllGoodsByCompany($companyId)
    {
        $strSql = "SELECT
                       *
                   FROM CompanyGoods CG
                   JOIN  Goods G ON CG.GoodsId = G.GoodsId
                   WHERE CG.CompanyId = $companyId
                  ";

        return $this->conn->fetchAll($strSql);
    }


    public function listGoods($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT G.*, B.Name AS BrandName, GROUP_CONCAT(C.Name SEPARATOR ',') AS CategoryName
                     FROM Goods G
                     LEFT JOIN Brand B ON B.BrandId = G.BrandId
                     LEFT JOIN CategoryExtend CE ON CE.GoodsId = G.GoodsId
                     LEFT JOIN Category C ON CE.CategoryId = C.CategoryId
                     WHERE G.IsDeleted = 0
                     GROUP BY G.GoodsId
                     ORDER BY G.GoodsId
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function getAllGoodsAndProductsCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Goods G
                   LEFT JOIN Products P ON G.GoodsId = P.GoodsId
                   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function listGoodsAndProducts($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "  SELECT G.GoodsId, G.Name, G.GoodsNo,
                     CASE P.SellPrice 
                        WHEN NULL THEN G.SellPrice
                        ELSE P.SellPrice
                     END AS SellPrice,

                     CASE P.CostPrice 
                        WHEN NULL THEN G.CostPrice
                        ELSE P.CostPrice
                     END AS CostPrice,
                     CASE P.Weight 
                        WHEN NULL THEN G.Weight
                        ELSE P.Weight
                     END AS Weight,
                     P.ProductsNo,
                     G.Unit,
                     P.SpecArray,
                     G.Img,
                     P.ProductsId
                     FROM Goods G
                     LEFT JOIN Products P ON G.GoodsId = P.GoodsId
                     WHERE G.IsDeleted = 0
                     LIMIT $offset, $pageSize ";
        return $this->conn->fetchAll($strSql);

    }

    public function findGoodsById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Goods
                   WHERE GoodsId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data,$categories=null,$attributes=null, $products=null, $recommends=null, $companies=null)
    {
        /*
        try {
            if ($this->conn->insert('Goods', $data)) {
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

            if ($this->conn->insert('Goods', $data)) {
                $goodsId= $this->conn->lastInsertId();
            } else {
              return false;
            }
            if ($categories) {
               $this->conn->delete('CategoryExtend', array('GoodsId'=> $goodsId));
              foreach ($categories as $cat) {
                $cat['GoodsId'] = $goodsId;
                $this->conn->insert('CategoryExtend', $cat);
              }
            }

            if ($attributes) {
               $this->conn->delete('GoodsAttribute', array('GoodsId'=> $goodsId));
              foreach ($attributes as $row) {
                $row['ModelId'] = $data['ModelId'];
                $row['GoodsId'] = $goodsId;
                $this->conn->insert('GoodsAttribute', $row);
              }
            }

            if ($recommends) {
               $this->conn->delete('RecommendGoods', array('GoodsId'=> $goodsId));
              foreach ($recommends as $rec) {
                $rec['GoodsId'] = $goodsId;
                $this->conn->insert('RecommendGoods', $rec);
              }
            }

            if ($products) {
               $this->conn->delete('Products', array('GoodsId'=> $goodsId));
              foreach ($products as $product) {
                $product['GoodsId'] = $goodsId;
                $this->conn->insert('Products', $product);
              }
            }

            if ($companies) {
              $this->conn->delete('CompanyGoods', array('GoodsId'=> $goodsId));
              foreach ($companies as $com) {
                $com['GoodsId'] = $goodsId;
                $this->conn->insert('CompanyGoods', $com);
              }
            }

            $conn->commit();

            return $goodsId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

    public function update($goodsId, $data,$categories=null,$attributes=null, $products=null, $recommends=null, $companies=null)
    {
        /*
        try {
            return $this->conn->update('Goods', $data, array('GoodsId' => $goodsId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
        */

        $conn = $this->conn;
        $conn->beginTransaction();
        try {

            $this->conn->update('Goods', $data, array('GoodsId' => $goodsId));

            if ($categories) {
               $this->conn->delete('CategoryExtend', array('GoodsId'=> $goodsId));
              foreach ($categories as $cat) {
                $cat['GoodsId'] = $goodsId;
                $this->conn->insert('CategoryExtend', $cat);
              }
            }
            else
            {
                $this->conn->delete('CategoryExtend', array('GoodsId'=> $goodsId));
            }

            if ($attributes) {
              $this->conn->delete('GoodsAttribute', array('GoodsId'=> $goodsId));
              foreach ($attributes as $row) {
                $row['ModelId'] = $data['ModelId'];
                $row['GoodsId'] = $goodsId;
                $this->conn->insert('GoodsAttribute', $row);
              }
            }
            else
            {
                $this->conn->delete('GoodsAttribute', array('GoodsId'=> $goodsId));
            }

             if ($products) {
               $this->conn->delete('Products', array('GoodsId'=> $goodsId));
              foreach ($products as $product) {
                $product['GoodsId'] = $goodsId;
                $this->conn->insert('Products', $product);
              }
            }
            else
            {
                $this->conn->delete('Products', array('GoodsId'=> $goodsId));
            }

            if ($recommends) {
              $this->conn->delete('RecommendGoods', array('GoodsId'=> $goodsId));
              foreach ($recommends as $rec) {
                $rec['GoodsId'] = $goodsId;
                $this->conn->insert('RecommendGoods', $rec);
              }
            }
            else
            {
                $this->conn->delete('RecommendGoods', array('GoodsId'=> $goodsId));
            }

            if ($companies) {
              $this->conn->delete('CompanyGoods', array('GoodsId'=> $goodsId));
              foreach ($companies as $com) {
                $com['GoodsId'] = $goodsId;
                $this->conn->insert('CompanyGoods', $com);
              }
            }
            else
            {
                $this->conn->delete('CompanyGoods', array('GoodsId'=> $goodsId));
            }

            $conn->commit();

            return $goodsId;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

    public function delete($goodsId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE Goods SET IsDeleted = 1 WHERE GoodsId  = $goodsId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }
}
