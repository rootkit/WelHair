<?php

class IndexController extends Zend_Controller_Action
{

    public function indexAction()
    {
        $this->view->pageTitle = '后台管理系统';
    }

}