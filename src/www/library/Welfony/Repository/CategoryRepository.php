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

class CategoryRepository extends AbstractRepository
{

    public function getAllCategoryCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Category
				   WHERE IsDeleted = 0
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllCategory()
    {
        $strSql = 'SELECT
                       *
                   FROM Category
				   WHERE IsDeleted = 0
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function listCategory($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "   SELECT Category.*,Model.Name AS ModelName
                      FROM Category Category
                      LEFT JOIN Model Model ON Category.ModelId = Model.ModelId
					  WHERE Category.IsDeleted = 0
                      ORDER BY CategoryId
                      LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findCateogryById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM Category
                   WHERE CategoryId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Category', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($categoryId, $data)
    {
        try {
            return $this->conn->update('Category', $data, array('CategoryId' => $categoryId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($cateogryId)
    {
        try {
            return $this->conn->executeUpdate(" UPDATE Category  SET IsDeleted = 1 WHERE CateogryId  = $categoryId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }


}
