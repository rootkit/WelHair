<?php
use Welfony\Service\BrandCategoryService;
use Welfony\Service\BrandService;
use Welfony\Utility\Util;

class Goods_BrandController extends Zend_Controller_Action
{

    public function categorysearchAction()
    {
        
        $this->view->pageTitle = '品牌分类列表';
        $pageSize = 20;
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = BrandCategoryService::listBrandCategory($page, $pageSize);

        $this->view->rows = $result['brandcategories'];

        $this->view->pagerHTML =  Util::renderPager( '/goods/brand/brandcategorysearch', $page, ceil($result['total'] / $pageSize));
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

    public function searchAction()
    {
        $this->view->pageTitle = '品牌列表';

        $pageSize = 20;
        $page =  intval($this->_request->getParam('page'));

        $page =  $page<=0? 1 : $page;

        $result = BrandService::listBrand($page, $pageSize);

        $this->view->rows = $result['brands'];

        $this->view->pagerHTML =  Util::renderPager( '/goods/brand/brandsearch', $page, ceil($result['total'] / $pageSize));
    }

}