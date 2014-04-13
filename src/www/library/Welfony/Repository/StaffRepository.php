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

    public function searchCount($companyId, $city, $district)
    {
        $strSql = "SELECT
                     COUNT(1) `Total`
                   FROM Users U
                   INNER JOIN CompanyUser CU ON CU.UserId = U.UserId
                   INNER JOIN Company C ON CU.CompanyId = C.CompanyId
                   WHERE U.Role = 3 AND (? = 0 || CU.CompanyId = ?) AND (? = 0 || C.City = ?) AND (? = 0 || C.District= ?)
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($companyId, $companyId, $city, $city, $district, $district));

        return $row['Total'];
    }

    public function search($currentUserId, $companyId, $city, $district, $sort, $location, $page, $pageSize)
    {
        $strSql = "CALL spStaffSearch(?, ?, ?, ?, ?, ?, ?, ?, ?);";

        return $this->conn->fetchAll($strSql, array($currentUserId, $companyId, $city, $district, $sort, $location['Latitude'], $location['Longitude'], $page, $pageSize));
    }

    public function seachByNameAndPhoneAndEmail($searchText, $includeClient)
    {
        $filter = '';
        if ($includeClient) {
            $filter = "((U.Role = " . UserRole::Staff . ") OR (U.Role = " . UserRole::Client . ")) AND";
        } else {
            $filter = "(U.Role = " . UserRole::Staff . ") AND";
        }

        $strSql = "SELECT
                       U.UserId,
                       U.Username,
                       U.Nickname,
                       U.AvatarUrl,
                       U.Email,
                       U.EmailVerified,
                       U.Mobile,
                       U.MobileVerified,

                       C.CompanyId,
                       C.Name CompanyName,
                       C.Address CompanyAddress,
                       C.Status CompanyStatus,

                       S.ServiceId,
                       S.Title ServiceTitle,
                       S.OldPrice,
                       S.Price,

                       W.WorkId,
                       W.Title WorkTitle,
                       W.PictureUrl WorkPictureUrl,

                       CU.IsApproved

                   FROM Users U
                   LEFT OUTER JOIN CompanyUser CU ON CU.UserId = U.UserId
                   LEFT OUTER JOIN Company C ON C.CompanyId = CU.CompanyId
                   LEFT OUTER JOIN Service S ON S.UserId = U.UserId
                   LEFT OUTER JOIN Work W ON W.UserId = U.UserId
                   WHERE $filter (U.Username LIKE '%$searchText%' OR U.Nickname LIKE '%$searchText%' OR U.Email LIKE '%$searchText%' OR U.Mobile LIKE '%$searchText%')
                   LIMIT 5";

        return $this->conn->fetchAll($strSql);
    }

    public function findStaffDetailById($staffId, $currentUserId, $location)
    {
        $strSql = 'SELECT
                       U.UserId,
                       U.Username,
                       U.Nickname,
                       U.AvatarUrl,
                       U.Email,
                       U.EmailVerified,
                       U.Mobile,
                       U.MobileVerified,
                       U.Role,

                       C.CompanyId,
                       C.Name CompanyName,
                       C.Address CompanyAddress,
                       C.Status CompanyStatus,
                       C.LogoUrl CompanyLogoUrl,

                       S.ServiceId,
                       S.Title ServiceTitle,
                       S.OldPrice,
                       S.Price,

                       W.WorkId,
                       W.Title WorkTitle,
                       W.PictureUrl WorkPictureUrl,

                       IFNULL(CU.IsApproved, 0) IsApproved,

                       (SELECT COUNT(1) FROM UserLike UL WHERE ? > 0 AND ? = UL.CreatedBy AND UL.WorkId = W.WorkId) IsLiked,
                       getDistance(C.Latitude, C.Longitude, ?, ?) Distance

                   FROM Users U
                   LEFT OUTER JOIN CompanyUser CU ON CU.UserId = U.UserId
                   LEFT OUTER JOIN Company C ON C.CompanyId = CU.CompanyId
                   LEFT OUTER JOIN Service S ON S.UserId = U.UserId
                   LEFT OUTER JOIN Work W ON W.UserId = U.UserId
                   WHERE U.UserId = ?';

        return $this->conn->fetchAll($strSql, array($currentUserId, $currentUserId, $location ? $location['Latitude'] : 0, $location ? $location['Longitude'] : 0, $staffId));
    }

}
