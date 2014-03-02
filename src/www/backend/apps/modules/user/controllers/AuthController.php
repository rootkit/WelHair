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
use Welfony\Controller\Base\AbstractAdminController;

class User_AuthController extends AbstractAdminController
{

    public function signinAction()
    {
        if ($this->_request->isPost()) {
            $email = htmlspecialchars($this->_request->getParam('email'));
            $password = $this->_request->getParam('password');

            if (empty($email)) {
                $error = '请输入邮箱！';
            }
            if (empty($password)) {
                $error = '请输入密码！';
            }

            if (!empty($error)) {
                $this->view->errorMessage = $error;
                return;
            }

            $auth = \Zend_Auth::getInstance();
            $authAdapter = new EmailAuthAdapter($email, $password);

            $result = $auth->authenticate($authAdapter);
            if (!$result->isValid()) {
                $this->view->errorMessage = implode('<br/>', $result->getMessages());
            } else {
                Zend_Session::rememberMe();

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