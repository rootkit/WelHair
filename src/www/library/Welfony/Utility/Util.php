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

    public static function keyValueExistedInArray($arr, $key, $value)
    {
        foreach ($arr as $idx => $row) {
            if ($row[$key] == $value) {
                return $idx;
            }
        }

        return false;
    }

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
        static $nicknameFormat = '%s%s';

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

}
