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

        $rstAddressList = AddressService::listAllAddressesByUser($this->currentUser['UserId']);
        $this->view->addressList = $rstAddressList['addresses'];
    }

    public function addresseditAction()
    {
        $this->view->pageTitle = '收货地址';

        $addressId = intval($this->_request->getParam('address_id'));

        if ($this->_request->isPost()) {
            $address = array(
                'AddressId' => $addressId,
                'UserId' => $this->currentUser['UserId'],
                'ShippingName' => htmlspecialchars($this->_request->getParam('receiver_name')),
                'Province' => intval($this->_request->getParam('province')),
                'City' => intval($this->_request->getParam('city')),
                'District' => intval($this->_request->getParam('district')),
                'Address' => htmlspecialchars($this->_request->getParam('address_detail')),
                'Mobile' => htmlspecialchars($this->_request->getParam('mobile')),
                'IsDefault' => intval($this->_request->getParam('is_default'))
            );

            $result = AddressService::save($address);
            if ($result['success']) {
                $this->_redirect($this->view->baseUrl('user/setting/address'));
            } else {
                $this->view->errorMessage = $result['message'];
            }
        }

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
        $this->view->cityList = $this->view->addressInfo['Province'] > 0 ? AreaService::listAreaByParent($this->view->addressInfo['Province']) : array();
        $this->view->districtList = $this->view->addressInfo['City'] > 0 ? AreaService::listAreaByParent($this->view->addressInfo['City']) : array();
    }

}