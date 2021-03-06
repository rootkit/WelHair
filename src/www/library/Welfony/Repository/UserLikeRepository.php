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

class UserLikeRepository extends AbstractRepository
{

    public function listLikedUserCount($currentUserId)
    {
        $strSql = "SELECT
                     COUNT(1) `Total`
                   FROM Users U
                   INNER JOIN UserLike UL ON UL.UserId = U.UserId
                   WHERE UL.CreatedBy = ?
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($currentUserId));

        return $row['Total'];
    }

    public function listLikedUser($currentUserId, $location, $page, $pageSize)
    {
        $strSql = "CALL spListLikedStaff(?, ?, ?, ?, ?);";

        return $this->conn->fetchAll($strSql, array($currentUserId, $location['Latitude'], $location['Longitude'], $page, $pageSize));
    }

    public function listLikedCompanyCount($currentUserId)
    {
        $strSql = "SELECT
                     COUNT(1) `Total`
                   FROM Company C
                   INNER JOIN UserLike UL ON UL.CompanyId = C.CompanyId
                   WHERE C.Status = 1 AND UL.CreatedBy = ?
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($currentUserId));

        return $row['Total'];
    }

    public function listLikedCompany($currentUserId, $location, $page, $pageSize)
    {
        $strSql = "CALL spListLikedCompany(?, ?, ?, ?, ?);";

        return $this->conn->fetchAll($strSql, array($currentUserId, $location['Latitude'], $location['Longitude'], $page, $pageSize));
    }

    public function listLikedWorkCount($currentUserId)
    {
        $strSql = "SELECT
                     COUNT(1) `Total`
                   FROM Work W
                   INNER JOIN UserLike UL ON UL.WorkId = W.WorkId
                   WHERE UL.CreatedBy = ?
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, array($currentUserId));

        return $row['Total'];
    }

    public function listLikedWork($currentUserId, $page, $pageSize)
    {
        $strSql = "CALL spListLikedWork(?, ?, ?);";

        return $this->conn->fetchAll($strSql, array($currentUserId, $page, $pageSize));
    }

    public function findByUserAndWorkId($createdBy, $workId)
    {
        $strSql = 'SELECT
                       *
                   FROM UserLike UL
                   WHERE UL.CreatedBy = ? AND UL.WorkId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($createdBy, $workId));
    }

    public function findByUserAndUserId($createdBy, $userId)
    {
        $strSql = 'SELECT
                       *
                   FROM UserLike UL
                   WHERE UL.CreatedBy = ? AND UL.UserId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($createdBy, $userId));
    }

    public function findByUserAndCompanyId($createdBy, $companyId)
    {
        $strSql = 'SELECT
                       *
                   FROM UserLike UL
                   WHERE UL.CreatedBy = ? AND UL.CompanyId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($createdBy, $companyId));
    }

    public function findByUserAndGoodsId($createdBy, $goodsId)
    {
        $strSql = 'SELECT
                       *
                   FROM UserLike UL
                   WHERE UL.CreatedBy = ? AND UL.GoodsId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($createdBy, $goodsId));
    }

    public function removeByUserAndWorkId($createdBy, $workId)
    {
        try {
            $this->conn->delete('UserLike', array('CreatedBy' => $createdBy, 'WorkId' => $workId));

            return true;
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function removeByUserAndUserId($createdBy, $userId)
    {
        try {
            $this->conn->delete('UserLike', array('CreatedBy' => $createdBy, 'UserId' => $userId));

            return true;
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function removeByUserAndCompanyId($createdBy, $companyId)
    {
        try {
            $this->conn->delete('UserLike', array('CreatedBy' => $createdBy, 'CompanyId' => $companyId));

            return true;
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function removeByUserAndGoodsId($createdBy, $goodsId)
    {
        try {
            $this->conn->delete('UserLike', array('CreatedBy' => $createdBy, 'GoodsId' => $goodsId));

            return true;
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('UserLike', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($userLikeId, $data)
    {
        try {
            return $this->conn->update('UserLike', $data, array('UserLikeId' => $userLikeId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
