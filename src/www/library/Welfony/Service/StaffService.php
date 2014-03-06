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

use Welfony\Repository\UserRepository;

class StaffService
{

    public static function seachByNameAndPhone($searchText)
    {
        $staffList = UserRepository::getInstance()->seachByNameAndPhoneAndEmail($searchText);
        $result = array();
        foreach ($staffList as $staff) {
            unset($staff['Password']);
            $result[] = $staff;
        }

        return $result;
    }

}
