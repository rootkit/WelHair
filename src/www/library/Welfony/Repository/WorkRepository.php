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

    public function getWorkDetail($currentUserId, $location, $workId)
    {
        $strSql = 'SELECT
                       W.*,

                       U.UserId StaffUserId,
                       U.AvatarUrl StaffAvatarUrl,
                       U.Nickname StaffNickname,

                       C.CompanyId,
                       C.Name CompanyName,
                       C.Address CompanyAddress,

                       (SELECT COUNT(1) FROM UserLike UL WHERE ? > 0 AND ? = UL.CreatedBy AND UL.WorkId = W.WorkId) IsLiked,
                       getDistance(C.Latitude, C.Longitude, ?, ?) Distance
                   FROM Work W
                   INNER JOIN CompanyUser CU ON CU.UserId = W.UserId
                   INNER JOIN Company C ON C.CompanyId = CU.CompanyId
                   INNER JOIN Users U ON U.UserId = CU.UserId
                   WHERE W.WorkId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($currentUserId, $currentUserId, $location['Latitude'], $location['Longitude'], $workId));
    }

    public function searchCount($city, $gender, $hairStyle)
    {
        $strSql = "SELECT
                     COUNT(1) `Total`
                   FROM Work W
                   INNER JOIN CompanyUser CU ON CU.UserId = W.UserId
                   INNER JOIN Company C ON C.CompanyId = CU.CompanyId
                   WHERE (? = 0 || C.City = ?) && (? = 0 || W.Gender = ?) && (? = 0 || W.HairStyle = ?)
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($city, $city, $gender, $gender, $hairStyle, $hairStyle));

        return $row['Total'];
    }

    public function search($currentUserId, $city, $gender, $hairStyle, $sort, $page, $pageSize)
    {
        $strSql = "CALL spWorkSearch(?, ?, ?, ?, ?, ?, ?);";

        return $this->conn->fetchAll($strSql, array($currentUserId, $city, $gender, $hairStyle, $sort, $page, $pageSize));
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
                       U.Nickname,
                       U.AvatarUrl
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

    public function remove($workId)
    {
        try {
            $this->conn->delete('Work', array('WorkId' => $workId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

}
