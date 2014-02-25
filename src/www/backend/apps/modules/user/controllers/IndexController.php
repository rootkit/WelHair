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
    }

}