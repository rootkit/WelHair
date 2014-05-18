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

use Welfony\Controller\Base\AbstractAdminController;
use Welfony\Core\Enum\UserRole;
use Welfony\Service\UserService;
use Welfony\Service\UserBalanceLogService;
use Welfony\Service\WithdrawalService;
use Welfony\Service\WithdrawalLogService;
use Welfony\Utility\Util;
use Welfony\Service\DepositService;

class User_IndexController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '会员列表';

        $page = intval($this->_request->getParam('page'));
        $searchResult = UserService::listAllUsers(UserRole::Client, $page, $pageSize);

        $this->view->dataList = $searchResult['users'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('user/index/search?s='),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function infoAction()
    {
        $this->view->pageTitle = '会员信息';

        $user = array(
            'UserId' => intval($this->_request->getParam('user_id')),
            'Username' => Util::genRandomUsername(),
            'Role' => UserRole::Client,
            'Nickname' => '',
            'Email' => '',
            'Mobile' => '',
            'AvatarUrl' => Util::baseAssetUrl('img/avatar-default.jpg')
        );

        if ($this->_request->isPost()) {
            $userRole = intval($this->_request->getParam('user_role'));
            $username = htmlspecialchars($this->_request->getParam('username'));
            $nickname = htmlspecialchars($this->_request->getParam('nickname'));
            $email = htmlspecialchars($this->_request->getParam('email'));
            $password = htmlspecialchars($this->_request->getParam('password'));
            $passwordRepeate = htmlspecialchars($this->_request->getParam('password_repeate'));
            $mobile = htmlspecialchars($this->_request->getParam('mobile'));
            $avatarUrl = $this->_request->getParam('avatar_url');

            if ($password != $passwordRepeate) {
                $this->view->errorMessage = '两次密码输入不一致！';

                return;
            }

            $user['Username'] = $username;
            $user['Role'] = $userRole;
            $user['Password'] = $password;
            $user['Nickname'] = $nickname;
            $user['Email'] = $email;
            $user['Mobile'] = $mobile;
            $user['AvatarUrl'] = $avatarUrl;

            $result = UserService::save($user);
            if ($result['success']) {
                if ($user['UserId'] <= 0) {
                    $user['UserId'] = $result['user']['UserId'];
                }
                $this->view->successMessage = '保存用户成功！';
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {
            if ($user['UserId'] > 0) {
                $user = UserService::getUserById($user['UserId']);
                if (!$user) {
                    // process not exist logic;
                }
            }

            $user['AvatarOriginalUrl'] = '';
            $user['AvatarThumb110Url'] = '';
        }

        $this->view->userInfo = $user;
    }

    public function balancelogAction()
    {
        $userId = intval($this->_request->getParam('user_id'));
        static $pageSize = 10;
        $this->view->userId = $userId;

        $this->view->pageTitle = '余额历史记录';

        $page = $this->_request->getParam('page')? intval($this->_request->getParam('page')) : 1;
        $searchResult = UserBalanceLogService::listUserBalanceLogByUser($userId, $page, $pageSize);

        $this->view->dataList = $searchResult['userbalancelogs'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('user/index/balancelog?s='),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function depositsearchAction()
    {
        //print_r(WithdrawalService::save(array(
        //    'WithdrawalId' => 0,
            //'UserId' => 1,
        //    'CompanyId'=>1,
        //    'Amount' => 0.1,
        //    'Description' => '提现',
        //    'Bank'=> '民生银行',
         //   'AccountNo' => '1113l'
        //)));
        //die();
        //$userId = intval($this->_request->getParam('user_id'));
        static $pageSize = 10;

        $this->view->pageTitle = '充值列表';

        $page = $this->_request->getParam('page')? intval($this->_request->getParam('page')) : 1;
        $searchResult = DepositService::listDeposit($page, $pageSize);

        $this->view->dataList = $searchResult['deposits'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('user/index/deposit?s='),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function depositinfoAction()
    {
        $this->view->pageTitle = '充值详情';
        $depositid = intval($this->_request->getParam('deposit_id'));
        //if ($depositid) {
        //    $deposit = DepositService::getWithdrawalById($withdrawalid);
        //    $this->view->depositInfo= $deposit;
        //}
        $userid = intval($this->_request->getParam('user_id'));
        if($userid)
        {
            $user = UserService::getUserById($userid);
            $this->view->userInfo = $user;
        }

        $deposit = array(
            'DepositId' => $depositid ,
            'UserId' => $userid,
            'Amount' => 0,
            'Status' => 0,
            'Description' =>'',
            'AccountNo' => '',
            'AccountName' => '',
            'Comments' =>''
        );

        $staffId = intval($this->_request->getParam('staff_id'));

        if ($this->_request->isPost()) {
            $status = intval($this->_request->getParam('status'));
            $deposit['Description'] = $this->_request->getParam('description');
            $deposit['Comments'] = $this->_request->getParam('comments');
            $deposit['Amount'] = $this->_request->getParam('amount');
            $deposit['AccountNo'] = $this->_request->getParam('accountno');
            $deposit['AccountName'] = $this->_request->getParam('accountname');
            $deposit['Status'] = $status;

            $result = DepositService::save($deposit);
            $this->_helper->viewRenderer->setNoRender(true);
            $this->_helper->layout->disableLayout();
            $this->_helper->json->sendJson($result);
            //if ($result['success']) {
            //    $this->getResponse()->setRedirect($this->view->baseUrl('user/index/depositsearch'));
            //} else {
            //    $this->view->errorMessage = $result['message'];
            //}
        } else {
            if ($deposit['DepositId'] > 0) {
                $deposit = DepositService::getDepositById($deposit['DepositId']);
            }
        }

        $this->view->depositInfo = $deposit;
    }

    public function withdrawalsearchAction()
    {
        //print_r(WithdrawalService::save(array(
        //    'WithdrawalId' => 0,
            //'UserId' => 1,
        //    'CompanyId'=>1,
        //    'Amount' => 0.1,
        //    'Description' => '提现',
        //    'Bank'=> '民生银行',
         //   'AccountNo' => '1113l'
        //)));
        //die();
        //$userId = intval($this->_request->getParam('user_id'));
        static $pageSize = 10;

        $this->view->pageTitle = '提现请求';

        $page = $this->_request->getParam('page')? intval($this->_request->getParam('page')) : 1;
        $searchResult = WithdrawalService::listUserWithdrawal($page, $pageSize);

        $this->view->dataList = $searchResult['withdrawals'];
        $this->view->pager = $this->renderPager($this->view->baseUrl('user/index/withdrawal?s='),
                                                $page,
                                                ceil($searchResult['total'] / $pageSize));
    }

    public function withdrawalinfoAction()
    {
        $this->view->pageTitle = '提现详情';
        $withdrawalid = intval($this->_request->getParam('withdrawal_id'));
        if ($withdrawalid) {
            $withdrawal = WithdrawalService::getWithdrawalById($withdrawalid);
            $this->view->withdrawalInfo= $withdrawal;
            $logs = WithdrawalLogService::listWithdrawalLogByWithdrawal($withdrawalid, 1, 1000);
            $this->view->logs = $logs['withdrawallogs'];
        }
    }

    public function withdrawalapproveAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $currentUser = $this->getCurrentUser();
        if( !$currentUser )
        {
            $this->_helper->json->sendJson(array('success' => false, 'message' => 'Need login' ));
            return;
        }

        $withdrawalId =  intval($this->_request->getParam('withdrawal_id')) ;
        

        if ($this->_request->isPost()) {

            $result = WithdrawalService::approveWithdrawal(array('WithdrawalId'=> $withdrawalId));
            $this->_helper->json->sendJson($result);
        }
    }

    public function withdrawalrejectAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $currentUser = $this->getCurrentUser();
        if( !$currentUser )
        {
            $this->_helper->json->sendJson(array('success' => false, 'message' => 'Need login' ));
            return;
        }

        $withdrawalId =  intval($this->_request->getParam('withdrawal_id')) ;
        $reason =  $this->_request->getParam('reason') ;
        

        if ($this->_request->isPost()) {

            $result = WithdrawalService::rejectWithdrawal(array('WithdrawalId'=> $withdrawalId), $reason);
            $this->_helper->json->sendJson($result);
        }
    }

}
