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
use Welfony\Repository\StaffRepository;
use Welfony\Repository\UserRepository;
use Welfony\Utility\Util;

class StaffService
{

    public static function search($city, $district, $sort, $location, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = StaffRepository::getInstance()->searchCount($city, $district);
        $staffList = StaffRepository::getInstance()->search($city, $district, $sort, $location, $page, $pageSize);

        return array('total' => $total, 'staffs' => $staffList);
    }

    public static function getStaffDetail($staffId)
    {
        $resultSet = StaffRepository::getInstance()->findStaffDetailById($staffId);
        $staffDataset = self::composeStaffDetail($resultSet);

        return $staffDataset[0];
    }

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

    public static function seachByNameAndPhone($searchText, $includeClient)
    {
        $resultSet = StaffRepository::getInstance()->seachByNameAndPhoneAndEmail($searchText, $includeClient);

        return self::composeStaffDetail($resultSet);
    }

    public static function saveCompanyStaff($staffId, $companyId, $isApproved = false)
    {
        $staff = array('UserId' => $staffId, 'Role' => $isApproved ? UserRole::Staff : UserRole::Client);

        $existedItem = CompanyUserRepository::getInstance()->findByUserAndCompany($staffId, $companyId);
        if ($existedItem) {
            $existedItem['IsApproved'] = $isApproved;
            $existedItem['LastModifiedDate'] = date('Y-m-d H:i:s');

            if (CompanyUserRepository::getInstance()->update($existedItem['CompanyUserId'], $existedItem)) {
                UserRepository::getInstance()->update($staff['UserId'], $staff);
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
                UserRepository::getInstance()->update($staff['UserId'], $staff);

                $data['CompanyUserId'] = $saveResult;
                return $data;
            }
        }

        return false;
    }

    private static function composeStaffDetail($dataset)
    {
        $result = array();

        foreach ($dataset as $row) {
            $staffDetailIndex = Util::keyValueExistedInArray($result, 'UserId', $row['UserId']);
            if ($staffDetailIndex === false) {
                $staffDetail = array(
                    'UserId' => 0,
                    'Company' => array(),
                    'Services' => array(),
                    'Works' => array()
                );
            } else {
                $staffDetail = $result[$staffDetailIndex];
            }

            $staffDetail['UserId'] = $row['UserId'];
            $staffDetail['Username'] = $row['Username'];
            $staffDetail['Nickname'] = $row['Nickname'];
            $staffDetail['AvatarUrl'] = $row['AvatarUrl'];

            if ($row['CompanyId'] > 0) {
                $staffDetail['Company']['CompanyId'] =  $row['CompanyId'];
                $staffDetail['Company']['Name'] = $row['CompanyName'];
                $staffDetail['Company']['Address'] = $row['CompanyAddress'];
            }

            if ($row['ServiceId'] > 0 && Util::keyValueExistedInArray($staffDetail['Services'], 'ServiceId', $row['ServiceId']) === false) {
                $staffDetail['Services'][] = array(
                    'ServiceId' => $row['ServiceId'],
                    'Title' => $row['ServiceTitle'],
                    'OldPrice' => $row['OldPrice'],
                    'Price' => $row['Price']
                );
            }

            if ($row['WorkId'] > 0 && Util::keyValueExistedInArray($staffDetail['Works'], 'WorkId', $row['WorkId']) === false) {
                $staffDetail['Works'][] = array(
                    'WorkId' => $row['WorkId'],
                    'Title' => $row['WorkTitle'],
                    'PictureUrl' => $row['WorkPictureUrl']
                );
            }

            if ($staffDetailIndex === false) {
                $result[] = $staffDetail;
            } else {
                $result[$staffDetailIndex] = $staffDetail;
            }
        }

        return $result;
    }

}
