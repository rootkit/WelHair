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

namespace Welfony\Utility;

class Util
{

    public static function baseAssetUrl($path = '')
    {
        $config = \Zend_Registry::get('config');
        return $config->asset->baseUrl . '/' . $path;
    }

    public static function genRandomNum($length, $strength = 6)
    {
        $vowels = 'aeuy';
        $consonants = 'bdghjmnpqrstvz';
        if ($strength >= 1) {
            $consonants .= 'BDGHJLMNPQRSTVWXZ';
        }
        if ($strength >= 2) {
            $vowels .= "AEUY";
        }
        if ($strength >= 4) {
            $consonants .= '23456789';
        }
        if ($strength >= 8) {
            $consonants .= '@#$%';
        }

        $password = '';
        $alt = time() % 2;
        for ($i = 0; $i < $length; $i++) {
            if ($alt == 1) {
                $password .= $consonants[(rand() % strlen($consonants))];
                $alt = 0;
            } else {
                $password .= $vowels[(rand() % strlen($vowels))];
                $alt = 1;
            }
        }

        return $password;
    }

    public static function genRandomUsername($prefix = 'wh')
    {
        static $nicknameFormat = '%s-%s';
        return sprintf($nicknameFormat, $prefix, strtolower(self::genRandomNum(8)));
    }

    public static function genRandomEmail($prefix = 'wh')
    {
        static $emailFormat = '%s-%s@welhair.com';
        return sprintf($emailFormat, $prefix, strtolower(self::genRandomNum(8)));
    }

    public static function genRandomPassword()
    {
        return self::genRandomNum(6);
    }


    public static function renderButton($url, $buttonLabel, $pageNumber, $pageCount, $ajaxfunc = '')
    {
        $baseClass = '';
        $href = '';
        if ($buttonLabel == "prev") {
            if (empty($ajaxfunc)) {
                $href = ' href="' . ($url . '&page=' . ($pageNumber - 1)) . '"';
            } else {
                $href = ' href="javascript:;" onclick="' . $ajaxfunc . '(' . ($pageNumber - 1) . ')"';
            }
            $button = $pageNumber <= 1 ? '<a class="' . $baseClass . ' first pageprv z-dis">上一页</a>' : '<a class="' . $baseClass . '"' . $href . '>Previous</a>';
        } else {
            if (empty($ajaxfunc)) {
                $href = ' href="' . ($url . '&page=' . ($pageNumber + 1)) . '"';
            } else {
                $href = ' href="javascript:;" onclick="' . $ajaxfunc . '(' . ($pageNumber + 1) . ')"';
            }
            $button = $pageNumber >= $pageCount ? '<a class="' . $baseClass . ' last pagenxt">下一页</a>' : '<a class="' . $baseClass . '"' . $href . '>Next</a>';
        }
        return $button;
    }

    public static function renderPager($url, $pageNumber, $pageCount, $ajaxfunc = '')
    {
        $baseClass = '';
        $pager = '';
        $pager = $pager . Util::renderButton($url, 'prev', $pageNumber, $pageCount, $ajaxfunc);

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
                $href = ' href="' . ($url . '&page=' . $page) . '"';
            } else {
                $href = ' href="javascript:;" onclick="' . $ajaxfunc . '(' . $page . ')"';
            }
            $currentButton = ($page == $pageNumber) ? '<a class="' . $baseClass . ' z-crt">' . $page . '</a>' : '<a class="' . $baseClass . '"' . $href . '>' . $page . '</a>';
            $pager = $pager . $currentButton;
        }

        $pager = $pager . Util::renderButton($url, 'next', $pageNumber, $pageCount, $ajaxfunc);

        return $pager;
    }

}