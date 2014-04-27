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

    public function listLikedGoodsCount($userId)
    {
        $strSql = "SELECT
                     COUNT(DISTINCT(G.GoodsId)) `Total`
                   FROM Goods G
                   INNER JOIN UserLike UL ON UL.GoodsId = G.GoodsId
                   LEFT OUTER JOIN CompanyGoods CG ON CG.GoodsId = G.GoodsId
                   LEFT OUTER JOIN Company C ON C.CompanyId = CG.CompanyId
                   WHERE C.Status = 1 AND G.IsDeleted = 0 AND UL.CreatedBy = ?
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($userId));

        return $row['Total'];
    }

    public function listLikedGoods($userId, $page, $pageSize)
    {
        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                      G.GoodsId,
                      G.Name,
                      G.SellPrice,
                      G.Img,

                      C.CompanyId,
                      C.Name CompanyName,
                      C.LogoUrl,
                      C.PictureUrl,
                      C.Tel,
                      C.Mobile,
                      C.Address,
                      C.Latitude,
                      C.Longitude
                   FROM Goods G
                   INNER JOIN UserLike UL ON UL.GoodsId = G.GoodsId
                   LEFT OUTER JOIN CompanyGoods CG ON CG.GoodsId = G.GoodsId
                   LEFT OUTER JOIN Company C ON C.CompanyId = CG.CompanyId
                   WHERE C.Status = 1 AND G.IsDeleted = 0 AND UL.CreatedBy = ?
                   GROUP BY G.GoodsId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql, array($userId));
    }

    public function listByCompanyCount($companyId)
    {
        $strSql = "SELECT
                     COUNT(1) `Total`
                   FROM Goods G
                   INNER JOIN CompanyGoods CG ON CG.GoodsId = G.GoodsId
                   INNER JOIN Company C ON C.CompanyId = CG.CompanyId
                   WHERE C.Status = 1 AND G.IsDeleted = 0 AND C.CompanyId = ?
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($companyId));

        return $row['Total'];
    }

    public function listByCompany($companyId, $page, $pageSize)
    {
        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                      G.GoodsId,
                      G.Name,
                      G.SellPrice,
                      G.Img,

                      C.CompanyId,
                      C.Name CompanyName,
                      C.LogoUrl,
                      C.PictureUrl,
                      C.Tel,
                      C.Mobile,
                      C.Address,
                      C.Latitude,
                      C.Longitude
                   FROM Goods G
                   INNER JOIN CompanyGoods CG ON CG.GoodsId = G.GoodsId
                   INNER JOIN Company C ON C.CompanyId = CG.CompanyId
                   WHERE C.Status = 1 AND G.IsDeleted = 0 AND C.CompanyId = ?
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql, array($companyId));
    }

    public function searchCount($searchText, $city, $district)
    {
        $strSql = "SELECT
                     COUNT(1) `Total`
                   FROM Goods G
                   LEFT OUTER JOIN CompanyGoods CG ON CG.GoodsId = G.GoodsId
                   LEFT OUTER JOIN Company C ON C.CompanyId = CG.CompanyId
                   WHERE C.Status = 1 AND G.IsDeleted = 0 AND (? = '' || G.Name LIKE ? || C.Name Like ?) AND (? = 0 || C.City = ?) AND (? = 0 || C.District= ?)
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($searchText, "%$searchText%", "%$searchText%", $city, $city, $district, $district));

        return $row['Total'];
    }

    public function search($currentUserId, $searchText, $city, $district, $sort, $location, $page, $pageSize)
    {
        $strSql = "CALL spGoodsSearch(?, ?, ?, ?, ?, ?, ?, ?, ?);";

        return $this->conn->fetchAll($strSql, array($currentUserId, $searchText, $city, $district, $sort, $location['Latitude'], $location['Longitude'], $page, $pageSize));
    }

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
                     CASE
                        WHEN P.SellPrice IS NULL THEN G.SellPrice
                        ELSE P.SellPrice
                     END AS SellPrice,

                     CASE
                        WHEN P.CostPrice IS NULL THEN G.CostPrice
                        ELSE P.CostPrice
                     END AS CostPrice,
                     CASE
                        WHEN P.Weight IS NULL THEN G.Weight
                        ELSE P.Weight
                     END AS Weight,
                     P.ProductsNo,
                     G.Unit,
                     P.SpecArray,
                     G.Img,
                     P.ProductsId,
                     C.CompanyId,
                     C.Name AS CompanyName
                     FROM Goods G

                     LEFT JOIN Products P ON G.GoodsId = P.GoodsId
                     LEFT JOIN CompanyGoods CG ON G.GoodsId = CG.GoodsId
                     LEFT JOIN Company C ON CG.CompanyId = C.CompanyId
                     WHERE G.IsDeleted = 0
                     LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findGoodsDetailById($goodsId, $currentUserId)
    {

        $strSql = 'SELECT
                       *,
                      (SELECT COUNT(1) FROM UserLike UL WHERE ? > 0 AND ? = UL.CreatedBy AND UL.GoodsId = G.GoodsId) IsLiked
                   FROM Goods G
                   WHERE G.GoodsId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($currentUserId, $currentUserId, $goodsId));
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
            } else {
                $this->conn->delete('CategoryExtend', array('GoodsId'=> $goodsId));
            }

            if ($attributes) {
              $this->conn->delete('GoodsAttribute', array('GoodsId'=> $goodsId));
              foreach ($attributes as $row) {
                $row['ModelId'] = $data['ModelId'];
                $row['GoodsId'] = $goodsId;
                $this->conn->insert('GoodsAttribute', $row);
              }
            } else {
                $this->conn->delete('GoodsAttribute', array('GoodsId'=> $goodsId));
            }

             if ($products) {
               $this->conn->delete('Products', array('GoodsId'=> $goodsId));
              foreach ($products as $product) {
                $product['GoodsId'] = $goodsId;
                $this->conn->insert('Products', $product);
              }
            } else {
                $this->conn->delete('Products', array('GoodsId'=> $goodsId));
            }

            if ($recommends) {
              $this->conn->delete('RecommendGoods', array('GoodsId'=> $goodsId));
              foreach ($recommends as $rec) {
                $rec['GoodsId'] = $goodsId;
                $this->conn->insert('RecommendGoods', $rec);
              }
            } else {
                $this->conn->delete('RecommendGoods', array('GoodsId'=> $goodsId));
            }

            if ($companies) {
              $this->conn->delete('CompanyGoods', array('GoodsId'=> $goodsId));
              foreach ($companies as $com) {
                $com['GoodsId'] = $goodsId;
                $this->conn->insert('CompanyGoods', $com);
              }
            } else {
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
