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
use Welfony\Utility\Util;

class User_IndexController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 10;

        $this->view->pageTitle = '会员列表';

        $page = intval($this->_request->getParam('page'));
        $searchResult = UserService::listAllUsers($page, $pageSize);

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

}
