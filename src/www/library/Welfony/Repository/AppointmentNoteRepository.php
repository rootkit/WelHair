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

class AppointmentNoteRepository extends AbstractRepository
{

    public function getAllAppointmentNoteByStaffAndUserCount($staffId, $userId)
    {
        $filter = '';
        $paramArr = array();
        if ($staffId !== null) {
            $filter .= ' AND A.StaffId = ?';
            $paramArr[] = $staffId;
        }
        if ($userId !== null) {
            $filter .= ' AND A.UserId = ?';
            $paramArr[] = $userId;
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM AppointmentNote AN
                   INNER JOIN Appointment A ON A.AppointmentId = AN.AppointmentId
                   WHERE AN.AppointmentNoteId > 0 $filter
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, $paramArr);

        return $row['Total'];
    }

    public function getAllAppointmentNoteByStaffAndUser($staffId, $userId, $page, $pageSize)
    {
        $filter = '';
        $paramArr = array();
        if ($staffId !== null) {
            $filter .= ' AND A.StaffId = ?';
            $paramArr[] = $staffId;
        }
        if ($userId !== null) {
            $filter .= ' AND A.UserId = ?';
            $paramArr[] = $userId;
        }

        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       AN.AppointmentNoteId,
                       AN.Body,
                       AN.PictureUrl,
                       AN.CreatedDate,

                       U.UserId,
                       U.Username,
                       U.Nickname,
                       U.Email,
                       U.AvatarUrl
                   FROM AppointmentNote AN
                   INNER JOIN Appointment A ON A.AppointmentId = AN.AppointmentId
                   INNER JOIN Users U ON U.UserId = A.UserId
                   WHERE AN.AppointmentNoteId > 0 $filter
                   ORDER BY AN.AppointmentNoteId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql, $paramArr);
    }

    public function getAllAppointmentNoteCount($appointmentId)
    {
        $filter = '';
        $paramArr = array();
        if ($appointmentId !== null) {
            $filter .= ' AND AN.AppointmentId = ?';
            $paramArr[] = $appointmentId;
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM AppointmentNote AN
                   WHERE AN.AppointmentNoteId > 0 $filter
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, $paramArr);

        return $row['Total'];
    }

    public function getAllAppointmentNote($appointmentId, $page, $pageSize)
    {
        $filter = '';
        $paramArr = array();
        if ($appointmentId !== null) {
            $filter .= ' AND AN.AppointmentId = ?';
            $paramArr[] = $appointmentId;
        }

        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       AN.AppointmentNoteId,
                       AN.Body,
                       AN.PictureUrl,
                       AN.CreatedDate,

                       U.UserId,
                       U.Username,
                       U.Nickname,
                       U.Email,
                       U.AvatarUrl
                   FROM AppointmentNote AN
                   INNER JOIN Appointment A ON A.AppointmentId = AN.AppointmentId
                   INNER JOIN Users U ON U.UserId = A.UserId
                   WHERE AN.AppointmentNoteId > 0 $filter
                   ORDER BY AN.AppointmentNoteId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql, $paramArr);
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('AppointmentNote', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

}