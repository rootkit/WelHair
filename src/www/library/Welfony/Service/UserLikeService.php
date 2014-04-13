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

namespace Welfony\Service;

use Welfony\Repository\UserLikeRepository;

class UserLikeService
{

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if ((!isset($data['WorkId']) || intval($data['WorkId']) <= 0) &&
            (!isset($data['UserId']) || intval($data['UserId']) <= 0) &&
            (!isset($data['CompanyId']) || intval($data['CompanyId']) <= 0) &&
            (!isset($data['GoodsId']) || intval($data['GoodsId']) <= 0)) {
            $result['message'] = '请选择喜欢的对象！';

            return $result;
        }

        if (!isset($data['CreatedBy']) || intval($data['CreatedBy']) <= 0) {
            $result['message'] = '不合法的用户！';

            return $result;
        }
        $createdBy = intval($data['CreatedBy']);

        $userLike = array(
            'CreatedBy' => $createdBy,
            'CreatedDate' => date('Y-m-d H:i:s')
        );

        $isLike = intval($data['IsLike']);

        if (isset($data['WorkId']) && intval($data['WorkId']) > 0) {
            $userLike['WorkId'] = intval($data['WorkId']);
            if ($isLike > 0) {
                $existedItem = UserLikeRepository::getInstance()->findByUserAndWorkId($userLike['CreatedBy'], $userLike['WorkId']);
                if ($existedItem) {
                    $result['success'] = true;
                } else {
                    $newId = UserLikeRepository::getInstance()->save($userLike);
                    $result['success'] = $newId > 0;
                }
            } else {
                $result['success'] = UserLikeRepository::getInstance()->removeByUserAndWorkId($userLike['CreatedBy'], $userLike['WorkId']);
            }
        }

        if (isset($data['UserId']) && intval($data['UserId']) > 0) {
            $userLike['UserId'] = intval($data['UserId']);
            if ($isLike > 0) {
                $existedItem = UserLikeRepository::getInstance()->findByUserAndUserId($userLike['CreatedBy'], $userLike['UserId']);
                if ($existedItem) {
                    $result['success'] = true;
                } else {
                    $newId = UserLikeRepository::getInstance()->save($userLike);
                    $result['success'] = $newId > 0;
                }
            } else {
                $result['success'] = UserLikeRepository::getInstance()->removeByUserAndUserId($userLike['CreatedBy'], $userLike['UserId']);
            }
        }

        if (isset($data['CompanyId']) && intval($data['CompanyId']) > 0) {
            $userLike['CompanyId'] = intval($data['CompanyId']);
            if ($isLike > 0) {
                $existedItem = UserLikeRepository::getInstance()->findByUserAndCompanyId($userLike['CreatedBy'], $userLike['CompanyId']);
                if ($existedItem) {
                    $result['success'] = true;
                } else {
                    $newId = UserLikeRepository::getInstance()->save($userLike);
                    $result['success'] = $newId > 0;
                }
            } else {
                $result['success'] = UserLikeRepository::getInstance()->removeByUserAndCompanyId($userLike['CreatedBy'], $userLike['CompanyId']);
            }
        }

        if (isset($data['GoodsId']) && intval($data['GoodsId']) > 0) {
            $userLike['GoodsId'] = intval($data['GoodsId']);
            if ($isLike > 0) {
                $existedItem = UserLikeRepository::getInstance()->findByUserAndGoodsId($userLike['CreatedBy'], $userLike['GoodsId']);
                if ($existedItem) {
                    $result['success'] = true;
                } else {
                    $newId = UserLikeRepository::getInstance()->save($userLike);
                    $result['success'] = $newId > 0;
                }
            } else {
                $result['success'] = UserLikeRepository::getInstance()->removeByUserAndGoodsId($userLike['CreatedBy'], $userLike['GoodsId']);
            }
        }

        return $result;
    }

}
