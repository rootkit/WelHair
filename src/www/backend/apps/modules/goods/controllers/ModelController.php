<?php

class Goods_ModelController extends Zend_Controller_Action
{

    public function searchAction()
    {
        $this->view->pageTitle = '模型列表';
    }

     public function infoAction()
    {
    	/*
        $this->view->pageTitle = '会员信息';

        $userId = intval($this->_request->getParam('user_id'));

        $user = array(
            'UserId' => 0,
            'Username' => Util::genRandomUsername(),
            'Nickname' => '',
            'Email' => '',
            'Mobile' => '',
            'AvatarUrl' => Util::baseAssetUrl('img/avatar-default.jpg')
        );

        if ($this->_request->isPost()) {
            $userRole = intval($this->_request->getParam('user_role'));
            $username = htmlspecialchars($this->_request->getParam('username'));
            $nickname = htmlspecialchars($this->_request->getParam('nickname'));
            $email = htmlspecialchars($this->_request->getParam('email'));
            $password = htmlspecialchars($this->_request->getParam('password'));
            $passwordRepeate = htmlspecialchars($this->_request->getParam('password_repeate'));
            $mobile = htmlspecialchars($this->_request->getParam('mobile'));
            $avatarUrl = $this->_request->getParam('avatar_url');

            $user['Username'] = $username;
            $user['Role'] = $userRole;
            $user['Password'] = $password;
            $user['Nickname'] = $nickname;
            $user['Email'] = $email;
            $user['Mobile'] = $mobile;
            $user['AvatarUrl'] = $avatarUrl;

            $result = UserService::save($user);
            if ($result['success']) {

            } else {

            }
        } else {
            if ($userId > 0) {

            } else {
                $user['AvatarOriginalUrl'] = '';
                $user['AvatarThumb110Url'] = '';
            }
        }

        $this->view->userInfo = $user;
        */
    }


}