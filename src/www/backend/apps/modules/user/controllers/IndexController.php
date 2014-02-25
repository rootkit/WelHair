<?php

class User_IndexController extends Zend_Controller_Action
{

    public function searchAction()
    {
        $this->view->pageTitle = '会员列表';
    }

    public function infoAction()
    {
        $this->view->pageTitle = '会员信息';

        if ($this->_request->isPost()) {
            $userrole = intval($this->_request->getParam('userrole'));
            $username = htmlspecialchars($this->_request->getParam('username'));
            $nickname = htmlspecialchars($this->_request->getParam('nickname'));
            $email = htmlspecialchars($this->_request->getParam('email'));
            $mobile = htmlspecialchars($this->_request->getParam('mobile'));

            echo $email;die();
        }
    }

}