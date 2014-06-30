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

use Welfony\Core\Enum\AppointmentStatus;
use Welfony\Core\Enum\CompanyStatus;
use Welfony\Core\Enum\NotificationType;
use Welfony\Core\Enum\StaffStatus;
use Welfony\Core\Enum\UserPointType;
use Welfony\Repository\AppointmentRepository;
use Welfony\Repository\ServiceRepository;
use Welfony\Repository\UserRepository;
use Welfony\Service\NotificationService;
use Welfony\Service\UserPointService;

class AppointmentService
{

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (!isset($data['UserId']) || intval($data['UserId']) <= 0) {
            $result['message'] = '请选择预约人。';

            return $result;
        }

        if (!isset($data['StaffId']) || intval($data['StaffId']) <= 0) {
            $result['message'] = '请选择发型师。';

            return $result;
        }

        if (!isset($data['ServiceId']) || intval($data['ServiceId']) <= 0) {
            $result['message'] = '请选择一项服务。';

            return $result;
        }

        if (!isset($data['AppointmentDate']) || strtotime($data['AppointmentDate']) === false) {
            $result['message'] = '请选择预约时间。';

            return $result;
        }

        $staff = StaffService::getStaffDetail($data['StaffId']);
        if ($staff['Status'] != StaffStatus::Valid || $staff['Company']['Status'] != CompanyStatus::Valid) {
            $result['message'] = '该发型师暂时不可预约。';

            return $result;
        }
        $service = ServiceRepository::getInstance()->findServiceById($data['ServiceId']);
        if (!$service || $service['UserId'] != $data['StaffId']) {
            $result['message'] = '该服务暂时不可预约。';

            return $result;
        }

        $appointmentData = array(
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
            'Price' => $service['Price']
        );

        if ($appointmentData['AppointmentId'] == 0) {
            if (isset($data['Status']) && ($data['Status'] == AppointmentStatus::Completed || $data['Status'] == AppointmentStatus::Cancelled)) {
                $result['message'] = '不可以直接添加已完成或已取消的预约。';
                return $result;
            }

            $appointmentData['Status'] = isset($data['Status']) ? $data['Status'] : AppointmentStatus::Paid;
            $appointmentData['CreatedDate'] = date('Y-m-d H:i:s');
            $appointmentData['AppointmentNo'] = date('YmdHis').rand(100000, 999999);

            $user = UserRepository::getInstance()->findUserById($appointmentData['UserId']);
            if ($user['Balance'] < $appointmentData['Price']) {
                $result['message'] = '账户余额不足，请充值。';

                return $result;
            }

            $newId = AppointmentRepository::getInstance()->save($appointmentData);
            if ($newId) {
                $appointmentData['AppointmentId'] = $newId;

                $userPointData = array(
                    'Type' => UserPointType::AppointmentClient,
                    'UserId' => $data['UserId']
                );
                UserPointService::addPoint($userPointData);

                $userPointData = array(
                    'Type' => UserPointType::AppointmentStaff,
                    'UserId' => $data['StaffId']
                );
                UserPointService::addPoint($userPointData);

                NotificationService::send(NotificationType::AppointmentNew, $appointmentData['StaffId']);

                $result['success'] = true;
                $result['appointment'] = $appointmentData;

                return $result;
            } else {
                $result['message'] = '添加预约失败！';

                return $result;
            }
        } else {
            $oldAppointment = AppointmentRepository::getInstance()->findAppointmentById($appointmentData['AppointmentId']);

            if ($oldAppointment['Status'] == AppointmentStatus::Completed || $oldAppointment['Status'] == AppointmentStatus::Cancelled) {
                $result['message'] = '此预约不可更改！';
                return $result;
            }

            if ($data['Status'] == AppointmentStatus::Completed) {
                if ($oldAppointment['Status'] != AppointmentStatus::Paid) {
                    $result['message'] = '非法操作！';
                    return $result;
                }
            }

            if ($data['Status'] == AppointmentStatus::Pending) {
                if ($oldAppointment['Status'] != AppointmentStatus::Pending) {
                    $result['message'] = '非法操作！';
                    return $result;
                }
            }

            $appointmentData['Status'] = $data['Status'];
            $appointmentData['LastModifiedDate'] = date('Y-m-d H:i:s');

            $result['success'] = AppointmentRepository::getInstance()->update($appointmentData['AppointmentId'], $appointmentData);
            $result['message'] = $result['success'] ? '更新预约成功！' : '更新预约失败！';

            return $result;
        }
    }

    public static function update($appointmentId, $data)
    {
        $result = array('success' => false, 'message' => '');

        $oldAppointment = AppointmentRepository::getInstance()->findAppointmentById($appointmentId);
        
        if(isset($data['IsLiked']) && intval($data['IsLiked']) == 1){
            $result['success'] = AppointmentRepository::getInstance()->update($appointmentId, $data);
            $result['message'] = $result['success'] ? '点赞！' : '取消点赞！';
            return $result;
        }
        
        if ($oldAppointment['Status'] == AppointmentStatus::Completed || $oldAppointment['Status'] == AppointmentStatus::Cancelled) {
            $result['message'] = '此预约不可更改！';
            return $result;
        }

        if ($data['Status'] == AppointmentStatus::Completed) {
            if ($oldAppointment['Status'] != AppointmentStatus::Paid) {
                $result['message'] = '非法操作！';
                return $result;
            }
        }

        if ($data['Status'] == AppointmentStatus::Pending) {
            if ($oldAppointment['Status'] != AppointmentStatus::Pending) {
                $result['message'] = '非法操作！';
                return $result;
            }
        }

        $data['LastModifiedDate'] = date('Y-m-d H:i:s');

        $result['success'] = AppointmentRepository::getInstance()->update($appointmentId, $data);
        $result['message'] = $result['success'] ? '更新预约成功！' : '更新预约失败！';

        return $result;

    }

    public static function listAllAppointments($page, $pageSize, $staffId, $userId, $status)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = AppointmentRepository::getInstance()->getAllAppointmentsCount($staffId, $userId, $status);
        $appointmentList = AppointmentRepository::getInstance()->getAllAppointments($page, $pageSize, $staffId, $userId, $status);
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
