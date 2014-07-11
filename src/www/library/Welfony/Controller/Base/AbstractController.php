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

use Welfony\Service\UserService;

class AbstractController extends \Zend_Controller_Action
{

    const PAGER_FIRST = '首页';
    const PAGER_PREV = '上一页';
    const PAGER_NEXT = '下一页';
    const PAGER_LAST = '最后';

    protected static $loginUrl = '/user/auth/signin';

    protected $successMessage;
    protected $errorMessage;
    protected $config;

    protected $nologinActionList = array();
    protected $needloginActionList = array();

    public function init()
    {
        parent::init();
    }

    public function preDispatch()
    {
        parent::preDispatch();

        $request = $this->getRequest();
        $this->view->module = $request->getModuleName();
        $this->view->controller = $request->getControllerName();
        $this->view->action = $request->getActionName();

        $sessionId = $request->getParam('sid');
        if (!empty($sessionId) && session_id() !== $sessionId) {
            session_destroy();
            session_id($sessionId);
            session_start();
        }
        $this->view->sessionId = session_id();

        $this->config = \Zend_Registry::get('config');
        $this->view->config = $this->config;

        $this->view->continueUrl = str_replace($this->view->baseUrl(), '', $this->_request->getRequestUri());
    }

    protected function refreshCurrentUser()
    {
        $rstNewUserInfo = UserService::signInWithUserId($this->currentUser['UserId']);

        $auth = \Zend_Auth::getInstance();
        $auth->getStorage()->write($rstNewUserInfo['user']);

        $this->getCurrentUser();
    }

    protected function getCurrentUser()
    {
        $auth = \Zend_Auth::getInstance();
        if ($auth->hasIdentity()) {
            $this->currentUser = $auth->getIdentity();
        } else {
            $this->currentUser = null;
        }
        $this->view->currentUser = $this->currentUser;

        return $this->view->currentUser;
    }

    protected function signOut()
    {
        $auth = \Zend_Auth::getInstance();
        $auth->clearIdentity();

        \Zend_Session::forgetMe();

        $this->gotoLogin(true);
    }

    protected function gotoLogin($noContinue = false)
    {
        $this->_redirect(self::$loginUrl . ($noContinue || $continue == '/' ? '' : '?continue=' . $this->view->continueUrl));
    }

    protected function renderPager($url, $pageNumber, $pageCount, $ajaxfunc = '')
    {
        $pageNumber = $pageNumber <= 0 ? 1 : $pageNumber;

        $pager = '<div class="m-page m-page-rt">';
        $baseClass = '';
        $pager .= $this->renderButton($url, 'first', $pageNumber, $pageCount, $ajaxfunc);
        $pager .= $this->renderButton($url, 'prev', $pageNumber, $pageCount, $ajaxfunc);

        $startPoint = 1;
        $endPoint = 9;

        if ($pageNumber > 4) {
            $startPoint = $pageNumber - 4;
            $endPoint = $pageNumber + 4;
        }

        if ($endPoint > $pageCount) {
            $startPoint = $pageCount - 8;
            $endPoint = $pageCount;
        }

        if ($startPoint < 1) {
            $startPoint = 1;
        }

        $href = '';
        for ($page = $startPoint; $page <= $endPoint; $page++) {
            if (empty($ajaxfunc)) {
                $href = ' href="' . str_replace('?&', '?', $url . '&page=' . $page) . '"';
            } else {
                $href = ' href="javascript:;" onclick="' . $ajaxfunc . '(' . $page . ')"';
            }
            $currentButton = ($page == $pageNumber) ? '<a class="' . $baseClass . ' z-dis">' . $page . '</a>' : '<a class="' . $baseClass . '"' . $href . '>' . $page . '</a>';
            $pager .= $currentButton;
        }

        $pager .= $this->renderButton($url, 'next', $pageNumber, $pageCount, $ajaxfunc);
        $pager .= $this->renderButton($url, 'last', $pageNumber, $pageCount, $ajaxfunc);

        return $pager . '</div>';
    }

    protected function renderButton($url, $buttonLabel, $pageNumber, $pageCount, $ajaxfunc = '')
    {
        $baseClass = '';
        $href = '';
        if ($buttonLabel == "prev") {
            if (empty($ajaxfunc)) {
                $href = ' href="' . ($url . '&page=' . ($pageNumber - 1)) . '"';
            } else {
                $href = ' href="javascript:;" onclick="' . $ajaxfunc . '(' . ($pageNumber - 1) . ')"';
            }
            $button = $pageNumber <= 1 ? '<a class="' . $baseClass . ' z-dis">' . self::PAGER_PREV . '</a>' : '<a class="' . $baseClass . '"' . $href . '>' . self::PAGER_PREV . '</a>';
        } elseif ($buttonLabel == "first") {
            if (empty($ajaxfunc)) {
                $href = ' href="' . $url . '&page=1' . '"';
            } else {
                $href = ' href="javascript:;" onclick="' . $ajaxfunc . '(1)"';
            }
            $button = $pageNumber <= 1 ? '<a class="' . $baseClass . ' z-dis">' . self::PAGER_FIRST . '</a>' : '<a class="' . $baseClass . '"' . $href . '>' . self::PAGER_FIRST . '</a>';
        } elseif ($buttonLabel == "last") {
            if (empty($ajaxfunc)) {
                $href = ' href="' . ($url . '&page=' . $pageCount) . '"';
            } else {
                $href = ' href="javascript:;" onclick="' . $ajaxfunc . '(' . $pageCount . ')"';
            }
            $button = $pageNumber >= $pageCount ? '<a class="' . $baseClass . ' z-dis">' . self::PAGER_LAST . '</a>' : '<a class="' . $baseClass . '"' . $href . '>' . self::PAGER_LAST . '</a>';
        } else {
            if (empty($ajaxfunc)) {
                $href = ' href="' . ($url . '&page=' . ($pageNumber + 1)) . '"';
            } else {
                $href = ' href="javascript:;" onclick="' . $ajaxfunc . '(' . ($pageNumber + 1) . ')"';
            }
            $button = $pageNumber >= $pageCount ? '<a class="' . $baseClass . ' z-dis">' . self::PAGER_NEXT . '</a>' : '<a class="' . $baseClass . '"' . $href . '>' . self::PAGER_NEXT . '</a>';
        }

        return $button;
    }

}
