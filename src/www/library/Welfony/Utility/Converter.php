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

use Welfony\Core\Enum\UserRole;

class Converter
{

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

}
