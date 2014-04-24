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
use Welfony\Core\Enum\UserPointType;
use Welfony\Core\Enum\UserRole;
use Welfony\Repository\CompanyUserRepository;
use Welfony\Repository\SocialRepository;
use Welfony\Repository\UserRepository;
use Welfony\Utility\Util;

class UserService
{

    public static function signUpWithEmail($email, $password, $nickname = null)
    {
        $result = array('success' => false, 'message' => '');

        if (empty($email) || empty($password)) {
            $result['message'] = '邮箱和密码不能为空！';

            return $result;
        }

        $user = UserRepository::getInstance()->findUserByEmail($email);
        if ($user) {
            $result['message'] = '邮箱已被占用！';

            return $result;
        }

        $data = array();
        $data['Username'] = Util::genRandomUsername();
        $data['Nickname'] = $nickname ? $nickname : $email;
        $data['Role'] = UserRole::Client;
        $data['Email'] = $email;
        $data['Password'] = PassHash::hash($password);
        $data['AvatarUrl'] = Util::baseAssetUrl('img/avatar-default.jpg');
        $data['CreatedDate'] = date('Y-m-d H:i:s');

        $newId = UserRepository::getInstance()->save($data);
        if ($newId) {
            $data['UserId'] = $newId;
            $data['IsApproved'] = 1;
            unset($data['Password']);

            $result['success'] = true;
            $result['user'] = $data;

            $userPointData = array(
                'Type' => UserPointType::NewRegister,
                'UserId' => $newId
            );
            UserPointService::addPoint($userPointData);

            return $result;
        } else {
            $result['message'] = '注册失败！';

            return $result;
        }

        $result['success'] = true;
        $result['user'] = $user;

        return $result;
    }

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

        unset($user['Password']);

        $companyUser = CompanyUserRepository::getInstance()->findByUser($user['UserId']);
        if ($companyUser) {
            $user['IsApproved'] = $companyUser['IsApproved'];
        } else {
            if ($user['Role'] == UserRole::Staff || $user['Role'] == UserRole::Manager) {
                $smData = array(
                    'UserId' => $user['UserId'],
                    'Role' => UserRole::Client
                );
                UserRepository::getInstance()->update($user['UserId'], $smData);
            }
            $user['Role'] = $user['Role'] == UserRole::Admin ? UserRole::Admin : UserRole::Client;
            $user['IsApproved'] = 1;
        }

        $result['success'] = true;
        $result['user'] = $user;

        return $result;
    }

    public static function signInWithSocial($socialData, $socialType)
    {
        $result = array('success' => false, 'message' => '');

        if (!isset($socialData['Id']) || empty($socialData['Id'])) {
            $result['message'] = '请输入用户ID！';

            return $result;
        }

        if (!isset($socialData['Username']) || empty($socialData['Username'])) {
            $result['message'] = '请输入用户名！';

            return $result;
        }

        $existedUser = SocialRepository::getInstance()->getUserBySocial($socialData['Id'], $socialType);
        if ($existedUser) {
            unset($existedUser['Password']);

            $companyUser = CompanyUserRepository::getInstance()->findByUser($existedUser['UserId']);
            if ($companyUser) {
                $existedUser['IsApproved'] = $companyUser['IsApproved'];
            } else {
                $existedUser['IsApproved'] = !($existedUser['Role'] == UserRole::Staff || $existedUser['Role'] == UserRole::Manager);
            }

            $result['success'] = true;
            $result['user'] = $existedUser;

            return $result;
        }

        $data = array();
        $data['Username'] = Util::genRandomUsername();
        $data['Nickname'] = $socialData['Username'];
        $data['Role'] = UserRole::Client;
        $data['Password'] = PassHash::hash(Util::genRandomUsername());
        $data['AvatarUrl'] = Util::baseAssetUrl('img/avatar-default.jpg');
        $data['CreatedDate'] = date('Y-m-d H:i:s');

        $newId = UserRepository::getInstance()->save($data);
        if ($newId) {
            $data['UserId'] = $newId;
            $data['IsApproved'] = 1;
            unset($data['Password']);

            $result['success'] = true;
            $result['user'] = $data;

            $userPointData = array(
                'Type' => UserPointType::NewRegister,
                'UserId' => $newId
            );
            UserPointService::addPoint($userPointData);

            $socialData = array(
                'UserId' => $data['UserId'],
                'ExternalId' => $socialData['Id'],
                'DisplayName' => $socialData['Username'],
                'Type' => $socialType,
                'CreatedDate' => date('Y-m-d H:i:s')
            );
            SocialRepository::getInstance()->save($socialData);

            return $result;
        }

        $result['message'] = '登录失败！';

        return $result;

    }

    public static function listAllUsers($role, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = UserRepository::getInstance()->getAllUsersCount($role);
        $userList = UserRepository::getInstance()->getAllUsers($role, $page, $pageSize);

        return array('total' => $total, 'users' => $userList);
    }

    public static function getUserById($userId)
    {
        $user = UserRepository::getInstance()->findUserById($userId);

        return $user;
    }

    public static function getUserByName($userName)
    {
        $user = UserRepository::getInstance()->findUserByUsername($userName);

        return $user;
    }

    public static function getUserByUsernameOrMobile($usernameOrMobile)
    {
        if (empty($usernameOrMobile)) {
            return null;
        }

        $existedUser = UserRepository::getInstance()->findUserByUsername($usernameOrMobile);
        if (!$existedUser) {
            $existedUser = UserRepository::getInstance()->findUserByMobile($usernameOrMobile);
        }

        if ($existedUser) {
            if ($existedUser['Role'] == UserRole::Admin) {
                return null;
            }

            unset($existedUser['Password']);
            unset($existedUser['EmailVerified']);
            unset($existedUser['MobileVerified']);
        }

        return $existedUser;
    }

    public static function update($data)
    {
        $result = array('success' => false, 'message' => '');

        if (!isset($data['UserId']) || intval($data['UserId']) <= 0) {
            $result['message'] = '用户不存在！';

            return $result;
        }

        if (isset($data['AvatarUrl'])) {
            $data['AvatarUrl'] = empty($data['AvatarUrl']) ? Util::baseAssetUrl('img/avatar-default.jpg') : $data['AvatarUrl'];
        }

        if (isset($data['Username']) && !empty($data['Username'])) {
            $existedUser = UserRepository::getInstance()->findUserByUsername($data['Username']);
            if ($existedUser && $existedUser['UserId'] != $data['UserId']) {
                $result['message'] = '用户名已经存在。';

                return $result;
            }
        }

        if (isset($data['Email']) && !empty($data['Email'])) {
            $existedUser = UserRepository::getInstance()->findUserByEmail($data['Email']);
            if ($existedUser && $existedUser['UserId'] != $data['UserId']) {
                $result['message'] = '邮箱已被占用。';

                return $result;
            }
        }

        if (isset($data['Mobile']) && !empty($data['Mobile'])) {
            $existedUser = UserRepository::getInstance()->findUserByMobile($data['Mobile']);
            if ($existedUser && $existedUser['UserId'] != $data['UserId']) {
                $result['message'] = '手机号已被注册。';

                return $result;
            }
        }

        $data['LastModifiedDate'] = date('Y-m-d H:i:s');

        $result['success'] = UserRepository::getInstance()->update($data['UserId'], $data);
        $result['message'] = $result['success'] ? '更新用户成功！' : '更新用户失败！';

        return $result;
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

    public static function seachByNameAndPhone($searchText)
    {
        return UserRepository::getInstance()->seachByNameAndPhoneAndEmail($searchText);
    }

    public static function removeByUser($userId)
    {
        return UserRepository::getInstance()->remove($userId);
    }

}
