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

    public function nearby($maxDistance, $location)
    {
        $strSql = "CALL spCompanyNearby(?, ?, ?);";

        return $this->conn->fetchAll($strSql, array($maxDistance, $location['Latitude'], $location['Longitude']));
    }

    public function searchCount($searchText, $city, $district)
    {
        $strSql = "SELECT
                     COUNT(1) `Total`
                   FROM Company C
                   WHERE C.Status = 1 AND (? = '' || C.Name LIKE ?) AND (? = 0 || C.City = ?) AND (? = 0 || C.District= ?)
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($searchText, "%$searchText%", $city, $city, $district, $district));

        return $row['Total'];
    }

    public function search($currentUserId, $searchText, $city, $district, $sort, $location, $page, $pageSize)
    {
        $strSql = "CALL spCompanySearch(?, ?, ?, ?, ?, ?, ?, ?, ?);";

        return $this->conn->fetchAll($strSql, array($currentUserId, $searchText, $city, $district, $sort, $location['Latitude'], $location['Longitude'], $page, $pageSize));
    }

    public function getAllCompaniesCount($status)
    {
        if (is_array($status)) {
            $status = implode(',', $status);
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Company C
                   WHERE C.Status IN ($status)
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllCompanies($status, $page, $pageSize)
    {
        if (is_array($status)) {
            $status = implode(',', $status);
        }

        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       C.*,
                       PA.Name ProvinceName,
                       PC.Name CityName,
                       IFNULL(PD.Name, '') DistrictName
                   FROM Company C
                   INNER JOIN Area PA ON PA.AreaId = C.Province
                   INNER JOIN Area PC ON PC.AreaId = C.City
                   LEFT OUTER JOIN Area PD ON PD.AreaId = C.District
                   WHERE C.Status IN ($status)
                   ORDER BY C.CompanyId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql);
    }

    public function listAllCompanies()
    {
        $strSql = "SELECT
                      *
                   FROM Company ";

        return $this->conn->fetchAll($strSql);
    }

    public function listAllCompaniesByGoods($goodsId)
    {
        $strSql = "SELECT
                      C.*
                   FROM CompanyGoods CG
                   INNER JOIN Company C ON CG.CompanyId = C.CompanyId
                   WHERE C.Status = 1 AND CG.GoodsId = $goodsId ";

        return $this->conn->fetchAll($strSql);
    }

    public function seachByNameAndPhone($searchText)
    {
        $strSql = "SELECT
                       C.*,
                       PA.Name ProvinceName,
                       PC.Name CityName,
                       IFNULL(PD.Name, '') DistrictName
                   FROM Company C
                   INNER JOIN Area PA ON PA.AreaId = C.Province
                   INNER JOIN Area PC ON PC.AreaId = C.City
                   LEFT OUTER JOIN Area PD ON PD.AreaId = C.District
                   WHERE C.Name LIKE '%$searchText%' OR C.Tel LIKE '%$searchText%' OR C.Mobile LIKE '%$searchText%'
                   ORDER BY C.CompanyId DESC
                   LIMIT 5";

        return $this->conn->fetchAll($strSql);
    }

    public function findCompanyById($companyId)
    {
        $strSql = "SELECT
                       C.*,
                       PA.Name ProvinceName,
                       PC.Name CityName,
                       IFNULL(PD.Name, '') DistrictName
                   FROM Company C
                   INNER JOIN Area PA ON PA.AreaId = C.Province
                   INNER JOIN Area PC ON PC.AreaId = C.City
                   LEFT OUTER JOIN Area PD ON PD.AreaId = C.District
                   WHERE C.CompanyId = ?
                   LIMIT 1";

        return $this->conn->fetchAssoc($strSql, array($companyId));
    }

    public function findCompanyDetailById($companyId, $currentUserId, $location)
    {
        $strSql = "SELECT
                       C.CompanyId,
                       C.Name CompanyName,
                       C.Address CompanyAddress,
                       C.Status CompanyStatus,
                       C.LogoUrl CompanyLogoUrl,
                       C.PictureUrl,
                       C.Tel,
                       C.Mobile,
                       C.Address,
                       C.Latitude,
                       C.Longitude,

                       CONCAT(PA.Name, ' ', PC.Name, ' ', IFNULL(PD.Name, '')) Region,

                       (SELECT COUNT(1) FROM UserLike UL WHERE ? > 0 AND ? = UL.CreatedBy AND UL.CompanyId = C.CompanyId) IsLiked,
                       getDistance(C.Latitude, C.Longitude, ?, ?) Distance

                   FROM Company C
                   INNER JOIN Area PA ON PA.AreaId = C.Province
                   INNER JOIN Area PC ON PC.AreaId = C.City
                   LEFT OUTER JOIN Area PD ON PD.AreaId = C.District
                   WHERE C.CompanyId = ?";

        return $this->conn->fetchAll($strSql, array($currentUserId, $currentUserId, $location ? $location['Latitude'] : 0, $location ? $location['Longitude'] : 0, $companyId));
    }

    public  function getCompanyBalance($companyId)
    {
       $strSql = 'SELECT Amount as `Amount` FROM Company
                   WHERE CompanyId = ?';
        $result = $this->conn->fetchAssoc($strSql, array($companyId));
        return $result['Amount'];
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

    public function getCompanyRevenueCount($companyId)
    {
        $filter = '';
        $paramArr = array($companyId);

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM CompanyBalanceLog CBL
                   WHERE CBL.CompanyId = ? AND IncomeSrc IN (1, 2, 5, 6) $filter
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, $paramArr);

        return $row['Total'];
    }

    public function getCompanyRevenue($companyId, $page, $pageSize)
    {
        $filter = '';
        $paramArr = array($companyId, $companyId);

        $offset = ($page - 1) * $pageSize;

        $strSql = "SELECT
                       *
                   FROM (
                      SELECT
                        CBL.CompanyId,
                        CBL.Amount,
                        CBL.CreateTime,
                        1 Type,
                        CASE
                        WHEN CBL.IncomeSrc = 2 THEN 1
                        ELSE 0
                        END Status,

                        Client.UserId ClientUserId,
                        Client.Nickname ClientNickname,
                        Client.AvatarUrl ClientAvatarUrl,

                        Staff.UserId StaffUserId,
                        Staff.Nickname StaffNickname,

                        A.ServiceTitle ServiceName
                      FROM CompanyBalanceLog CBL
                      INNER JOIN Appointment A ON A.AppointmentNo = CBL.IncomeSrcId
                      INNER JOIN Users Client ON Client.UserId = A.UserId
                      INNER JOIN Users Staff ON Staff.UserId = A.StaffId
                      WHERE CBL.CompanyId = ? AND CBL.IncomeSrc IN (2, 5)

                      UNION ALL

                      SELECT
                        CBL.CompanyId,
                        CBL.Amount,
                        CBL.CreateTime,
                        2 Type,
                        CASE
                        WHEN CBL.IncomeSrc = 1 THEN 1
                        ELSE 0
                        END Status,

                        Client.UserId ClientUserId,
                        Client.Nickname ClientNickname,
                        Client.AvatarUrl ClientAvatarUrl,

                        0 StaffUserId,
                        (SELECT G.Name FROM Goods G INNER JOIN OrderGoods OG ON OG.GoodsId = G.GoodsId WHERE OG.OrderId = O.OrderId LIMIT 1) StaffNickname,

                        '' ServiceName
                      FROM CompanyBalanceLog CBL
                      INNER JOIN `Order` O ON O.OrderNo = CBL.IncomeSrcId
                      INNER JOIN Users Client ON Client.UserId = O.UserId
                      WHERE CBL.CompanyId = ? AND CBL.IncomeSrc IN (1, 6)
                   ) AS TBL
                   ORDER BY TBL.CreateTime DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql, $paramArr);
    }

}
