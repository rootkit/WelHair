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

class AbstractFrontendController extends AbstractController
{

    public function init()
    {
        parent::init();
    }

    public function preDispatch()
    {
        parent::preDispatch();

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
