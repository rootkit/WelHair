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

namespace Welfony\Controller\Plugin;

class RequestedModuleLayoutLoader extends \Zend_Controller_plugin_Abstract
{

    public function preDispatch(\Zend_Controller_Request_Abstract $request)
    {
        $config = \Zend_Controller_Front::getInstance()->getParam('bootstrap')->getOptions();
        $moduleName = $request->getModuleName();

        $layoutScript = $config['resources']['layout']['layout'];
        \Zend_Layout::getMvcInstance()->setLayout($layoutScript);

        $layoutPath = $config['resources']['layout']['layoutPath'];
        \Zend_Layout::getMvcInstance()->setLayoutPath($layoutPath);
    }

}
