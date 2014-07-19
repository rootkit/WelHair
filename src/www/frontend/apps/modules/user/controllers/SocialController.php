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
use Welfony\Auth\SocialAuthAdapter;
use Welfony\Controller\Base\AbstractFrontendController;
use Welfony\Core\Enum\SocialType;
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
        $oauth = new OAuthService();
        $oauth->setOptions(array(
            'callbackUrl' => $this->config->frontend->baseUrl . '/user/social/accesssina',
            'consumerKey' => $this->oauthConfig['oauth']['oauth2']['weibo']['consumer_key'],
            'consumerSecret' => $this->oauthConfig['oauth']['oauth2']['weibo']['consumer_secret']
        ));
        $oauth->initAdapter('Weibo', 'Oauth2');

        $requestToken = $oauth->getAdapter()->getRequestToken();
        $oauth->getStorage()->saveRequestToken($requestToken);
        $requestTokenUrl = $oauth->getAdapter()->getRequestTokenUrl();

        header("location: $requestTokenUrl");
    }

    public function accessqqAction()
    {
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

        $socialData = array(
            'Id' => $accessTokenArray['remoteUserId'],
            'Username' => $accessTokenArray['remoteUserName']
        );

        $auth = \Zend_Auth::getInstance();
        $authAdapter = new SocialAuthAdapter($socialData, SocialType::QQ);

        $auth->authenticate($authAdapter);

        $this->_redirect('/');
    }

    public function accesssinaAction()
    {
        $oauth = new OAuthService();
        $oauth->setOptions(array(
            'callbackUrl' => $this->config->frontend->baseUrl . '/user/social/accesssina',
            'consumerKey' => $this->oauthConfig['oauth']['oauth2']['weibo']['consumer_key'],
            'consumerSecret' => $this->oauthConfig['oauth']['oauth2']['weibo']['consumer_secret']
        ));
        $oauth->initAdapter('Weibo', 'Oauth2');

        $requestToken = $oauth->getStorage()->getRequestToken();
        $accessToken = $oauth->getAdapter()->getAccessToken($_GET, $requestToken);
        $accessTokenArray = $oauth->getAdapter()->accessTokenToArray($accessToken);
        $oauth->getStorage()->saveAccessToken($accessTokenArray);
        $oauth->getStorage()->clearRequestToken();

        $socialData = array(
            'Id' => $accessTokenArray['remoteUserId'],
            'Username' => $accessTokenArray['remoteUserName']
        );

        $auth = \Zend_Auth::getInstance();
        $authAdapter = new SocialAuthAdapter($socialData, SocialType::Sina);

        $auth->authenticate($authAdapter);

        $this->_redirect('/');
    }

    private function initConfig()
    {
        $this->oauthConfig = array(
            'oauth' => array(
                'oauth2' => array(
                    'weibo' => array(
                        'enable' => 1,
                        'consumer_key' => '3633538182',
                        'consumer_secret' => 'Secret：b3ec01b688f9ccaa49c64048a7953998'
                    ),
                    'tencent' => array(
                        'enable' => 1,
                        'consumer_key' => '101061921',
                        'consumer_secret' => '65ee635188efe517af93da656e8777da'
                    )
                )
            ),
        );
    }

}