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

class BrandCategoryRepository extends AbstractRepository
{

    public function getAllBrandCategoryCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM BrandCategory
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        error_log($row['Total']);

        return $row['Total'];
    }

    public function getAllBrandCategory()
    {
        $strSql = 'SELECT
                       *
                   FROM BrandCategory
                  ';

        return $this->conn->fetchAssoc($strSql);
    }

    public function listBrandCategory( $pageNumber, $pageSize )
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                FROM BrandCategory
                      ORDER BY BrandCategoryId
                      LIMIT $offset, $pageSize ";

        return $this->conn->fetchAssoc($strSql);

    }

    public function findCategoryById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM BrandCategory BC
                   WHERE BC.BrandCategoryId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('BrandCategory', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);
            return false;
        }

        return false;
    }

    public function update($brandCategoryId, $data)
    {
        try {
            return $this->conn->update('BrandCategory', $data, array('BrandCategoryId' => $brandCategoryId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);
            return false;
        }
    }

    public function delete($brandCategoryId)
    {
        try {
            return $this->conn->executeUpdate(" DELETE FROM BrandCategory WHERE BrandCategoryId  = $brandCategoryId; ");
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);
            return false;
        }
    }

}