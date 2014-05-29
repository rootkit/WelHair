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

    public function searchCount($searchText, $companyId, $city, $district)
    {
        $strSql = "SELECT
                     COUNT(1) `Total`
                   FROM Users U
                   INNER JOIN CompanyUser CU ON CU.UserId = U.UserId
                   INNER JOIN Company C ON CU.CompanyId = C.CompanyId
                   WHERE U.Role = 3 AND (? = '' || U.Nickname LIKE ? || U.Username LIKE ?) AND (? = 0 || CU.CompanyId = ?) AND (? = 0 || C.City = ?) AND (? = 0 || C.District= ?)
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($searchText, $searchText, $searchText, $companyId, $companyId, $city, $city, $district, $district));

        return $row['Total'];
    }

    public function search($currentUserId, $searchText, $companyId, $city, $district, $sort, $location, $page, $pageSize)
    {
        $strSql = "CALL spStaffSearch(?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";

        return $this->conn->fetchAll($strSql, array($currentUserId, $searchText, $companyId, $city, $district, $sort, $location['Latitude'], $location['Longitude'], $page, $pageSize));
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
                       U.Role,
                       U.EmailVerified,
                       U.Mobile,
                       U.MobileVerified,

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

                       IFNULL(CU.Status, 0) Status

                   FROM Users U
                   LEFT OUTER JOIN CompanyUser CU ON CU.UserId = U.UserId
                   LEFT OUTER JOIN Company C ON C.CompanyId = CU.CompanyId
                   LEFT OUTER JOIN Service S ON S.UserId = U.UserId
                   LEFT OUTER JOIN Work W ON W.UserId = U.UserId
                   WHERE $filter (U.Username LIKE '%$searchText%' OR U.Nickname LIKE '%$searchText%' OR U.Email LIKE '%$searchText%' OR U.Mobile LIKE '%$searchText%')
                   LIMIT 5";

        return $this->conn->fetchAll($strSql);
    }

    public function getAllClientCount($staffId)
    {
         $strSql = "SELECT
                       COUNT(DISTINCT A.UserId) `Total`
                   FROM Appointment A
                   WHERE A.Status > 0 AND A.StaffId = ?
                   GROUP BY A.UserId
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($staffId));

        return !$row['Total'] ? 0 : intval($row['Total']);
    }

    public function getAllClient($staffId, $page, $pageSize)
    {
        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       U.UserId,
                       U.Nickname,
                       U.Username,
                       U.AvatarUrl,
                       U.ProfileBackgroundUrl,

                       (SELECT COUNT(1) FROM Appointment AA WHERE AA.Status = 1 AND AA.UserId = A.UserId AND AA.StaffId = A.StaffId) CompletedAppointmentCount,
                       COUNT(A.AppointmentId) AppointmentCount
                   FROM Appointment A
                   INNER JOIN Users U ON U.UserId = A.UserId
                   WHERE A.Status > 0 AND A.StaffId = ?
                   GROUP BY A.UserId
                   ORDER BY CompletedAppointmentCount DESC, A.AppointmentId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql, array($staffId));
    }

    public function getMyStaffsCount($userId)
    {
         $strSql = "SELECT
                       COUNT(DISTINCT A.UserId) `Total`
                   FROM Appointment A
                   WHERE A.Status > 0 AND A.UserId = ?
                   GROUP BY A.StaffId
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($userId));

        return !$row['Total'] ? 0 : intval($row['Total']);
    }

    public function getMyStaffs($userId, $page, $pageSize)
    {
        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       U.UserId,
                       U.Nickname,
                       U.Username,
                       U.AvatarUrl,
                       U.ProfileBackgroundUrl,

                       COUNT(A.AppointmentId) AppointmentCount
                   FROM Appointment A
                   INNER JOIN Users U ON U.UserId = A.UserId
                   WHERE A.Status > 0 AND A.UserId = ?
                   GROUP BY A.StaffId
                   ORDER BY A.AppointmentId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql, array($userId));
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
                       U.ProfileBackgroundUrl,

                       C.CompanyId,
                       C.Name CompanyName,
                       C.Address CompanyAddress,
                       C.Status CompanyStatus,
                       C.LogoUrl CompanyLogoUrl,
                       C.PictureUrl CompanyPictureUrl,
                       C.Mobile CompanyMobile,
                       C.Tel CompanyTel,
                       C.City CompanyCity,
                       C.Latitude,
                       C.Longitude,
                       (SELECT
                           AVG(IFNULL(TBLRate.Rate, 0))
                        FROM ( SELECT
                                 CMC.CommentId,
                                 CMC.Rate,
                                 CMC.CompanyId
                               FROM Comment CMC
                               UNION
                               SELECT
                                 CMU.CommentId,
                                 CMU.Rate,
                                 CU.CompanyId
                               FROM Comment CMU
                               INNER JOIN CompanyUser CU ON CU.UserId = CMU.UserId
                               UNION
                               SELECT
                                 CMW.CommentId,
                                 CMW.Rate,
                                 CU.CompanyId
                               FROM Comment CMW
                               INNER JOIN Work W ON W.WorkId = CMW.WorkId
                               INNER JOIN CompanyUser CU ON CU.UserId = W.UserId
                        ) AS TBLRate
                        WHERE TBLRate.CompanyId = C.CompanyId
                       ) CompanyRate,

                       (SELECT
                            COUNT(1)
                        FROM Appointment A
                        WHERE A.StaffId = U.UserId AND A.Status = 2 AND A.IsLiked = 1) RateCount,

                       S.ServiceId,
                       S.Title ServiceTitle,
                       S.OldPrice,
                       S.Price,

                       W.WorkId,
                       W.Title WorkTitle,
                       W.PictureUrl WorkPictureUrl,

                       IFNULL(CU.Status, 0) Status,

                       (SELECT COUNT(1) FROM UserLike UL WHERE ? > 0 AND ? = UL.CreatedBy AND UL.UserId = U.UserId) IsLiked,
                       getDistance(C.Latitude, C.Longitude, ?, ?) Distance

                   FROM Users U
                   LEFT OUTER JOIN CompanyUser CU ON CU.UserId = U.UserId
                   LEFT OUTER JOIN Company C ON C.CompanyId = CU.CompanyId
                   LEFT OUTER JOIN Service S ON S.UserId = U.UserId
                   LEFT OUTER JOIN Work W ON W.UserId = U.UserId
                   WHERE U.Role IN (2, 3) AND U.UserId = ?';

        return $this->conn->fetchAll($strSql, array($currentUserId, $currentUserId, $location ? $location['Latitude'] : 0, $location ? $location['Longitude'] : 0, $staffId));
    }

}
