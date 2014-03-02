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

use Guzzle\Http\Client;
use Welfony\Controller\Base\AbstractAdminController;
use Welfony\Service\AreaService;

class Company_IndexController extends AbstractAdminController
{

    public function searchAction()
    {
        static $pageSize = 1;

        $this->view->pageTitle = '沙龙列表';
    }

    public function infoAction()
    {
        $this->view->pageTitle = '沙龙信息';

        if ($this->_request->isPost()) {
            $latitude = doubleval($this->_request->getParam('latitude'));
            $longitude = doubleval($this->_request->getParam('longitude'));

            $client = new Client($this->config->map->baidu->base_url);

            $responseString = $client->post('poi/create', array(), array(
                'ak' => $this->config->map->baidu->ak,
                'title' => '欣欣沙龙',
                'address' => '上海路1号',
                'latitude' => $latitude,
                'longitude' => $longitude,
                'coord_type' => 3,
                'geotable_id' => $this->config->map->baidu->geotable_id
            ))->send()->getBody();

            var_dump(json_decode($responseString));
            die();
        }

        $this->view->provinceList = AreaService::listAreaByParent(0);
    }

    public function authenticationAction()
    {
        static $pageSize = 1;

        $this->view->pageTitle = '沙龙认证';
    }

}