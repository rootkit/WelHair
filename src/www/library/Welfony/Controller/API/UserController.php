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

use Welfony\Controller\Base\AbstractAPIController;
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

            $response = UserService::signUpWithEmail($email, $password, $nickname);
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

}
