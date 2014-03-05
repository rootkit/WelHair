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
use Welfony\Service\BrandCategoryService;
use Welfony\Service\BrandService;
use Welfony\Utility\Util;

class Goods_BrandController extends AbstractAdminController
{

    public function categorysearchAction()
    {

        $this->view->pageTitle = '品牌分类列表';
        $pageSize = 10;
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = BrandCategoryService::listBrandCategory($page, $pageSize);

        $this->view->rows = $result['brandcategories'];

        $this->view->pagerHTML =  $this->renderPager($this->view->baseUrl('/goods/brand/categorysearch?'),
                                                     $page,
                                                     ceil($result['total'] / $pageSize));
    }

    public function categoryinfoAction()
    {

        $this->view->pageTitle = '品牌分类信息';

        $brandCategoryId = intval($this->_request->getParam('brandcategoryid'));

        $brandCategory = array(
            'BrandCategoryId' => 0,
            'Name' => ''
        );

        if ($this->_request->isPost()) {
            $name = htmlspecialchars($this->_request->getParam('name'));


            $brandCategory['Name'] = $name;


            $result = BrandCategoryService::save($brandCategory);
            if ($result['success']) {

            } else {

            }
        } else {
            if ($brandCategoryId > 0) {
                $brandCategory = BrandCategoryService::get($brandCategoryId);
            }
        }

        $this->view->brandCategoryInfo = $brandCategory;
    }

    public function infoAction()
    {
    	
        $this->view->pageTitle = '品牌信息';

        $allCategories = BrandCategoryService::listAllBrandCategory();

        $this->view->brandcategories = $allCategories;


        $brandId = intval($this->_request->getParam('brand_id'));


        $brand = array();
        $brand['BrandId'] = $brandId;
        $brand['Name'] = '';
        $brand['Logo'] = '';
        $brand['Url'] = '';
        $brand['Description'] = '';
        $brand['Sort'] = '';
        $brand['BrandCategoryIds'] = '';


        if ($this->_request->isPost()) {
            $brandname = htmlspecialchars($this->_request->getParam('name'));
            $sort = htmlspecialchars($this->_request->getParam('sort'));
            $url = htmlspecialchars($this->_request->getParam('brandurl'));
            $logo = htmlspecialchars($this->_request->getParam('logo'));
            $brandCategory = implode(',',  $this->_request->getParam('category'));
            $description = htmlspecialchars($this->_request->getParam('description'));

            $brand['Name'] = $brandname;
            $brand['Logo'] = $logo;
            $brand['Url'] = $url;
            $brand['Description'] = $description;
            $brand['Sort'] = $sort;
            $brand['BrandCategoryIds'] = $brandCategory;

            $result = BrandService::save($brand);
            if ($result['success']) {

            } else {

            }
        } else {

            
            if ($brandId > 0) {

            } 
        }

        $this->view->brandInfo = $brand;
    
    }

    public function searchAction()
    {
        $this->view->pageTitle = '品牌列表';

        $pageSize = 20;
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = BrandService::listBrand($page, $pageSize);

        $this->view->rows = $result['brands'];

        $this->view->pagerHTML = $this->renderPager($this->view->baseUrl('/goods/brand/brandsearch'),
                                                    $page,
                                                    ceil($result['total'] / $pageSize));
    }

}