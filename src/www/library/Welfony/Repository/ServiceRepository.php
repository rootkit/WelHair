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

class ServiceRepository extends AbstractRepository
{

    public function getAllServicesCount($staffId)
    {
        $filter = '';
        if ($staffId > 0) {
            $filter = "AND S.UserId = $staffId";
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Service S
                   WHERE S.UserId > 0 $filter
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllServices($page, $pageSize, $staffId)
    {
        $filter = '';
        if ($staffId > 0) {
            $filter = "AND S.UserId = $staffId";
        }

        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       S.*,
                       U.Nickname
                   FROM Service S
                   INNER JOIN Users U ON U.UserId = S.UserId
                   WHERE S.UserId > 0 $filter
                   ORDER BY S.ServiceId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql);
    }

    public function findServiceByTitleAndStaff($serviceTitle, $staffId)
    {
        $strSql = 'SELECT
                       S.*
                   FROM Service S
                   WHERE S.UserId = ? AND S.Title = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($staffId, $serviceTitle));
    }

    public function findServiceById($serviceId)
    {
        $strSql = 'SELECT
                       S.*
                   FROM Service S
                   WHERE S.ServiceId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($serviceId));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Service', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($serviceId, $data)
    {
        try {
            return $this->conn->update('Service', $data, array('ServiceId' => $serviceId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function remove($serviceId)
    {
        try {
            $this->conn->delete('Service', array('ServiceId' => $serviceId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

}
