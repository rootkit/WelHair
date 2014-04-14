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

use Welfony\Core\Enum\UserPointType;
use Welfony\Repository\UserPointRepository;

class UserPointService
{

    public static function listAllPointsByUserAndType($userId, $type = 0)
    {
        return UserPointRepository::getInstance()->getAllPointsByUserAndType($userId, $type);
    }

    public static function addPoint($data)
    {
        switch ($data['Type']) {
            case UserPointType::NewRegister: {
                $data['Value'] = 10;
                $data['Description'] = '新用户注册';
                break;
            }
            default: {
                break;
            }
        }
        $data['CreatedDate'] = date('Y-m-d H:i:s');

        UserPointRepository::getInstance()->save($data);
    }

}
