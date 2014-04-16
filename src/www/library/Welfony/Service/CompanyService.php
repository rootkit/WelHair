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

use Welfony\Core\Enum\CompanyStatus;
use Welfony\Core\Enum\UserRole;
use Welfony\Repository\CompanyRepository;
use Welfony\Repository\UserLikeRepository;
use Welfony\Repository\UserRepository;
use Welfony\Service\StaffService;

class CompanyService
{

    public static function getCompanyDetail($companyId, $currentUserId, $location)
    {
        $resultSet = CompanyRepository::getInstance()->findCompanyDetailById($companyId, $currentUserId, $location);
        return count($resultSet) > 0 ? $resultSet[0] : null;
    }

    public static function listLikedCompany($currentUserId, $location, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = UserLikeRepository::getInstance()->listLikedCompanyCount($currentUserId);
        $companyList = UserLikeRepository::getInstance()->listLikedCompany($currentUserId, $location, $page, $pageSize);

        $companies = array();
        foreach ($companyList as $company) {
            $company['PictureUrl'] = json_decode($company['PictureUrl'], true);

            $companies[] = $company;
        }

        return array('total' => $total, 'companies' => $companies);
    }

    public static function search($currentUserId, $searchText, $city, $district, $sort, $location, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = CompanyRepository::getInstance()->searchCount($searchText, $city, $district);
        $companyList = CompanyRepository::getInstance()->search($currentUserId, $searchText, $city, $district, $sort, $location, $page, $pageSize);

        $companies = array();
        foreach ($companyList as $company) {
            $company['PictureUrl'] = json_decode($company['PictureUrl'], true);

            $companies[] = $company;
        }

        return array('total' => $total, 'companies' => $companies);
    }

    public static function update($data)
    {
        $result = array('success' => false, 'message' => '');

        if (empty($data['Tel']) && empty($data['Mobile'])) {
            $result['message'] = '联系电话和手机至少填写一项。';

            return $result;
        }

        if (!isset($data['PictureUrl']) || count($data['PictureUrl']) <= 0) {
            $result['message'] = '请至少选择一张沙龙图片。';

            return $result;
        }

        $data['PictureUrl'] = json_encode($data['PictureUrl'], true);
        $data['LastModifiedDate'] = date('Y-m-d H:i:s');

        $result['success'] = CompanyRepository::getInstance()->update($data['CompanyId'], $data);
        $result['message'] = $result['success'] ? '更新沙龙成功！' : '更新沙龙失败！';

        return $result;
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (empty($data['Name'])) {
            $result['message'] = '请填写沙龙名称。';

            return $result;
        }

        if (empty($data['Tel']) && empty($data['Mobile'])) {
            $result['message'] = '联系电话和手机至少填写一项。';

            return $result;
        }

        if (intval($data['Province']) <= 0 || intval($data['City']) <= 0) {
            $result['message'] = '地区选择不全。';

            return $result;
        }

        if (empty($data['Address'])) {
            $result['message'] = '请填写地址。';

            return $result;
        }

        if (!isset($data['PictureUrl']) || count($data['PictureUrl']) <= 0) {
            $result['message'] = '请至少选择一张沙龙图片。';

            return $result;
        }

        $data['PictureUrl'] = json_encode($data['PictureUrl'], true);

        if ($data['CompanyId'] == 0) {
            $data['CreatedDate'] = date('Y-m-d H:i:s');

            $newId = CompanyRepository::getInstance()->save($data);
            if ($newId) {
                $data['CompanyId'] = $newId;

                $result['success'] = true;
                $result['company'] = $data;

                return $result;
            } else {
                $result['message'] = '添加沙龙失败！';

                return $result;
            }
        } else {
            $data['LastModifiedDate'] = date('Y-m-d H:i:s');

            if (isset($data['Status']) && $data['Status'] == CompanyStatus::Valid) {
                $companyInfo = CompanyRepository::getInstance()->findCompanyById($data['CompanyId']);
                if ($companyInfo['CreatedBy'] > 0) {
                    $companyManagerData = array(
                        'UserId' => $companyInfo['CreatedBy'],
                        'Role' => UserRole::Manager
                    );
                    UserRepository::getInstance()->update($companyManagerData['UserId'], $companyManagerData);
                    StaffService::saveCompanyStaff($companyManagerData['UserId'], $data['CompanyId'], 1, UserRole::Manager);
                }
            }

            $result['success'] = CompanyRepository::getInstance()->update($data['CompanyId'], $data);
            $result['message'] = $result['success'] ? '更新沙龙成功！' : '更新沙龙失败！';

            return $result;
        }
    }

    public static function seachByNameAndPhone($searchText)
    {
        $companyList = CompanyRepository::getInstance()->seachByNameAndPhone($searchText);
        $companies = array();
        foreach ($companyList as $company) {
            $company['PictureUrl'] = json_decode($company['PictureUrl'], true);
            $companies[] = $company;
        }

        return $companies;
    }

    public static function listAllCompanies($status, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = CompanyRepository::getInstance()->getAllCompaniesCount($status);
        $companyList = CompanyRepository::getInstance()->getAllCompanies($status, $page, $pageSize);
        $companies = array();
        foreach ($companyList as $company) {
            $company['PictureUrl'] = json_decode($company['PictureUrl'], true);
            $companies[] = $company;
        }

        return array('total' => $total, 'companies' => $companies);
    }

    public static function listAll()
    {

        $companyList = CompanyRepository::getInstance()->listAllCompanies();
        return $companyList;
    }

    public static function listAllByGoods($goodsId)
    {

        $companyList = CompanyRepository::getInstance()->listAllCompaniesByGoods( $goodsId);
        return $companyList;
    }

    public static function getCompanyById($companyId)
    {
        $company = CompanyRepository::getInstance()->findCompanyById($companyId);
        $company['PictureUrl'] = json_decode($company['PictureUrl'], true);

        return $company;
    }

}
