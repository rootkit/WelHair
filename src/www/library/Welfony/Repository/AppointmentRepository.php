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

use Welfony\Core\Enum\AppointmentStatus;
use Welfony\Repository\Base\AbstractRepository;
use Welfony\Repository\CompanyBalanceLogRepository;
use Welfony\Repository\UserBalanceLogRepository;

class AppointmentRepository extends AbstractRepository
{

    public function getAllAppointmentsCount($staffId, $userId, $status)
    {
        $filter = '';
        if ($staffId > 0) {
            $filter .= " AND A.StaffId = $staffId";
        }
        if ($userId > 0) {
            $filter .= " AND A.UserId = $userId";
        }
        if (is_array($status)) {
            $inStatus = implode(',', $status);
            $filter .= " AND A.Status IN ($inStatus)";
        } else {
          if ($status >= 0) {
              $filter .= " AND A.Status = $status";
          }
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Appointment A
                   INNER JOIN Users U ON U.UserId = A.UserId
                   INNER JOIN Users S ON S.UserId = A.StaffId
                   WHERE A.UserId > 0 $filter
                   LIMIT 1";


        $row = $this->conn->fetchAssoc($strSql);
        return $row['Total'];
    }

    public function getAllAppointments($page, $pageSize, $staffId, $userId, $status)
    {

        $filter = '';
        if ($staffId > 0) {
            $filter .= " AND A.StaffId = $staffId";
        }
        if ($userId > 0) {
            $filter .= " AND A.UserId = $userId";
        }
        if (is_array($status)) {
            $inStatus = implode(',', $status);
            $filter .= " AND A.Status IN ($inStatus)";
        } else {
          if ($status >= 0) {
              $filter .= " AND A.Status = $status";
          }
        }
        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       A.AppointmentId,
                       A.AppointmentNo,
                       A.Status,
                       A.AppointmentDate,
                       A.LastModifiedBy,
                       A.CreatedDate,

                       A.CompanyId,
                       A.CompanyName,
                       A.CompanyAddress,
                       CONCAT(PA.Name, ' ', PC.Name, ' ', IFNULL(PD.Name, '')) CompanyArea,

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
                       A.IsLiked
                   FROM Appointment A
                   INNER JOIN Users U ON U.UserId = A.UserId
                   INNER JOIN Users S ON S.UserId = A.StaffId
                   INNER JOIN Company C ON C.CompanyId = A.CompanyId
                   INNER JOIN Area PA ON PA.AreaId = C.Province
                   INNER JOIN Area PC ON PC.AreaId = C.City
                   LEFT OUTER JOIN Area PD ON PD.AreaId = C.District
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
        $conn = $this->conn;
        $conn->beginTransaction();

        try {
            if ($conn->insert('Appointment', $data)) {
                  $newId = $conn->lastInsertId();
                  if (intval($data['Status']) == AppointmentStatus::Paid) {
                      $companyId = $data['CompanyId'];
                      $userId = $data['UserId'];
                      $price = $data['Price'];

                      $existedCompanyBalanceLog = CompanyBalanceLogRepository::getInstance()->findCompanyBalanceLogByIncomeSrc(2, $data['AppointmentNo']);
                      if (!$existedCompanyBalanceLog) {
                        $this->conn->executeUpdate("
                            UPDATE `Company` SET Amount = Amount + $price WHERE CompanyId  = $companyId;
                        ");
                        $conn->insert('CompanyBalanceLog', array(
                          'CompanyId' => $data['CompanyId'],
                          'Amount' => $price,
                          'IncomeSrc' => 2,
                          'IncomeSrcId' => $data['AppointmentNo'],
                          'CreateTime'=> date('Y-m-d H:i:s'),
                          'Status' => 1,
                          'Description' => sprintf('预约【%s】付款%.2f元', $data['AppointmentNo'], $data['Price'])
                        ));
                      }

                      $existedUserBalanceLog = UserBalanceLogRepository::getInstance()->findUserBalanceLogByIncomeSrc(2, $data['AppointmentNo']);
                      if (!$existedUserBalanceLog) {
                        $this->conn->executeUpdate("
                            UPDATE `Users` SET Balance = Balance - $price WHERE UserId  = $userId;
                        ");

                        $this->conn->insert('UserBalanceLog', array(
                            'UserId' => $userId,
                            'Amount' => -$price,
                            'IncomeSrc' => 2,
                            'IncomeSrcId' => $data['AppointmentNo'],
                            'CreateTime'=> date('Y-m-d H:i:s'),
                            'Status' => 1,
                            'Description'=> sprintf('预约【%s】付款%.2f元', $data['AppointmentNo'], $data['Price'])
                        ));
                      }
                  }
                  $conn->commit();

                  return $newId;
            }
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($appointmentId, $data)
    {
        $conn = $this->conn;
        $conn->beginTransaction();
        try {
            $existing = $this->findAppointmentById($appointmentId);

            $ret = $this->conn->update('Appointment', $data, array('AppointmentId' => $appointmentId));
            if (isset($data['Status'])) {
              if (intval($data['Status']) == AppointmentStatus::Paid) {
                $companyId = $existing['CompanyId'];
                $userId = $existing['UserId'];
                $price = $existing['Price'];

                $existedCompanyBalanceLog = CompanyBalanceLogRepository::getInstance()->findCompanyBalanceLogByIncomeSrc(2, $existing['AppointmentNo']);
                if (!$existedCompanyBalanceLog) {
                  $this->conn->executeUpdate("
                      UPDATE `Company` SET Amount = Amount + $price WHERE CompanyId  = $companyId;
                  ");
                  $conn->insert('CompanyBalanceLog', array(
                    'CompanyId' => $existing['CompanyId'],
                    'Amount' => $price,
                    'IncomeSrc' => 2,
                    'IncomeSrcId' => $existing['AppointmentNo'],
                    'CreateTime'=> date('Y-m-d H:i:s'),
                    'Status' => 1,
                    'Description' => sprintf('预约【%s】付款%.2f元', $existing['AppointmentNo'], $existing['Price'])
                  ));
                }

                $existedUserBalanceLog = UserBalanceLogRepository::getInstance()->findUserBalanceLogByIncomeSrc(2, $existing['AppointmentNo']);
                if (!$existedUserBalanceLog) {
                  $this->conn->executeUpdate("
                      UPDATE `Users` SET Balance = Balance - $price WHERE UserId  = $userId;
                  ");

                  $this->conn->insert('UserBalanceLog', array(
                      'UserId' => $userId,
                      'Amount' => -$price,
                      'IncomeSrc' => 2,
                      'IncomeSrcId' => $existing['AppointmentNo'],
                      'CreateTime'=> date('Y-m-d H:i:s'),
                      'Status' => 1,
                      'Description'=> sprintf('预约【%s】付款%.2f元', $existing['AppointmentNo'], $existing['Price'])
                  ));
                }
              }

              if (intval($data['Status']) == AppointmentStatus::Cancelled) {
                $companyId = $existing['CompanyId'];
                $userId = $existing['UserId'];
                $price = $existing['Price'];

                $existedCompanyBalanceLog = CompanyBalanceLogRepository::getInstance()->findCompanyBalanceLogByIncomeSrc(2, $existing['AppointmentNo']);
                if ($existedCompanyBalanceLog) {
                  $existedCompanyBalanceLog = CompanyBalanceLogRepository::getInstance()->findCompanyBalanceLogByIncomeSrc(5, $existing['AppointmentNo']);
                  if (!$existedCompanyBalanceLog) {
                    $this->conn->executeUpdate("
                        UPDATE `Company` SET Amount = Amount - $price WHERE CompanyId  = $companyId;
                    ");
                    $conn->insert('CompanyBalanceLog', array(
                      'CompanyId' => $existing['CompanyId'],
                      'Amount' => -$price,
                      'IncomeSrc' => 5,
                      'IncomeSrcId' => $existing['AppointmentNo'],
                      'CreateTime'=> date('Y-m-d H:i:s'),
                      'Status' => 1,
                      'Description' => sprintf('预约【%s】退款%.2f元', $existing['AppointmentNo'], $existing['Price'])
                    ));
                  }
                }

                $existedUserBalanceLog = UserBalanceLogRepository::getInstance()->findUserBalanceLogByIncomeSrc(2, $existing['AppointmentNo']);
                if ($existedUserBalanceLog) {
                  $existedUserBalanceLog = UserBalanceLogRepository::getInstance()->findUserBalanceLogByIncomeSrc(5, $existing['AppointmentNo']);
                  if (!$existedUserBalanceLog) {
                    $this->conn->executeUpdate("
                        UPDATE `Users` SET Balance = Balance + $price WHERE UserId  = $userId;
                    ");

                    $this->conn->insert('UserBalanceLog', array(
                        'UserId' => $userId,
                        'Amount' => $price,
                        'IncomeSrc' => 5,
                        'IncomeSrcId' => $existing['AppointmentNo'],
                        'CreateTime'=> date('Y-m-d H:i:s'),
                        'Status' => 1,
                        'Description'=> sprintf('预约【%s】退款%.2f元', $existing['AppointmentNo'], $existing['Price'])
                    ));
                  }
                }
              }
            }

            $conn->commit();

            return $ret;
        } catch (\Exception $e) {
            $conn->rollback();
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
