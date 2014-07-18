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

use Alipay\AlipaySubmit;
use PHPassLib\Hash\PBKDF2 as PassHash;
use Welfony\Controller\Base\AbstractFrontendController;
use Welfony\Service\AddressService;
use Welfony\Service\AreaService;
use Welfony\Service\DepositService;
use Welfony\Service\UserService;
use Welfony\Utility\Util;

class User_SettingController extends AbstractFrontendController
{

    public function init()
    {
        $this->needloginActionList['user'] = array('setting' => array('index', 'changepassword', 'address', 'addressedit', 'account', 'accounthistory'));
        parent::init();
    }

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
                'Address' => '',
                'IsDefault' => 0
            );
        }

        $this->view->provinceList = AreaService::listAreaByParent(0);
        $this->view->cityList = $this->view->addressInfo['Province'] > 0 ? AreaService::listAreaByParent($this->view->addressInfo['Province']) : array();
        $this->view->districtList = $this->view->addressInfo['City'] > 0 ? AreaService::listAreaByParent($this->view->addressInfo['City']) : array();
    }

    public function accountAction()
    {
        $this->view->pageTitle = '我的帐号';

        $userId = $this->currentUser['UserId'];

        if ($this->_request->isPost()) {
            $reqData = array(
                'DepositId' => 0,
                'UserId' => $userId,
                'Amount' => floatval($this->_request->getParam('amount')),
                'Status' => 0
            );

            $result = DepositService::save($reqData);
            if ($result['success']) {
                $this->payWithAilipay($result['deposit']['DepositNo'], $result['deposit']['Amount']);
            } else {
                $this->view->errorMessage = $result['message'];
            }
        }

        $user = UserService::getUserById($userId);
        if ($user) {
            $this->view->totalBalance = floatval($user['Balance']);
        } else {
            $this->view->totalBalance = 0;
        }
    }

    public function accounthistoryAction()
    {
        $this->view->pageTitle = '充值记录';

        $page = intval($this->_request->getParam('page'));
        $pageSize = 20;

        $rstDepositList = DepositService::listDeposit($page, $pageSize, $this->currentUser['UserId']);
        $this->view->depositList = $rstDepositList['deposits'];

        $this->view->pager = $this->renderPager($this->view->baseUrl('user/setting/accounthistory?'),
                                                $page,
                                                ceil($rstDepositList['total'] / $pageSize));
    }

    private function payWithAilipay($transactionNo, $amount)
    {
        $alipayConfig = array();
        $alipayConfig['partner'] = $this->config->alipay->partner;
        $alipayConfig['key'] = $this->config->alipay->key;
        $alipayConfig['sign_type'] = strtoupper('MD5');
        $alipayConfig['input_charset']= strtolower('utf-8');
        $alipayConfig['cacert'] = $this->config->cert->path . '/alipay.pem';
        $alipayConfig['transport'] = 'http';

        $parameter = array(
            'service' => 'create_direct_pay_by_user',
            'partner' => trim($alipayConfig['partner']),
            'payment_type'  => '1',
            'notify_url'    => $this->config->frontend->baseUrl . '/payment/alipay/notify',
            'return_url'    => $this->config->frontend->baseUrl . '/payment/alipay/return',
            'seller_email'  => $this->config->alipay->email,
            'out_trade_no'  => $transactionNo,
            'subject'   => '充值测试',
            'total_fee' => $amount,
            'body'  => '账户充值',
            'show_url'  => $this->config->frontend->baseUrl,
            'anti_phishing_key' => '',
            'exter_invoke_ip'   => Util::getRealIp(),
            '_input_charset'    => trim(strtolower($alipayConfig['input_charset']))
        );

        $alipaySubmit = new AlipaySubmit($alipayConfig);

        $html_text = $alipaySubmit->buildRequestForm($parameter, 'get', '确认');
        echo $html_text;

        die();
    }

}