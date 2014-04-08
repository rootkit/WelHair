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
use Welfony\Repository\CompanyRepository;
use Welfony\Repository\CompanyUserRepository;
use Welfony\Repository\StaffRepository;
use Welfony\Repository\UserRepository;
use Welfony\Utility\Util;

class StaffService
{

    public static function search($currentUserId, $city, $district, $sort, $location, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = StaffRepository::getInstance()->searchCount($city, $district);
        $staffList = StaffRepository::getInstance()->search($currentUserId, $city, $district, $sort, $location, $page, $pageSize);

        $staffs = array();
        foreach ($staffList as $staff) {
            $staff['Company'] = array(
                'CompanyId' => $staff['CompanyId'],
                'Name' => $staff['Name'],
                'Address' => $staff['Address'],
                'Latitude' => $staff['Latitude'],
                'Longitude' => $staff['Longitude'],
                'Distance' => $staff['Distance']
            );

            unset($staff['CompanyId']);
            unset($staff['Name']);
            unset($staff['Address']);
            unset($staff['Latitude']);
            unset($staff['Longitude']);
            unset($staff['Distance']);

            $staffs[] = $staff;
        }

        return array('total' => $total, 'staffs' => $staffs);
    }

    public static function getStaffDetail($staffId)
    {
        $resultSet = StaffRepository::getInstance()->findStaffDetailById($staffId);
        $staffDataset = self::composeStaffDetail($resultSet);

        return count($staffDataset) > 0 ? $staffDataset[0] : null;
    }

    public static function listAllStaff($companyId, $status, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = CompanyUserRepository::getInstance()->getAllStaffCount($companyId, $status);
        $staffList = CompanyUserRepository::getInstance()->getAllStaff($companyId, $status, $page, $pageSize);
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

    public static function removeCompanyStaffByCompanyUser($companyUserId)
    {
        return CompanyUserRepository::getInstance()->remove($companyUserId);
    }

    public static function saveCompanyStaffByCompanyUser($companyUserId, $isApproved = false)
    {
        $data = array();
        $data['IsApproved'] = $isApproved;
        $data['LastModifiedDate'] = date('Y-m-d H:i:s');
        if (CompanyUserRepository::getInstance()->update($companyUserId, $data)) {
            $role = UserRole::Client;

            $companyUser = CompanyUserRepository::getInstance()->findById($companyUserId);

            if ($isApproved) {
                if ($companyUser) {
                    $company = CompanyRepository::getInstance()->findCompanyById($companyUser['CompanyId']);
                    if ($company && $company['CreatedBy'] == $companyUser['UserId']) {
                        $role = UserRole::Manager;
                    } else {
                        $role = UserRole::Staff;
                    }
                } else {
                    $role = UserRole::Staff;
                }
            }

            $staff = array('UserId' => $companyUser['UserId'], 'Role' => $role);
            UserRepository::getInstance()->update($staff['UserId'], $staff);
        }

        return true;
    }

    public static function saveCompanyStaff($staffId, $companyId, $isApproved = false, $role = UserRole::Staff)
    {
        $staff = array('UserId' => $staffId, 'Role' => $isApproved ? $role : UserRole::Client);

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
                    'Company' => null,
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
            $staffDetail['Role'] = $row['Role'];
            $staffDetail['IsApproved'] = $row['IsApproved'];

            if ($row['CompanyId'] > 0) {
                $staffDetail['Company']['CompanyId'] =  $row['CompanyId'];
                $staffDetail['Company']['Name'] = $row['CompanyName'];
                $staffDetail['Company']['Address'] = $row['CompanyAddress'];
                $staffDetail['Company']['Status'] = $row['CompanyStatus'];
                $staffDetail['Company']['LogoUrl'] = $row['CompanyLogoUrl'];
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
