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

class AbstractAdminController extends AbstractController
{

    public function init()
    {
        parent::init();
    }

    public function preDispatch()
    {
        parent::preDispatch();

        $nologinList = isset($this->nologinActionList[$this->view->controller]) ? $this->nologinActionList[$this->view->controller] : array();

        $auth = \Zend_Auth::getInstance();
        if (!in_array($this->view->action, $nologinList)) {
            if (!$this->getCurrentUser() || $this->currentUser['Role'] != UserRole::Admin) {
                $this->gotoLogin();
            }
        }
    }

}