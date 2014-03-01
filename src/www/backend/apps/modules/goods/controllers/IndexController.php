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

class Goods_IndexController extends AbstractAdminController
{

    public function searchAction()
    {
        $this->view->pageTitle = '商品列表';
    }

    public function infoAction()
    {
    	/*
        $this->view->pageTitle = '会员信息';

        $userId = intval($this->_request->getParam('user_id'));

        $user = array(
            'UserId' => 0,
            'Username' => Util::genRandomUsername(),
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

            $user['Username'] = $username;
            $user['Role'] = $userRole;
            $user['Password'] = $password;
            $user['Nickname'] = $nickname;
            $user['Email'] = $email;
            $user['Mobile'] = $mobile;
            $user['AvatarUrl'] = $avatarUrl;

            $result = UserService::save($user);
            if ($result['success']) {

            } else {

            }
        } else {
            if ($userId > 0) {

            } else {
                $user['AvatarOriginalUrl'] = '';
                $user['AvatarThumb110Url'] = '';
            }
        }

        $this->view->userInfo = $user;
        */
    }

}