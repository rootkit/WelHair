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

class UserRepository extends AbstractRepository
{

    public function getAllUsersCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Users
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllUsers($page, $pageSize)
    {
        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       *
                   FROM Users U
                   ORDER BY U.UserId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql);
    }

    public function findUserById($userId)
    {
        $strSql = 'SELECT
                       *
                   FROM Users U
                   WHERE U.UserId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($userId));
    }

    public function findUserByUsername($username)
    {
        $strSql = 'SELECT
                       *
                   FROM Users U
                   WHERE U.Username = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($username));
    }

    public function findUserByEmail($email)
    {
        $strSql = 'SELECT
                       *
                   FROM Users U
                   WHERE U.Email = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($email));
    }

    public function findUserByMobile($mobile)
    {
        $strSql = 'SELECT
                       *
                   FROM Users U
                   WHERE U.Mobile = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($mobile));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Users', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($userId, $data)
    {
        try {
            return $this->conn->update('Users', $data, array('UserId' => $userId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function seachByNameAndPhoneAndEmail($searchText)
    {
        $filter = "(U.Role = " . UserRole::Client . ") AND";

        $strSql = "SELECT
                       U.UserId,
                       U.Username,
                       U.Nickname,
                       U.AvatarUrl
                   FROM Users U
                   WHERE $filter (U.Username LIKE '%$searchText%' OR U.Nickname LIKE '%$searchText%' OR U.Email LIKE '%$searchText%' OR U.Mobile LIKE '%$searchText%')
                   LIMIT 5";

        return $this->conn->fetchAll($strSql);
    }

    public function remove($userId)
    {
        try {
            $this->conn->delete('Comment', array('CreatedBy' => $userId));
            $this->conn->delete('Comment', array('UserId' => $userId));
            $this->conn->delete('Work', array('UserId' => $userId));
            $this->conn->delete('Service', array('UserId' => $userId));
            $this->conn->delete('UserPoint', array('UserId' => $userId));
            $this->conn->delete('UserLike', array('UserId' => $userId));
            $this->conn->delete('CompanyUser', array('UserId' => $userId));
            $this->conn->delete('Users', array('UserId' => $userId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

}
