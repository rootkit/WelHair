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
