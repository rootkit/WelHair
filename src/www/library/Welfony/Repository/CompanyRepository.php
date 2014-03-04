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

class CompanyRepository extends AbstractRepository
{

    public function getAllCompaniesCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Company
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllCompanies($page, $pageSize)
    {
        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       C.*,
                       PA.Name ProvinceName,
                       PC.Name CityName,
                       PD.Name DistrictName
                   FROM Company C
                   INNER JOIN Area PA ON PA.AreaId = C.Province
                   INNER JOIN Area PC ON PC.AreaId = C.City
                   INNER JOIN Area PD ON PD.AreaId = C.District
                   ORDER BY C.CompanyId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql);
    }

    public function findCompanyById($companyId)
    {
        $strSql = 'SELECT
                       C.*,
                       PA.Name ProvinceName,
                       PC.Name CityName,
                       PD.Name DistrictName
                   FROM Company C
                   INNER JOIN Area PA ON PA.AreaId = C.Province
                   INNER JOIN Area PC ON PC.AreaId = C.City
                   INNER JOIN Area PD ON PD.AreaId = C.District
                   WHERE C.CompanyId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($companyId));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Company', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($companyId, $data)
    {
        try {
            return $this->conn->update('Company', $data, array('CompanyId' => $companyId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
