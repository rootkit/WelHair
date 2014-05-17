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

use Welfony\Repository\WithdrawalRepository;

class WithdrawalService
{

    public static function getWithdrawalById($id)
    {
        return  WithdrawalRepository::getInstance()->findWithdrawalById( $id);

    }
    public static function listUserWithdrawal($pageNumber, $pageSize)
    {
        $result = array(
            'withdrawals' => array(),
            'total' => 0
        );

        $totalCount = WithdrawalRepository::getInstance()->getAllUserWithdrawalCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = WithdrawalRepository::getInstance()->listUserWithdrawal( $pageNumber, $pageSize);

            $result['withdrawals']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listCompanyWithdrawal($pageNumber, $pageSize)
    {
        $result = array(
            'withdrawals' => array(),
            'total' => 0
        );

        $totalCount = WithdrawalRepository::getInstance()->getAllCompanyWithdrawalCount();

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = WithdrawalRepository::getInstance()->listCompanyWithdrawal( $pageNumber, $pageSize);

            $result['withdrawals']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listWithdrawalByUser($userId, $pageNumber, $pageSize)
    {
        $result = array(
            'withdrawals' => array(),
            'total' => 0
        );

        $totalCount = WithdrawalRepository::getInstance()->getAllWithdrawalCountByUser($userId);

        if ($totalCount > 0 && $pageNumber <= ceil($totalCount / $pageSize)) {

            $searchResult = WithdrawalRepository::getInstance()->listWithdrawalByUser($userId, $pageNumber, $pageSize);

            $result['withdrawals']= $searchResult;
        }

        $result['total'] = $totalCount;

        return $result;
    }

    public static function listAllWithdrawal()
    {
        return $searchResult = WithdrawalRepository::getInstance()->getAllWithdrawal();

    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ($data['WithdrawalId'] == 0) {

            $newId = WithdrawalRepository::getInstance()->save($data);
            if ($newId) {
                $data['WithdrawalId'] = $newId;

                $result['success'] = true;
                $result['withdrawal'] = $data;

                return $result;
            } else {
                $result['message'] = '添加失败！';

                return $result;
            }
        } else {

            $r = WithdrawalRepository::getInstance()->update($data['WithdrawalId'],$data);

            if ($r) {

                $result['success'] = true;
                $result['withdrawal'] = $data;

                return $result;
            } else {
                $result['message'] = '更新失败！';

                return $result;
            }

            return true;
        }
    }

    public static function deleteWithdrawal($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = WithdrawalRepository::getInstance()->delete($data['WithdrawalId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '删除成功！';

            return $result;
        } else {
            $result['message'] = '删除失败！';

            return $result;
        }
    }

    public static function approveWithdrawal($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = WithdrawalRepository::getInstance()->approve($data['WithdrawalId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '批准成功！';

            return $result;
        } else {
            $result['message'] = '批准失败！';

            return $result;
        }
    }

    public static function rejectWithdrawal($data)
    {
        $result = array('success' => false, 'message' => '');
        $r = WithdrawalRepository::getInstance()->reject($data['WithdrawalId']);
        if ($r) {

            $result['success'] = true;
            $result['message'] = '拒绝成功！';

            return $result;
        } else {
            $result['message'] = '拒绝失败！';

            return $result;
        }
    }


}
