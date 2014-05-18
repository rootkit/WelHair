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

class CompanyUserRepository extends AbstractRepository
{

    public function getAllStaffCount($companyId, $status)
    {
        $filter = '';
        if ($companyId > 0) {
            $filter .= " AND CU.CompanyId = $companyId";
        }
        if ($status !== null) {
            if (is_array($status)) {
                $filter .= " AND CU.Status IN (" . implode(',', $status) . ")";
            } else {
                $filter .= " AND CU.Status = '$status'";
            }
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM CompanyUser CU
                   WHERE CU.UserId > 0 $filter
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllStaff($companyId, $status, $page, $pageSize)
    {
        $filter = '';
        if ($companyId > 0) {
            $filter .= " AND CU.CompanyId = $companyId";
        }
        if ($status !== null) {
            if (is_array($status)) {
                $filter .= " AND CU.Status IN (" . implode(',', $status) . ")";
            } else {
                $filter .= " AND CU.Status = '$status'";
            }
        }

        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       U.*,
                       C.Name CompanyName,
                       CU.CompanyUserId,
                       CU.Status,
                       CU.CreatedDate StaffCreatedDate
                   FROM CompanyUser CU
                   INNER JOIN Company C ON C.CompanyId = CU.CompanyId
                   INNER JOIN Users U ON U.UserId = CU.UserId
                   WHERE CU.UserId > 0 $filter
                   ORDER BY CU.CompanyUserId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql);
    }

    public function findByUserAndCompany($userId, $companyId)
    {
        $strSql = 'SELECT
                       *
                   FROM CompanyUser CU
                   WHERE CU.CompanyId = ? AND CU.UserId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($companyId, $userId));
    }

    public function findByUser($userId)
    {
        $strSql = 'SELECT
                       *
                   FROM CompanyUser CU
                   WHERE CU.UserId = ?
                   ORDER BY CU.CompanyUserId DESC
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($userId));
    }

    public function findById($companyUserId)
    {
        $strSql = 'SELECT
                       *
                   FROM CompanyUser CU
                   WHERE CU.CompanyUserId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($companyUserId));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('CompanyUser', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($companyUserId, $data)
    {
        try {
            return $this->conn->update('CompanyUser', $data, array('CompanyUserId' => $companyUserId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function remove($companyUserId)
    {
        try {
            $this->conn->delete('CompanyUser', array('CompanyUserId' => $companyUserId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

}
