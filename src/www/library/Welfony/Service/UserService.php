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
        $result = array('success' => false, 'message' => '');

        if (empty($email) || empty($password)) {
            $result['message'] = '用户名和密码不能为空！';
            return $result;
        }

        $user = UserRepository::getInstance()->findUserByEmail($email);
        if (!$user) {
            $result['message'] = '用户不存在！';
            return $result;
        }

        if (!PassHash::verify($password, $user['Password'])) {
            $result['message'] = '密码不正确！';
            return $result;
        }

        $result['success'] = true;
        $result['user'] = $user;

        return $result;
    }

    public static function signUpWithEmail()
    {

    }

    public static function signInWithSocial($socialExternalId, $socialType)
    {

    }

    public static function listAllUsers($page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = UserRepository::getInstance()->getAllUsersCount();
        $userList = UserRepository::getInstance()->getAllUsers($page, $pageSize);

        return array('total' => $total, 'users' => $userList);
    }

    public static function getUserById($userId)
    {
        $user = UserRepository::getInstance()->findUserById($userId);
        return $user;
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (empty($data['Email']) && empty($data['Mobile'])) {
            $result['message'] = '邮箱和手机号至少填写一项。';
            return $result;
        }

        if (!empty($data['Username'])) {
            $existedUser = UserRepository::getInstance()->findUserByUsername($data['Username']);
            if ($existedUser && $existedUser['UserId'] != $data['UserId']) {
                $result['message'] = '账号已被占用。';
                return $result;
            }
        }

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
            if (empty($data['Password'])) {
                $result['message'] = '请输入初始密码。';
                return $result;
            }

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
            $data['LastModifiedDate'] = date('Y-m-d H:i:s');
            if (!empty($data['Password'])) {
                $data['Password'] = PassHash::hash($data['Password']);
            } else {
                unset($data['Password']);
            }

            $result['success'] = UserRepository::getInstance()->update($data['UserId'], $data);
            $result['message'] = $result['success'] ? '更新用户成功！' : '更新用户失败！';

            return $result;
        }
    }

}