<?php

class Goods_CategoryController extends Zend_Controller_Action
{

    public function searchAction()
    {
        $this->view->pageTitle = '分类列表';
    }

}