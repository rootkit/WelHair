<?php

class Goods_BrandController extends Zend_Controller_Action
{

    public function searchAction()
    {
        $this->view->pageTitle = '品牌列表';
    }

    public function categorysearchAction()
    {
        $this->view->pageTitle = '品牌分类列表';
    }

}