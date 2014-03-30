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

use Welfony\Controller\Base\AbstractAdminController;
use Welfony\Service\CategoryService;
use Welfony\Service\ModelService;

class Goods_CategoryController extends AbstractAdminController
{

    public function searchAction()
    {
        $this->view->pageTitle = '分类列表';
        $pageSize = 10;
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = CategoryService::listCategory($page, $pageSize);

        $this->view->rows = $result['categories'];

        $this->view->pagerHTML =  $this->renderPager($this->view->baseUrl('/goods/category/search?'),
                                                     $page,
                                                     ceil($result['total'] / $pageSize));
    }

    public function infoAction()
    {
    	$this->view->pageTitle = '添加商品分类';


        $categoryId = $this->_request->getParam('category_id')?  intval($this->_request->getParam('category_id')) : 0;

        $this->view->allModel = ModelService::listAllModel();
        $category = array(
            'CategoryId' => $categoryId,
            'Name' => '',
            'ParentId' => '',
            'Sort' => '',
            'Visibility' => '',
            'ModelId'=>'',
            'Keywords'=>'',
            'Descript' => '',
            'Title' => '',
            'IsDeleted' => 0
        );


        if ($this->_request->isPost()) {
            $category['Name']= htmlspecialchars($this->_request->getParam('name'));
            $category['ParentId']= $this->_request->getParam('parentid');
            $category['ModelId']= $this->_request->getParam('modelid') ? $this->_request->getParam('modelid') : '';
            $category['Sort']= $this->_request->getParam('sort');
            $category['Visibility']= $this->_request->getParam('visibility');

            $result = CategoryService::save($category);
            if ($result['success']) {

            
                $this->view->successMessage = '保存商品成功！';
            } else {
                $this->view->errorMessage = $result['message'];
            }
        } else {

            
            if ($categoryId > 0) {
                $category = CategoryService::getCategoryById($categoryId);
                if (!$category) {
                    // process not exist logic;
                }
            }
        }

        $this->view->categoryInfo = $category;
    }

    public function deleteAction()
    {
        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $categoryId =  intval($this->_request->getParam('categoryid')) ;

        $category = array('CategoryId' => $categoryId);

        if ($this->_request->isPost()) {
           

            $result = CategoryService::deleteCategory($category);
            $this->_helper->json->sendJson($result);
        } 
    }



}