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

namespace Welfony\Service;

use Welfony\Repository\AppointmentRepository;
use Welfony\Repository\ServiceRepository;

class AppointmentService
{

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (intval($data['UserId']) <= 0) {
            $result['message'] = '请选择预约人。';

            return $result;
        }

        if (intval($data['StaffId']) <= 0) {
            $result['message'] = '请选择发型师。';

            return $result;
        }

        if (intval($data['ServiceId']) <= 0) {
            $result['message'] = '请选择一项服务。';

            return $result;
        }

        if (strtotime($data['AppointmentDate']) === false) {
            $result['message'] = '请选择预约时间。';

            return $result;
        }

        $staff = StaffService::getStaffDetail($data['StaffId']);
        $service = ServiceRepository::getInstance()->findServiceById($data['ServiceId']);

        $data = array(
            'AppointmentId' => $data['AppointmentId'],
            'UserId' => $data['UserId'],
            'CompanyId' => $staff['Company']['CompanyId'],
            'CompanyName' => $staff['Company']['Name'],
            'CompanyAddress' => $staff['Company']['Address'],
            'StaffId' => $staff['UserId'],
            'StaffName' => $staff['Nickname'],
            'ServiceId' => $service['ServiceId'],
            'ServiceTitle' => $service['Title'],
            'AppointmentDate' => $data['AppointmentDate'],
            'Price' => $service['Price'],
            'Status' => $data['Status']
        );

        if ($data['AppointmentId'] == 0) {
            $data['CreatedDate'] = date('Y-m-d H:i:s');

            $newId = AppointmentRepository::getInstance()->save($data);
            if ($newId) {
                $data['AppointmentId'] = $newId;

                $result['success'] = true;

                return $result;
            } else {
                $result['message'] = '添加预约失败！';

                return $result;
            }
        } else {
            $data['LastModifiedDate'] = date('Y-m-d H:i:s');

            $result['success'] = AppointmentRepository::getInstance()->update($data['AppointmentId'], $data);
            $result['message'] = $result['success'] ? '更新预约成功！' : '更新预约失败！';

            return $result;
        }
    }

    public static function listAllAppointments($page, $pageSize, $staffId)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = AppointmentRepository::getInstance()->getAllAppointmentsCount($staffId);
        $appointmentList = AppointmentRepository::getInstance()->getAllAppointments($page, $pageSize, $staffId);
        $appointments = array();
        foreach ($appointmentList as $appointment) {
            $appointments[] = $appointment;
        }

        return array('total' => $total, 'appointments' => $appointments);
    }

    public static function getAppointmentById($appointmentId)
    {
        $appointment = AppointmentRepository::getInstance()->findAppointmentById($appointmentId);

        return $appointment;
    }

}
