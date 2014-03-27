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

use Welfony\Core\Enum\UserRole;
use Welfony\Repository\Base\AbstractRepository;

class StaffRepository extends AbstractRepository
{

    public function searchCount($city, $district)
    {
        $strSql = "SELECT
                     COUNT(1) `Total`
                   FROM Users U
                   INNER JOIN CompanyUser CU ON CU.UserId = U.UserId
                   INNER JOIN Company C ON CU.CompanyId = C.CompanyId
                   WHERE (? = 0 || C.City = ?) && (? = 0 || C.District= ?)
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($city, $city, $district, $district));

        return $row['Total'];
    }

    public function search($city, $district, $sort, $location, $page, $pageSize)
    {
        $strSql = "CALL spStaffSearch(?, ?, ?, ?, ?, ?, ?);";
        return $this->conn->fetchAll($strSql, array($city, $district, $sort, $location['Latitude'], $location['Longitude'], $page, $pageSize));
    }

    public function seachByNameAndPhoneAndEmail($searchText, $includeClient)
    {
        $filter = '';
        if ($includeClient) {
            $filter = "(U.Role = " . UserRole::Staff . " OR U.Role = " . UserRole::Client . ") AND";
        } else {
            $filter = "(U.Role = " . UserRole::Staff . ") AND";
        }

        $strSql = "SELECT
                       U.UserId,
                       U.Username,
                       U.Nickname,
                       U.AvatarUrl,

                       C.CompanyId,
                       C.Name CompanyName,
                       C.Address CompanyAddress,

                       S.ServiceId,
                       S.Title ServiceTitle,
                       S.OldPrice,
                       S.Price,

                       W.WorkId,
                       W.Title WorkTitle,
                       W.PictureUrl WorkPictureUrl

                   FROM Users U
                   LEFT OUTER JOIN CompanyUser CU ON CU.UserId = U.UserId
                   LEFT OUTER JOIN Company C ON C.CompanyId = CU.CompanyId
                   LEFT OUTER JOIN Service S ON S.UserId = U.UserId
                   LEFT OUTER JOIN Work W ON W.UserId = U.UserId
                   WHERE $filter (U.Username LIKE '%$searchText%' OR U.Nickname LIKE '%$searchText%' OR U.Email LIKE '%$searchText%' OR U.Mobile LIKE '%$searchText%')
                   LIMIT 5";

        return $this->conn->fetchAll($strSql);
    }

    public function findStaffDetailById($staffId)
    {
        $strSql = 'SELECT
                       U.UserId,
                       U.Username,
                       U.Nickname,
                       U.AvatarUrl,

                       C.CompanyId,
                       C.Name CompanyName,
                       C.Address CompanyAddress,

                       S.ServiceId,
                       S.Title ServiceTitle,
                       S.OldPrice,
                       S.Price,

                       W.WorkId,
                       W.Title WorkTitle,
                       W.PictureUrl WorkPictureUrl

                   FROM Users U
                   LEFT OUTER JOIN CompanyUser CU ON CU.UserId = U.UserId
                   LEFT OUTER JOIN Company C ON C.CompanyId = CU.CompanyId
                   LEFT OUTER JOIN Service S ON S.UserId = U.UserId
                   LEFT OUTER JOIN Work W ON W.UserId = U.UserId
                   WHERE U.UserId = ? AND U.Role = 3';

        return $this->conn->fetchAll($strSql, array($staffId));
    }

}
