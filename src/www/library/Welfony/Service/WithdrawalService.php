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
use Welfony\Repository\UserRepository;
use Welfony\Repository\CompanyRepository;

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

    public static function listCompanyWithdrawal($page, $pageSize, $companyId = null)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $result = array(
            'withdrawals' => array(),
            'total' => 0
        );

        $totalCount = WithdrawalRepository::getInstance()->getAllCompanyWithdrawalCount($companyId);

        if ($totalCount > 0 && $page <= ceil($totalCount / $pageSize)) {
            $searchResult = WithdrawalRepository::getInstance()->listCompanyWithdrawal($page, $pageSize, $companyId);
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

        if (!isset($data['Bank']) || empty($data['Bank'])) {
            $result['message'] = '请选择转账银行！';
            return $result;
        }
        if (!isset($data['OpenAccountBank']) || empty($data['OpenAccountBank'])) {
            $result['message'] = '请输入开户行名称！';
            return $result;
        }
        if (!isset($data['AccountNo']) || empty($data['AccountNo'])) {
            $result['message'] = '请输入银行账号！';
            return $result;
        }

        if ($data['WithdrawalId'] == 0) {
            if (isset($data['Amount']) && floatval($data['Amount']) > 0) {
                if (isset($data['UserId']) || isset($data['CompanyId'])) {
                    if (isset($data['UserId'])) {
                        $u= UserRepository::getInstance()->findUserById($data['UserId']);
                        if (floatval($data['Amount']) > floatval($u['Balance'])) {
                            $result['message'] = '用户余额不足！';
                            return $result;
                        } else {
                            $userWithdrawalTotal = WithdrawalRepository::getInstance()->getUserWithrawalTotal($data['UserId']);
                            if (floatval($data['Amount']) > floatval($u['Balance']) - floatval($userWithdrawalTotal )) {
                                $result['message'] = '提现总额超出用户余额！';
                                return $result;
                            }
                        }
                    } else {
                        $c = CompanyRepository::getInstance()->findCompanyById($data['CompanyId']);
                        if (floatval($data['Amount']) > floatval($c['Amount'])) {
                            $result['message'] = '沙龙余额不足！';
                            return $result;
                        } else {
                            $companyWithdrawalTotal = WithdrawalRepository::getInstance()->getCompanyWithrawalTotal($data['CompanyId']);
                            if (floatval($data['Amount']) > floatval($c['Amount']) - floatval($companyWithdrawalTotal)) {
                                $result['message'] = '提现总额超出沙龙余额！';
                                return $result;
                            }
                        }
                    }
                } else {
                    $result['message'] = '请设置提现对象！';
                    return $result;
                }
            } else {
                $result['message'] = '请设置正确的金额！';
                return $result;
            }

            $data['CreateTime'] = date('Y-m-d H:i:s');
            $data['LastUpdateDate'] = date('Y-m-d H:i:s');
            $data['WithdrawalNo'] = date('YmdHis').rand(100000, 999999);

            $newId = WithdrawalRepository::getInstance()->save($data);
            if ($newId) {
                $data['WithdrawalId'] = $newId;

                $result['success'] = true;
                $result['withdrawal'] = $data;

                return $result;
            } else {
                $result['message'] = '提现失败！';

                return $result;
            }
        } else {
            $r = WithdrawalRepository::getInstance()->update($data['WithdrawalId'], $data);

            if ($r) {
                $result['success'] = true;
                $result['withdrawal'] = $data;

                return $result;
            } else {
                $result['message'] = '提现更新失败！';

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

    public static function rejectWithdrawal($data, $reason)
    {
        $result = array('success' => false, 'message' => '');
        $r = WithdrawalRepository::getInstance()->reject($data['WithdrawalId'], $reason);
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
