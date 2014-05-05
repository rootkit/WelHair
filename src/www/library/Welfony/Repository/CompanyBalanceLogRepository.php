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

class CompanyBalanceLogRepository extends AbstractRepository
{

    public function getAllCompanyBalanceLog()
    {
        $strSql = 'SELECT
                       *
                   FROM CompanyBalanceLog
                  ';

        return $this->conn->fetchAll($strSql);
    }

    public function getAllCompanyBalanceLogCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM CompanyBalanceLog";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function listCompanyBalanceLog($pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM CompanyBalanceLog
                   ORDER BY CompanyBalanceLogId
                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function getAllCompanyBalanceLogCountByCompany($companyId)
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM CompanyBalanceLog
                   WHERE CompanyId = $companyId";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function listCompanyBalanceLogByCompany($companyId, $pageNumber, $pageSize)
    {

        $offset = ($pageNumber - 1) * $pageSize;
        $strSql = "SELECT *
                   FROM CompanyBalanceLog
                   WHERE CompanyId = $companyId
                   ORDER BY CompanyBalanceLogId

                   LIMIT $offset, $pageSize ";

        return $this->conn->fetchAll($strSql);

    }

    public function findCompanyBalanceLogById($id)
    {
        $strSql = 'SELECT
                       *
                   FROM CompanyBalanceLog
                   WHERE CompanyBalanceLogId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('CompanyBalanceLog', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($companyBalanceLogId, $data)
    {
        try {
            $r= $this->conn->update('CompanyBalanceLog', $data, array('CompanyBalanceLogId' => $companyBalanceLogId));

            return $r;
        } catch (\Exception $e) {

            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function delete($companyBalanceLogId)
    {
        try {
            return $this->conn->delete("CompanyBalanceLog",array('CompanyBalanceLogId' => $companyBalanceLogId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }


}
