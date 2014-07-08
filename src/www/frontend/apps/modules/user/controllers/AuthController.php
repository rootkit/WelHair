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

use Welfony\Auth\EmailAuthAdapter;
use Welfony\Controller\Base\AbstractFrontendController;
use Welfony\Core\Enum\UserRole;
use Welfony\Service\UserService;

class User_AuthController extends AbstractFrontendController
{

    public function signupAction()
    {
        $this->view->pageTitle = '注册';

        if ($this->_request->isPost()) {
            $email = htmlspecialchars($this->_request->getParam('email'));
            $nickname = htmlspecialchars($this->_request->getParam('nickname'));
            $password = $this->_request->getParam('password');
            $repeatePassword = $this->_request->getParam('repeate_password');
            $agreement = intval($this->_request->getParam('agreement'));
            $userRole = intval($this->_request->getParam('user_role'));

            if ($agreement <= 0) {
                $this->view->errorMessage = '请先接受协议！';
                return;
            }

            if (empty($email)) {
                $this->view->errorMessage = '请输入邮箱！';
                return;
            }
            if (empty($nickname)) {
                $this->view->errorMessage = '请输入昵称！';
                return;
            }
            if (empty($password)) {
                $this->view->errorMessage = '请输入密码！';
                return;
            }

            if ($password != $repeatePassword) {
                $this->view->errorMessage = '两次密码输入不一致！';
                return;
            }

            $response = UserService::signUpWithEmail($email, $password, $userRole == 0 ? UserRole::Client : UserRole::Staff, $nickname);
            if (!$response['success']) {
                $this->view->errorMessage = $response['message'];
                return;
            }

            $auth = \Zend_Auth::getInstance();
            $authAdapter = new EmailAuthAdapter($email, $password);

            $auth->authenticate($authAdapter);

            $continue = $this->_request->getParam('continue');
            $uhash = $this->_request->getParam('uhash');
            $this->_redirect(empty($continue) ? '/' : $continue . urldecode($uhash));
        }
    }

    public function signinAction()
    {
        $this->view->pageTitle = '登录';

        if ($this->_request->isPost()) {
            $email = htmlspecialchars($this->_request->getParam('email'));
            $password = $this->_request->getParam('password');
            $rememberMe = intval($this->_request->getParam('remember'));

            if (empty($email)) {
                $this->view->errorMessage = '请输入邮箱！';
                return;
            }
            if (empty($password)) {
                $this->view->errorMessage = '请输入密码！';
                return;
            }

            $auth = \Zend_Auth::getInstance();
            $authAdapter = new EmailAuthAdapter($email, $password);

            $result = $auth->authenticate($authAdapter);
            if (!$result->isValid()) {
                $this->view->errorMessage = implode('<br/>', $result->getMessages());
            } else {
                if ($rememberMe) {
                    Zend_Session::rememberMe();
                }

                $continue = $this->_request->getParam('continue');
                $uhash = $this->_request->getParam('uhash');
                $this->_redirect(empty($continue) ? '/' : $continue . urldecode($uhash));
            }
        }
    }

    public function signoutAction()
    {
        $this->signOut();
    }

}