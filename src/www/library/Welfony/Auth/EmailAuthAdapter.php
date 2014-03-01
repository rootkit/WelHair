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

namespace Welfony\Auth;

use Welfony\Service\UserService;

class EmailAuthAdapter implements \Zend_Auth_Adapter_Interface
{

    private $email;
    private $password;

    public function __construct($email, $password)
    {
        $this->email = $email;
        $this->password = $password;
    }

    public function authenticate()
    {
        $result = UserService::signInWithEmail($this->email, $this->password);
        if ($result['success']) {
            $auth = \Zend_Auth::getInstance();
            $auth->clearIdentity();

            return new \Zend_Auth_Result(
                \Zend_Auth_Result::SUCCESS,
                $result['user'],
                array());
        } else {
            return new \Zend_Auth_Result(
                \Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID,
                array(),
                array($result['message']));
        }
    }

}