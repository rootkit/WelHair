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

use PHPassLib\Hash\PBKDF2 as PassHash;
use Welfony\Repository\UserRepository;

class UserService
{

    public static function signInWithEmail($email, $password)
    {

    }

    public static function signUpWithEmail()
    {

    }

    public static function signInWithSocial($socialExternalId, $socialType)
    {

    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');
        if (!empty($data['Email'])) {
            $existedUser = UserRepository::getInstance()->findUserByEmail($data['Email']);
            if ($existedUser && $existedUser['UserId'] != $data['UserId']) {
                $result['message'] = '邮箱已被占用。';
                return $result;
            }
        }

        if (!empty($data['Mobile'])) {
            $existedUser = UserRepository::getInstance()->findUserByMobile($data['Mobile']);
            if ($existedUser && $existedUser['UserId'] != $data['UserId']) {
                $result['message'] = '手机号已被注册。';
                return $result;
            }
        }

        if ($data['UserId'] == 0) {
            $data['Password'] = PassHash::hash($data['Password']);
            $data['CreatedDate'] = date('Y-m-d H:i:s');

            $newId = UserRepository::getInstance()->save($data);
            if ($newId) {
                $data['UserId'] = $newId;

                $result['success'] = true;
                $result['user'] = $data;

                return $result;
            } else {
                $result['message'] = '添加用户失败！';
                return $result;
            }
        } else {
            return true;
        }
    }

}