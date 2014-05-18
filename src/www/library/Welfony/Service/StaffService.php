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
use Welfony\Core\Enum\StaffStatus;
use Welfony\Repository\CompanyRepository;
use Welfony\Repository\CompanyUserRepository;
use Welfony\Repository\StaffRepository;
use Welfony\Repository\UserLikeRepository;
use Welfony\Repository\UserRepository;
use Welfony\Utility\Util;

class StaffService
{

    public static function listLikedStaff($currentUserId, $location, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = UserLikeRepository::getInstance()->listLikedUserCount($currentUserId);
        $staffList = UserLikeRepository::getInstance()->listLikedUser($currentUserId, $location, $page, $pageSize);

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

    public static function search($currentUserId, $searchText, $companyId, $city, $district, $sort, $location, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = StaffRepository::getInstance()->searchCount($searchText, $companyId, $city, $district);
        $staffList = StaffRepository::getInstance()->search($currentUserId, $searchText, $companyId, $city, $district, $sort, $location, $page, $pageSize);

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

    public static function getStaffDetail($staffId, $currentUserId = 0, $location = null)
    {
        $resultSet = StaffRepository::getInstance()->findStaffDetailById($staffId, $currentUserId, $location);
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

    public static function listAllClients($page, $pageSize, $staffId)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = StaffRepository::getInstance()->getAllClientCount($staffId);
        $clientList = StaffRepository::getInstance()->getAllClient($staffId, $page, $pageSize);
        $clients = array();
        foreach ($clientList as $client) {
            $clients[] = $client;
        }

        return array('total' => $total, 'clients' => $clients);
    }

    public static function listMyStaffs($page, $pageSize, $userId)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = StaffRepository::getInstance()->getMyStaffsCount($userId);
        $staffList = StaffRepository::getInstance()->getMyStaffs($userId, $page, $pageSize);
        $staffs = array();
        foreach ($staffList as $staff) {
            $staffs[] = $staff;
        }

        return array('total' => $total, 'staffs' => $staffs);
    }

    public static function seachByNameAndPhone($searchText, $includeClient)
    {
        $resultSet = StaffRepository::getInstance()->seachByNameAndPhoneAndEmail($searchText, $includeClient);

        return self::composeStaffDetail($resultSet);
    }

    public static function removeCompanyStaffByCompanyUser($companyUserId)
    {
        $companyUser = CompanyUserRepository::getInstance()->findById($companyUserId);
        $result = CompanyUserRepository::getInstance()->remove($companyUserId);

        return $result;
    }

    public static function removeCompanyStaffByCompanyAndUser($companyId, $userId)
    {
        $result = CompanyUserRepository::getInstance()->removeByCompanyAndUser($companyId, $userId);

        return $result;
    }

    public static function getStaffByCompanyAndUser($companyId, $userId)
    {
        return CompanyUserRepository::getInstance()->findByUserAndCompany($userId, $companyId);
    }

    public static function saveCompanyStaffByCompanyUser($companyUserId, $status)
    {
        $data = array();
        $data['Status'] = $status;
        $data['LastModifiedDate'] = date('Y-m-d H:i:s');

        if (CompanyUserRepository::getInstance()->update($companyUserId, $data)) {
            $companyUser = CompanyUserRepository::getInstance()->findById($companyUserId);

            if ($status == StaffStatus::Valid && $companyUser) {
                $role = UserRole::Staff;

                $company = CompanyRepository::getInstance()->findCompanyById($companyUser['CompanyId']);
                if ($company && $company['CreatedBy'] == $companyUser['UserId']) {
                    $role = UserRole::Manager;
                }

                $staff = array('UserId' => $companyUser['UserId'], 'Role' => $role);
                UserRepository::getInstance()->update($staff['UserId'], $staff);
            }
        }

        return true;
    }

    public static function saveCompanyStaff($staffId, $companyId, $status = StaffStatus::Requested)
    {
        $existedItem = CompanyUserRepository::getInstance()->findByUserAndCompany($staffId, $companyId);
        if ($existedItem) {
            $existedItem['Status'] = $status;
            $existedItem['LastModifiedDate'] = date('Y-m-d H:i:s');

            if (CompanyUserRepository::getInstance()->update($existedItem['CompanyUserId'], $existedItem)) {
                if ($status = StaffStatus::Valid) {
                    $role = UserRole::Staff;

                    $company = CompanyRepository::getInstance()->findCompanyById($companyId);
                    if ($company && $company['CreatedBy'] == $staffId) {
                        $role = UserRole::Manager;
                    }

                    $staff = array('UserId' => $staffId, 'Role' => $role);
                    UserRepository::getInstance()->update($staff['UserId'], $staff);
                }

                return $existedItem;
            }
        } else {
            $data = array(
                'UserId' => $staffId,
                'CompanyId' => $companyId,
                'Status' => $status,
                'CreatedDate' => date('Y-m-d H:i:s')
            );

            $saveResult = CompanyUserRepository::getInstance()->save($data);
            if ($saveResult) {
                $data['CompanyUserId'] = $saveResult;

                if ($status = StaffStatus::Valid) {
                    $role = UserRole::Staff;

                    $company = CompanyRepository::getInstance()->findCompanyById($companyId);
                    if ($company && $company['CreatedBy'] == $staffId) {
                        $role = UserRole::Manager;
                    }

                    $staff = array('UserId' => $staffId, 'Role' => $role);
                    UserRepository::getInstance()->update($staff['UserId'], $staff);
                }

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
            $staffDetail['Email'] = $row['Email'];
            $staffDetail['Mobile'] = $row['Mobile'];
            $staffDetail['EmailVerified'] = $row['EmailVerified'];
            $staffDetail['MobileVerified'] = $row['MobileVerified'];
            $staffDetail['Role'] = $row['Role'];
            $staffDetail['Status'] = $row['Status'];
            $staffDetail['IsLiked'] = isset($row['IsLiked']) ? $row['IsLiked'] : 0;

            if (isset($row['ProfileBackgroundUrl'])) {
                $staffDetail['ProfileBackgroundUrl'] = json_decode($row['ProfileBackgroundUrl'], true);
            }

            if ($row['CompanyId'] > 0) {
                $staffDetail['Company']['CompanyId'] =  $row['CompanyId'];
                $staffDetail['Company']['Name'] = $row['CompanyName'];
                $staffDetail['Company']['Address'] = $row['CompanyAddress'];
                $staffDetail['Company']['Status'] = $row['CompanyStatus'];
                $staffDetail['Company']['LogoUrl'] = $row['CompanyLogoUrl'];
                if (isset($row['Latitude'])) {
                    $staffDetail['Company']['Latitude'] = $row['Latitude'];
                }
                if (isset($row['Longitude'])) {
                    $staffDetail['Company']['Longitude'] = $row['Longitude'];
                }
                if (isset($row['CompanyRate'])) {
                    $staffDetail['Company']['Rate'] = $row['CompanyRate'];
                }
                if (isset($row['CompanyTel'])) {
                    $staffDetail['Company']['Tel'] = $row['CompanyTel'];
                }
                if (isset($row['CompanyMobile'])) {
                    $staffDetail['Company']['Mobile'] = $row['CompanyMobile'];
                }
                if (isset($row['CompanyCity'])) {
                    $staffDetail['Company']['City'] = $row['CompanyCity'];
                }
                if (isset($row['Distance'])) {
                    $staffDetail['Company']['Distance'] = $row['Distance'];
                }
                if (isset($row['CompanyPictureUrl'])) {
                    $staffDetail['Company']['PictureUrl'] = json_decode($row['CompanyPictureUrl'], true);
                }
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
                    'PictureUrl' => json_decode($row['WorkPictureUrl'], true)
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
