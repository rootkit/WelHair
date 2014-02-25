<?php

class Goods_IndexController extends Zend_Controller_Action
{

    public function searchAction()
    {
        $this->view->pageTitle = '商品列表';
    }

}