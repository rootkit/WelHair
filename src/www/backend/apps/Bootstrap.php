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

class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{

    private $config;

    protected function _initConfig()
    {
        $this->config = new Zend_Config($this->getOptions(), true);
        Zend_Registry::set('config', $this->config);
    }

    protected function _initSession()
    {
        Zend_Session::setOptions($this->config->session->toArray());
        Zend_Session::start();
    }

    protected function _initRouter()
    {
        $front = Zend_Controller_Front::getInstance();
        $router = $front->getRouter();

        $companyStaffWorkinfoRoute = new Zend_Controller_Router_Route_Regex(
            'company/staff/work/info', array(
                'module' => 'company',
                'controller' => 'staff',
                'action' => 'workinfo'
            ), array(),
            'company/staff/work/info'
        );
        $router->addRoute('company_staff_workinfo', $companyStaffWorkinfoRoute);
    }

    protected function _initDatabase()
    {
        $dbConfig = new \Doctrine\DBAL\Configuration();
        $connectionParams = array(
            'dbname' => $this->config->database->params->dbname,
            'user' => $this->config->database->params->user,
            'password' => $this->config->database->params->password,
            'host' => $this->config->database->params->host,
            'driver' => $this->config->database->params->driver,
            'charset' => $this->config->database->params->charset
        );

        $conn = \Doctrine\DBAL\DriverManager::getConnection($connectionParams, $dbConfig);
        Zend_Registry::set('conn', $conn);
    }

    protected function _initLog()
    {
        $logger = Zend_Log::factory(array(
                'timestampFormat' => 'Y-m-d',
                array(
                    'writerName' => 'Stream',
                    'writerParams' => array(
                        'stream' => $this->config->log->file_path,
                    ),
                    'formatterName' => 'Simple',
                    'formatterParams' => array(
                        'format' => '%timestamp% %priorityName% (%priority%): %message%' . PHP_EOL,
                    )
                )
            ));

        Zend_Registry::set('logger', $logger);
    }

    protected function _initCache()
    {
        $frontendOptions = array(
            'automatic_serialization' => true,
            'lifetime' => 60
        );

        $backendOptions = array(
            'cache_dir' => $this->config->cache->save_path
        );

        $cache = Zend_Cache::factory('Core', 'File', $frontendOptions, $backendOptions);

        Zend_Registry::set('cache', $cache);
    }

    protected function _initTranslate()
    {
        $languagePath = $this->config->language->path;

        $translate = new Zend_Translate('ini', $languagePath . DS . 'zh_cn.ini', 'zh_cn');

        $translate->setLocale('zh_cn');

        Zend_Registry::set('Zend_Translate', $translate);
    }

}