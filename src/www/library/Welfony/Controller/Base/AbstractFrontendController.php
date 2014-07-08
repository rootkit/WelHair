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

namespace Welfony\Controller\Base;

use Welfony\Core\Enum\UserRole;
use Welfony\Service\AreaService;
use Welfony\Utility\Util;

class AbstractFrontendController extends AbstractController
{

    const SESSION_KEY_USER_CONTEXT = 'USER_CONTEXT';

    protected $userContext;

    public function init()
    {
        parent::init();
    }

    public function preDispatch()
    {
        parent::preDispatch();

        $userContext = new \Zend_Session_Namespace(self::SESSION_KEY_USER_CONTEXT);

        $ip = Util::getRealIp();

        if (!$userContext->location || $userContext->ip != $ip) {
            $userContext->ip = $ip;

            $userContext->area = array(
                'Province' => array('AreaId' => 370000, 'Name' => '山东省'),
                'City' => array('AreaId' => 370100, 'Name' => '济南市')
            );

            $isLocalhost = $ip == '127.0.0.1';
            if ($isLocalhost) {
                $userContext->location = array(
                    'Latitude' => 36.68278473,
                    'Longitude' => 117.02496707
                );
            } else {
                $client = new \GuzzleHttp\Client();
                $res = $client->get('http://api.map.baidu.com/location/ip?ak=3998daac6ca53a8067263f139b4aadf4&ip=' . $ip . '&coor=bd09ll');
                $bdData = $res->json();

                $province = AreaService::getAreaByName($bdData['content']['address_detail']['province']);
                if ($province) {
                    $userContext->area['Province'] = $province;
                }
                $city = AreaService::getAreaByName($bdData['content']['address_detail']['city']);
                if ($city) {
                    $userContext->area['Province'] = $city;
                }

                $userContext->location = array(
                    'Latitude' => $bdData['content']['point']['y'],
                    'Longitude' => $bdData['content']['point']['x']
                );
            }
        }

        if (!$userContext->areaSelected) {
            $userContext->areaSelected = $userContext->area;
        }

        $this->userContext = $userContext;
        $this->view->userContext = $userContext;

        $needloginList = isset($this->needloginActionList[$this->view->module]) && isset($this->needloginActionList[$this->view->module][$this->view->controller]) ? $this->needloginActionList[$this->view->module][$this->view->controller] : array();

        if (in_array($this->view->action, $needloginList)) {
            if (!$this->getCurrentUser()) {
                $this->gotoLogin();
            }
        } else {
            $this->getCurrentUser();
        }
    }

}
