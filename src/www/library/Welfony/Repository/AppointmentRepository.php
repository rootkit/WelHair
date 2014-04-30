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

class AppointmentRepository extends AbstractRepository
{

    public function getAllAppointmentsCount($staffId, $userId, $status)
    {
        $filter = '';
        if ($staffId > 0) {
            $filter = "AND A.StaffId = $staffId";
        }
        if ($userId > 0) {
            $filter = "AND A.UserId = $userId";
        }
        if (is_array($status)) {
            $inStatus = implode(',', $status);
            $filter = "AND A.Status IN ($inStatus)";
        } else {
          if ($status >= 0) {
              $filter = "AND A.Status = $status";
          }
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Appointment A
                   WHERE A.UserId > 0 $filter
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllAppointments($page, $pageSize, $staffId, $userId, $status)
    {
        $filter = '';
        if ($staffId > 0) {
            $filter .= "AND A.StaffId = $staffId";
        }
        if ($userId > 0) {
            $filter .= "AND A.UserId = $userId";
        }
        if (is_array($status)) {
            $inStatus = implode(',', $status);
            $filter .= "AND A.Status IN ($inStatus)";
        } else {
          if ($status >= 0) {
              $filter .= "AND A.Status = $status";
          }
        }

        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       A.AppointmentId,
                       A.Status,
                       A.AppointmentDate,
                       A.LastModifiedBy,
                       A.CreatedDate,

                       A.CompanyId,
                       A.CompanyName,
                       A.CompanyAddress,

                       A.StaffId,
                       IFNULL(S.Nickname, A.StaffName) StaffName,
                       S.AvatarUrl StaffAvatarUrl,

                       U.UserId,
                       U.Nickname,
                       U.Username,
                       U.AvatarUrl,

                       A.ServiceId,
                       A.ServiceTitle,
                       A.Price,

                       A.PaymentTransactionId
                   FROM Appointment A
                   INNER JOIN Users U ON U.UserId = A.UserId
                   INNER JOIN Users S ON S.UserId = A.StaffId
                   WHERE A.UserId > 0 $filter
                   ORDER BY A.AppointmentId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql);
    }

    public function findAppointmentById($appointmentId)
    {
        $strSql = 'SELECT
                       A.*
                   FROM Appointment A
                   WHERE A.AppointmentId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($appointmentId));
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Appointment', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($appointmentId, $data)
    {
        try {
            return $this->conn->update('Appointment', $data, array('AppointmentId' => $appointmentId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
