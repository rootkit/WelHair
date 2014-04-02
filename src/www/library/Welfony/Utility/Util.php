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

    public static function getRealIp()
    {
        static $realip = NULL;

        if ($realip !== NULL) {
            return $realip;
        }

        if (isset($_SERVER)) {
            if (isset($_SERVER['HTTP_X_FORWARDED_FOR'])) {
                $arr = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);

                foreach ($arr AS $ip) {
                    $ip = trim($ip);

                    if ($ip != 'unknown') {
                        $realip = $ip;

                        break;
                    }
                }
            } elseif (isset($_SERVER['HTTP_CLIENT_IP'])) {
                $realip = $_SERVER['HTTP_CLIENT_IP'];
            } else {
                if (isset($_SERVER['REMOTE_ADDR'])) {
                    $realip = $_SERVER['REMOTE_ADDR'];
                } else {
                    $realip = '0.0.0.0';
                }
            }
        } else {
            if (getenv('HTTP_X_FORWARDED_FOR')) {
                $realip = getenv('HTTP_X_FORWARDED_FOR');
            } elseif (getenv('HTTP_CLIENT_IP')) {
                $realip = getenv('HTTP_CLIENT_IP');
            } else {
                $realip = getenv('REMOTE_ADDR');
            }
        }

        $onlineip = null;
        preg_match("/[\d\.]{7,15}/", $realip, $onlineip);

        $realip = !empty($onlineip[0]) ? $onlineip[0] : '0.0.0.0';

        return $realip;
    }

    public static function getfirstchar($s0)
    {
        $fchar = ord($s0{0});
        if ($fchar >= ord("A") and $fchar <= ord("z")) {
            return strtoupper($s0{0});
        }

        $s1 = @iconv("UTF-8","gb2312", $s0);
        $s2 = @iconv("gb2312","UTF-8", $s1);

        if ($s2 == $s0) {
            $s = $s1;
        } else {
            $s = $s0;
        }

        if (strlen($s) < 2) {
            return null;
        }

        $asc = ord($s{0}) * 256 + ord($s{1}) - 65536;
        if($asc >= -20319 and $asc <= -20284) return "A";
        if($asc >= -20283 and $asc <= -19776) return "B";
        if($asc >= -19775 and $asc <= -19219) return "C";
        if($asc >= -19218 and $asc <= -18711) return "D";
        if($asc >= -18710 and $asc <= -18527) return "E";
        if($asc >= -18526 and $asc <= -18240) return "F";
        if($asc >= -18239 and $asc <= -17923) return "G";
        if($asc >= -17922 and $asc <= -17418) return "H";
        if($asc >= -17417 and $asc <= -16475) return "J";
        if($asc >= -16474 and $asc <= -16213) return "K";
        if($asc >= -16212 and $asc <= -15641) return "L";
        if($asc >= -15640 and $asc <= -15166) return "M";
        if($asc >= -15165 and $asc <= -14923) return "N";
        if($asc >= -14922 and $asc <= -14915) return "O";
        if($asc >= -14914 and $asc <= -14631) return "P";
        if($asc >= -14630 and $asc <= -14150) return "Q";
        if($asc >= -14149 and $asc <= -14091) return "R";
        if($asc >= -14090 and $asc <= -13319) return "S";
        if($asc >= -13318 and $asc <= -12839) return "T";
        if($asc >= -12838 and $asc <= -12557) return "W";
        if($asc >= -12556 and $asc <= -11848) return "X";
        if($asc >= -11847 and $asc <= -11056) return "Y";
        if($asc >= -11055 and $asc <= -10247) return "Z";

        return null;
    }

    public static function pinyin($zh)
    {
        $ret = "";
        $s1 = @iconv("UTF-8","gb2312", $zh);
        $s2 = @iconv("gb2312","UTF-8", $s1);

        if ($s2 == $zh) {
            $zh = $s1;
        }

        for ($i = 0; $i < strlen($zh); $i++) {
            $s1 = substr($zh,$i,1);
            $p = ord($s1);
            if ($p > 160) {
                $s2 = substr($zh,$i++,2);
                $ret .= self::getfirstchar($s2);
            } else {
                $ret .= $s1;
            }
        }

        return $ret;
    }

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
