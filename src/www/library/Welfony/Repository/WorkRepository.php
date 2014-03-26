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

class WorkRepository extends AbstractRepository
{

    public function search($area, $gender, $hairStyle, $sort, $page, $pageSize)
    {
        $strSql = "CALL spWorkSearch(?, ?, ?, ?, ?, ?);";
        return $this->conn->fetchAll($strSql, array($area, $gender, $hairStyle, $sort, $page, $pageSize));
    }

    public function getAllWorksCount($staffId)
    {
        $filter = '';
        if ($staffId > 0) {
            $filter = "AND W.UserId = $staffId";
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Work W
                   WHERE W.UserId > 0 $filter
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllWorks($page, $pageSize, $staffId)
    {
        $filter = '';
        if ($staffId > 0) {
            $filter = "AND W.UserId = $staffId";
        }

        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       W.*,
                       U.Nickname
                   FROM Work W
                   INNER JOIN Users U ON U.UserId = W.UserId
                   WHERE W.UserId > 0 $filter
                   ORDER BY W.WorkId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql);
    }

    public function findWorkById($workId)
    {
        $strSql = 'SELECT
                       W.*
                   FROM Work W
                   WHERE W.WorkId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($workId));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Work', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($workId, $data)
    {
        try {
            return $this->conn->update('Work', $data, array('WorkId' => $workId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
