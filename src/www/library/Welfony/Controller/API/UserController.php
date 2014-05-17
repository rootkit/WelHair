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

namespace Welfony\Controller\API;

use Welfony\Core\Enum\DeviceType;
use Welfony\Core\Enum\UserRole;
use Welfony\Controller\Base\AbstractAPIController;
use Welfony\Service\UserDeviceService;
use Welfony\Service\UserLikeService;
use Welfony\Service\UserPointService;
use Welfony\Service\UserService;

class UserController extends AbstractAPIController
{

    public function index()
    {
        $result = array();

        $search = htmlspecialchars($this->app->request->get('search'));
        if ($search) {
            $existedUser = UserService::getUserByUsernameOrMobile($search);
            if ($existedUser) {
                $result[] = $existedUser;
            }
        }

        $this->sendResponse($result);
    }

    public function getDetail($userId)
    {
        $response = array('success' => false);
        $user = UserService::getUserById($userId);
        if ($user) {
            unset($user['Password']);

            if ($user['ProfileBackgroundUrl']) {
                $user['ProfileBackgroundUrl'] = json_decode($user['ProfileBackgroundUrl'], true);
            } else {
                $user['ProfileBackgroundUrl'] = array();
            }
            $response['user'] = $user;
        }

        $this->sendResponse($response);
    }

    public function update($userId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        $response = array('success' => false);

        $reqData['UserId'] = $userId;

        $response = UserService::update($reqData);

        $this->sendResponse($response);
    }

    public function signUpWithEmail()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        $response = array('success' => false);

        if (!isset($reqData['Nickname']) || empty($reqData['Nickname'])) {
            $error = '请输入昵称！';
        }
        if (!isset($reqData['Email']) || empty($reqData['Email'])) {
            $error = '请输入邮箱！';
        }
        if (!isset($reqData['Password']) || empty($reqData['Password'])) {
            $error = '请输入密码！';
        }

        if (!empty($error)) {
            $response['message'] = $error;
        } else {
            $nickname = htmlspecialchars($reqData['Nickname']);
            $email = htmlspecialchars($reqData['Email']);
            $password = $reqData['Password'];
            $role = !isset($reqData['Role']) ? UserRole::Client : $reqData['Role'];
            $response = UserService::signUpWithEmail($email, $password, $role, $nickname);
        }

        $this->sendResponse($response);
    }

    public function signUpWithMobile()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        $response = array('success' => false);

        if (!isset($reqData['Nickname']) || empty($reqData['Nickname'])) {
            $error = '请输入昵称！';
        }
        if (!isset($reqData['Mobile']) || empty($reqData['Mobile'])) {
            $error = '请输入邮箱！';
        }
        if (!isset($reqData['Password']) || empty($reqData['Password'])) {
            $error = '请输入密码！';
        }

        if (!empty($error)) {
            $response['message'] = $error;
        } else {
            $nickname = htmlspecialchars($reqData['Nickname']);
            $mobile = htmlspecialchars($reqData['Mobile']);
            $password = $reqData['Password'];
            $role = !isset($reqData['Role']) ? UserRole::Client : $reqData['Role'];
            $response = UserService::signUpWithMobile($mobile, $password, $role, $nickname);
        }

        $this->sendResponse($response);
    }

    public function signInWithSocial()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        $response = array('success' => false, 'message' => '');

        if (!isset($reqData['Type']) || empty($reqData['Type'])) {
            $response['message'] = '请输入邮箱！';
        } else {
            $response = UserService::signInWithSocial($reqData, intval($reqData['Type']));
        }

        $this->sendResponse($response);
    }

    public function signInWithEmail()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        $response = array('success' => false);

        if (!isset($reqData['Email']) || empty($reqData['Email'])) {
            $error = '请输入邮箱！';
        }
        if (!isset($reqData['Password']) || empty($reqData['Password'])) {
            $error = '请输入密码！';
        }

        if (!empty($error)) {
            $response['message'] = $error;
        } else {
            $email = htmlspecialchars($reqData['Email']);
            $password = $reqData['Password'];

            $response = UserService::signInWithEmail($email, $password);
        }

        $this->sendResponse($response);
    }

    public function signInWithMobile()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        $response = array('success' => false);

        if (!isset($reqData['Mobile']) || empty($reqData['Mobile'])) {
            $error = '请输入手机号！';
        }
        if (!isset($reqData['Password']) || empty($reqData['Password'])) {
            $error = '请输入密码！';
        }

        if (!empty($error)) {
            $response['message'] = $error;
        } else {
            $mobile = htmlspecialchars($reqData['Mobile']);
            $password = $reqData['Password'];

            $response = UserService::signInWithMobile($mobile, $password);
        }

        $this->sendResponse($response);
    }

    public function addFollow($userId)
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();
        $reqData['UserId'] = $userId;

        $result = UserLikeService::save($reqData);
        $this->sendResponse($result);
    }

    public function listPointsByUser($userId)
    {
        $this->sendResponse(UserPointService::listAllPointsByUserAndType($userId));
    }

    public function addDevice()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        if (!isset($reqData['Type']) || empty($reqData['Type'])) {
            $result = array('success' => false, 'message' => '请确定设备类型');
            $this->sendResponse($result);
        }
        $type = intval($reqData['Type']);

        if (!isset($reqData['Token']) || empty($reqData['Token'])) {
            $result = array('success' => false, 'message' => '请确定设备Token');
            $this->sendResponse($result);
        }
        $deviceToken = trim(htmlspecialchars($reqData['Token']));

        $result = UserDeviceService::add($this->currentContext['UserId'], $type, $deviceToken);
        $this->sendResponse($result);
    }

    public function removeDevice()
    {
        $reqData = $this->getDataFromRequestWithJsonFormat();

        if (!isset($reqData['Type']) || empty($reqData['Type'])) {
            $result = array('success' => false, 'message' => '请确定设备类型');
            $this->sendResponse($result);
        }
        $type = intval($reqData['Type']);

        if (!isset($reqData['Token']) || empty($reqData['Token'])) {
            $result = array('success' => false, 'message' => '请确定设备Token');
            $this->sendResponse($result);
        }
        $deviceToken = trim(htmlspecialchars($reqData['Token']));

        $result = UserDeviceService::remove($this->currentContext['UserId'], $type, $deviceToken);
        $this->sendResponse($result);
    }

}
