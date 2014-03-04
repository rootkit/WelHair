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

use Welfony\Repository\CompanyRepository;

class CompanyService
{

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

        if (intval($data['Province']) <= 0 || intval($data['City']) <= 0 || intval($data['District']) <= 0) {
            $result['message'] = '地区选择不全。';

            return $result;
        }

        if (empty($data['Address'])) {
            $result['message'] = '请填写地址。';

            return $result;
        }

        $data['PictureUrl'] = json_encode($data['PictureUrl'] ? $data['PictureUrl'] : array());

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

            $result['success'] = CompanyRepository::getInstance()->update($data['CompanyId'], $data);
            $result['message'] = $result['success'] ? '更新沙龙成功！' : '更新沙龙失败！';

            return $result;
        }
    }

    public static function listAllCompanies($page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = CompanyRepository::getInstance()->getAllCompaniesCount();
        $companyList = CompanyRepository::getInstance()->getAllCompanies($page, $pageSize);

        return array('total' => $total, 'companies' => $companyList);
    }

    public static function getCompanyById($companyId)
    {
        $company = CompanyRepository::getInstance()->findCompanyById($companyId);
        $company['PictureUrl'] = json_decode($company['PictureUrl'], true);

        return $company;
    }

}
