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

use PHPassLib\Hash\PBKDF2 as PassHash;
use Welfony\Controller\Base\AbstractFrontendController;
use Welfony\Service\AddressService;
use Welfony\Service\AreaService;
use Welfony\Service\UserService;

class User_SettingController extends AbstractFrontendController
{

    public function indexAction()
    {
        $this->view->pageTitle = '帐号设置';

        $user = $this->currentUser;
        unset($user['IsApproved']);

        if ($this->_request->isPost()) {
            $username = htmlspecialchars($this->_request->getParam('username'));
            $nickname = htmlspecialchars($this->_request->getParam('nickname'));
            $email = htmlspecialchars($this->_request->getParam('email'));
            $mobile = htmlspecialchars($this->_request->getParam('mobile'));
            $avatarUrl = $this->_request->getParam('avatar_url');

            $user['Username'] = $username;
            $user['Nickname'] = $nickname;
            $user['Email'] = $email;
            $user['Mobile'] = $mobile;
            $user['AvatarUrl'] = $avatarUrl;

            $result = UserService::save($user);
            if ($result['success']) {
                $this->view->successMessage = '保存用户成功！';
                $this->refreshCurrentUser();
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {
            $user['AvatarOriginalUrl'] = '';
            $user['AvatarThumb110Url'] = '';
        }

        $this->view->userInfo = $user;
    }

    public function changepasswordAction()
    {
        $this->view->pageTitle = '修改密码';

        if ($this->_request->isPost()) {
            $oldPassword = $this->_request->getParam('original_password');
            $newPassword = $this->_request->getParam('new_password');
            $repeateNewPassword = $this->_request->getParam('repeate_new_password');

            if (empty($oldPassword)) {
                $this->view->errorMessage = '请输入原始密码！';

                return;
            }
            if (empty($newPassword)) {
                $this->view->errorMessage = '请输入新密码！';

                return;
            }

            if ($newPassword != $repeateNewPassword) {
                $this->view->errorMessage = '两次密码输入不一致！';

                return;
            }

            $userInfo = UserService::getUserById($this->currentUser['UserId']);
            if (!PassHash::verify($oldPassword, $userInfo['Password'])) {
                $this->view->errorMessage = '原始密码不正确！';

                return $result;
            }

            $user = $this->currentUser;
            $user['Password'] = $newPassword;
            unset($user['IsApproved']);

            $result = UserService::save($user);
            if ($result['success']) {
                $this->view->successMessage = '修改密码成功！';
            } else {
                $this->view->errorMessage = $result['message'];
            }
        }
    }

    public function addressAction()
    {
        $this->view->pageTitle = '收货地址';

        $this->view->addressList = array(1, 2,3, 4, 5);
    }

    public function addresseditAction()
    {
        $this->view->pageTitle = '收货地址';

        $addressId = intval($this->_request->getParam('address_id'));

        if ($this->_request->isPost()) {

        }

        $provinceId = 0;
        $cityId = 0;

        if ($addressId > 0) {
            $this->view->addressInfo = AddressService::getAddressById($addressId);
        } else {
            $this->view->addressInfo = array(
                'AddressId' => 0,
                'ShippingName' => '',
                'Province' => 0,
                'City' => 0,
                'District' => 0,
                'Mobile' => '',
                'Address' => ''
            );
        }

        $this->view->provinceList = AreaService::listAreaByParent(0);
        $this->view->cityList = $provinceId > 0 ? AreaService::listAreaByParent($provinceId) : array();
        $this->view->districtList = $cityId > 0 ? AreaService::listAreaByParent($cityId) : array();
    }

}