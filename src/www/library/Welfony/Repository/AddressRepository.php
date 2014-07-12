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

class AddressRepository extends AbstractRepository
{

    public function findAddressById($addressId)
    {
        $strSql = 'SELECT
                       A.*
                   FROM Address A
                   WHERE A.AddressId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($addressId));
    }

    public function updateAddressByUser($userId, $data)
    {
        try {
            return $this->conn->update('Address', $data, array('UserId' => $userId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function getAllAddressesByUser($userId)
    {
        $filter = '';
        if ($userId > 0) {
            $filter = "AND A.UserId = $userId";
        }

        $strSql = "SELECT
                       A.*,
                       CONCAT(PA.Name, ' ', PC.Name, ' ', IFNULL(PD.Name, '')) Area
                   FROM Address A
                   INNER JOIN Area PA ON PA.AreaId = A.Province
                   INNER JOIN Area PC ON PC.AreaId = A.City
                   LEFT OUTER JOIN Area PD ON PD.AreaId = A.District
                   WHERE A.AddressId > 0 $filter
                   ORDER BY A.AddressId DESC";

        return $this->conn->fetchAll($strSql);
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Address', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($addressId, $data)
    {
        try {
            return $this->conn->update('Address', $data, array('AddressId' => $addressId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

    public function remove($addressId)
    {
        try {
            $this->conn->delete('Address', array('AddressId' => $addressId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

}
