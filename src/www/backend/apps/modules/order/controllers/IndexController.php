<?php

class Order_IndexController extends Zend_Controller_Action
{

    public function searchAction()
    {
        $this->view->pageTitle = '订单列表';
    }

}