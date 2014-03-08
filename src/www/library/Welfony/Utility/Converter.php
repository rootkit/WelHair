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

namespace Welfony\Utility;

use Welfony\Core\Enum\AppointmentStatus;
use Welfony\Core\Enum\Face;
use Welfony\Core\Enum\HairAmount;
use Welfony\Core\Enum\HairStyle;
use Welfony\Core\Enum\UserRole;

class Converter
{

    public static function appointmentStatusFromEnumToString($appointmentStatus)
    {
        $stringRole = '';

        switch ($appointmentStatus) {
            case AppointmentStatus::Pending:
                $stringRole = '未付款';
                break;
            case AppointmentStatus::Paid:
                $stringRole = '已付款';
                break;
            case AppointmentStatus::Completed:
                $stringRole = '已完成';
                break;
            case AppointmentStatus::Refund:
                $stringRole = '已退款';
                break;
            case AppointmentStatus::Cancelled:
                $stringRole = '已取消';
                break;
            default:
                break;
        }

        return $stringRole;
    }

    public static function userRoleFromEnumToString($userRole)
    {
        $stringRole = '';

        switch ($userRole) {
            case UserRole::Admin:
                $stringRole = '超级管理员';
                break;
            case UserRole::Manager:
                $stringRole = '沙龙管理员';
                break;
            case UserRole::Staff:
                $stringRole = '发型师';
                break;
            case UserRole::Client:
                $stringRole = '普通用户';
                break;
            default:
                break;
        }

        return $stringRole;
    }

    public static function faceFromEnumToString($face)
    {
        $str = '';

        switch ($face) {
            case Face::Round:
                $str = '圆脸';
                break;
            case Face::Oval:
                $str = '瓜子脸';
                break;
            case Face::Square:
                $str = '方脸';
                break;
            case Face::Long:
                $str = '长脸';
                break;
            default:
                break;
        }

        return $str;
    }

    public static function hairStyleFromEnumToString($hairStyle)
    {
        $str = '';

        switch ($hairStyle) {
            case HairStyle::Short:
                $str = '短发';
                break;
            case HairStyle::Long:
                $str = '长发';
                break;
            case HairStyle::Plait:
                $str = '编发';
                break;
            case HairStyle::Normal:
                $str = '中发';
                break;
            default:
                break;
        }

        return $str;
    }

    public static function hairAmountFromEnumToString($hairAmount)
    {
        $str = '';

        switch ($hairAmount) {
            case HairAmount::Lot:
                $str = '多密';
                break;
            case HairAmount::Normal:
                $str = '中等';
                break;
            case HairAmount::Less:
                $str = '偏少';
                break;
            default:
                break;
        }

        return $str;
    }

}
