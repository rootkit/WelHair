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

namespace Welfony\Repository\Base;

class AbstractRepository
{

    protected $conn;
    protected $logger;

    public static function getInstance()
    {
        static $instance = null;
        if (null === $instance) {
            $instance = new static();
        }

        return $instance;
    }

    public function __construct()
    {
        $this->conn = \Zend_Registry::get('conn');
        $this->logger = \Zend_Registry::get('logger');
    }

}
