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

use EvaOAuth\Service as OAuthService;
use Welfony\Controller\Base\AbstractFrontendController;
use Welfony\Service\UserService;

class User_SocialController extends AbstractFrontendController
{

    private $oauthConfig;

    public function init()
    {
        parent::init();

        $this->_helper->viewRenderer->setNoRender(true);
        $this->_helper->layout->disableLayout();

        $this->initConfig();
    }

    public function qqAction()
    {
        $oauth = new OAuthService();
        $oauth->setOptions(array(
            'callbackUrl' => $this->config->frontend->baseUrl . '/user/social/accessqq',
            'consumerKey' => $this->oauthConfig['oauth']['oauth2']['tencent']['consumer_key'],
            'consumerSecret' => $this->oauthConfig['oauth']['oauth2']['tencent']['consumer_secret']
        ));
        $oauth->initAdapter('Tencent', 'Oauth2');

        $requestToken = $oauth->getAdapter()->getRequestToken();
        $oauth->getStorage()->saveRequestToken($requestToken);
        $requestTokenUrl = $oauth->getAdapter()->getRequestTokenUrl();

        header("location: $requestTokenUrl");
    }

    public function sinaAction()
    {
    }

    public function accessqqAction()
    {
        $type = htmlspecialchars($this->_request->getParam('type'));

        $oauth = new OAuthService();
        $oauth->setOptions(array(
            'callbackUrl' => $this->config->frontend->baseUrl . '/user/social/accessqq',
            'consumerKey' => $this->oauthConfig['oauth']['oauth2']['tencent']['consumer_key'],
            'consumerSecret' => $this->oauthConfig['oauth']['oauth2']['tencent']['consumer_secret']
        ));
        $oauth->initAdapter('Tencent', 'Oauth2');

        $requestToken = $oauth->getStorage()->getRequestToken();
        $accessToken = $oauth->getAdapter()->getAccessToken($_GET, $requestToken);
        $accessTokenArray = $oauth->getAdapter()->accessTokenToArray($accessToken);
        $oauth->getStorage()->saveAccessToken($accessTokenArray);
        $oauth->getStorage()->clearRequestToken();

        p($accessTokenArray);
    }

    private function initConfig()
    {
        $this->oauthConfig = array(
            'oauth' => array(
                'request_url_path' => '/oauth/',
                'access_url_path' => '/oauth/access/',
                'login_url_path' => '/',
                'oauth1' => array(
                    'twitter' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'douban' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'weibo' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => '',
                    ),
                    'flickr' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'dropbox' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'linkedin' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'yahoo' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'sohu' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'tianya' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                ),
                'oauth2' => array(
                    'facebook' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'weibo' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'baidu' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'douban' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'qihoo' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'taobao' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'tencent' => array(
                        'enable' => 1,
                        'consumer_key' => '101061921',
                        'consumer_secret' => '65ee635188efe517af93da656e8777da'
                    ),
                    'qzone' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'renren' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'tqq' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'kaixin' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'pengyou' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'qplus' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'msn' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'google' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'github' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'foursquare' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'disqus' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                    'netease' => array(
                        'enable' => 0,
                        'consumer_key' => '',
                        'consumer_secret' => ''
                    ),
                )
            ),
        );
    }

}