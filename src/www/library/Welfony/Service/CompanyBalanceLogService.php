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

use Welfony\Repository\CompanyBalanceLogRepository;

class CompanyBalanceLogService
{

    public static function getCompanyBalanceLogById($id)
    {
        return  CompanyBalanceLogRepository::getInstance()->findCompanyBalanceLogById( $id);

    }
    public static function listCompanyBalanceLog($pageNumber, $pageSize)
    {
        $result = array(
            'companybalancelogs' => array(),
            'total' => 0
        );

        $totalCount = CompanyBalanceLogRepository::getInstance()->getAllCompanyBalanceLogCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = CompanyBalanceLogRepository::getInstance()->listCompanyBalanceLog( $pageNumber, $pageSize);

            $result['companybalancelogs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listBalanceLogByCompanyAndType($companyId, $balanceType, $pageNumber, $pageSize)
    {
        $result = array(
            'companybalancelogs' => array(),
            'total' => 0
        );

        $totalCount = CompanyBalanceLogRepository::getInstance()->getBalanceLogByCompanyAndTypeCount($companyId, $balanceType);

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = CompanyBalanceLogRepository::getInstance()->listBalanceLogByCompanyAndType($companyId, $balanceType, $pageNumber, $pageSize);

            $result['companybalancelogs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listCompanyBalanceLogByCompany($companyId, $pageNumber, $pageSize)
    {
        $result = array(
            'companybalancelogs' => array(),
            'total' => 0
        );

        $totalCount = CompanyBalanceLogRepository::getInstance()->getAllCompanyBalanceLogCountByCompany($companyId);

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = CompanyBalanceLogRepository::getInstance()->listCompanyBalanceLogByCompany( $companyId,$pageNumber, $pageSize);

            $result['companybalancelogs']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllCompanyBalanceLog()
    {
        return $searchResult = CompanyBalanceLogRepository::getInstance()->getAllCompanyBalanceLog();

    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['CompanyBalanceLogId'] == 0) {

            $newId = CompanyBalanceLogRepository::getInstance()->save($data);
            if ($newId) {
                $data['CompanyBalanceLogId'] = $newId;

                $result['success'] = true;
                $result['companybalancelog'] = $data;

                return $result;
            } else {
                $result['message'] = '添加失败！';

                return $result;
            }
        } else {

            $r = CompanyBalanceLogRepository::getInstance()->update($data['CompanyBalanceLogId'],$data);

            if ($r) {

                $result['success'] = true;
                $result['companybalancelog'] = $data;

                return $result;
            } else {
                $result['message'] = '更新失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteCompanyBalanceLog($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = CompanyBalanceLogRepository::getInstance()->delete($data['CompanyBalanceLogId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除成功！';

            return $result;
        } else {
            $result['message'] = '删除失败！';

            return $result;
        }
    }

}
