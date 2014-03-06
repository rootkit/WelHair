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

use Welfony\Core\Enum\UserRole;
use Welfony\Repository\CompanyUserRepository;
use Welfony\Repository\UserRepository;

class StaffService
{

    public static function listAllStaff($page, $pageSize, $companyId)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = CompanyUserRepository::getInstance()->getAllStaffCount($companyId);
        $staffList = CompanyUserRepository::getInstance()->getAllStaff($page, $pageSize, $companyId);
        $staffes = array();
        foreach ($staffList as $staff) {
            $staffes[] = $staff;
        }

        return array('total' => $total, 'staffes' => $staffes);
    }

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

    public static function saveCompanyStaff($staffId, $companyId, $isApproved = false)
    {
        $staff = array('UserId' => $staffId, 'Role' => $isApproved ? UserRole::Staff : UserRole::Client);

        $existedItem = CompanyUserRepository::getInstance()->findByUserAndCompany($staffId, $companyId);
        if ($existedItem) {
            $existedItem['IsApproved'] = $isApproved;
            $existedItem['LastModifiedDate'] = date('Y-m-d H:i:s');

            if (CompanyUserRepository::getInstance()->update($existedItem['CompanyUserId'], $existedItem)) {
                UserService::update($staff['UserId'], $staff);
                return $existedItem;
            }
        } else {
            $data = array(
                'UserId' => $staffId,
                'CompanyId' => $companyId,
                'IsApproved' => $isApproved,
                'CreatedDate' => date('Y-m-d H:i:s')
            );

            $saveResult = CompanyUserRepository::getInstance()->save($data);
            if ($saveResult) {
                UserService::update($staff['UserId'], $staff);

                $data['CompanyUserId'] = $saveResult;
                return $data;
            }
        }

        return false;
    }

}
