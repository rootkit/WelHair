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

    public function getAllStaffCount($companyId)
    {
        $filter = '';
        if ($companyId > 0) {
            $filter = "AND CU.CompanyId = $companyId";
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM CompanyUser CU
                   WHERE CU.UserId > 0 $filter
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllStaff($page, $pageSize, $companyId)
    {
        $filter = '';
        if ($companyId > 0) {
            $filter = "AND CU.CompanyId = $companyId";
        }

        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       U.*,
                       C.Name CompanyName,
                       CU.IsApproved,
                       CU.CreatedDate StaffCreatedDate
                   FROM CompanyUser CU
                   INNER JOIN Company C ON C.CompanyId = CU.CompanyId
                   INNER JOIN Users U ON U.UserId = CU.UserId
                   WHERE CU.UserId > 0 > 0 $filter
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

}
