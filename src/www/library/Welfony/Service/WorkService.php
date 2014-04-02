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

use Welfony\Repository\WorkRepository;

class WorkService
{
    public static function search($currentUserId, $city, $gender, $hairStyle, $sort, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = WorkRepository::getInstance()->searchCount($city, $gender, $hairStyle);
        $workList = WorkRepository::getInstance()->search($currentUserId, $city, $gender, $hairStyle, $sort, $page, $pageSize);

        $works = array();
        foreach ($workList as $work) {
            $work['PictureUrl'] = json_decode($work['PictureUrl'], true);
            if (intval($work['CommentId']) > 0) {
                $work['Comment'] = array(
                    'CommentId' => $work['CommentId'],
                    'Body' => $work['Body'],
                    'User' => array(
                        'UserId' => $work['CommentUserId'],
                        'AvatarUrl' => $work['CommentAvatarUrl'],
                        'Nickname' => $work['CommentNickname']
                    )
                );
            } else {
                $work['Comment'] = array();
            }

            unset($work['CommentId']);
            unset($work['Body']);
            unset($work['CommentUserId']);
            unset($work['CommentAvatarUrl']);
            unset($work['CommentNickname']);

            if (intval($work['StaffUserId']) > 0) {
                $work['Staff'] = array(
                    'UserId' => $work['StaffUserId'],
                    'AvatarUrl' => $work['StaffAvatarUrl'],
                    'Nickname' => $work['StaffNickname']
                );
            } else {
                $work['Staff'] = array();
            }

            unset($work['StaffUserId']);
            unset($work['StaffAvatarUrl']);
            unset($work['StaffNickname']);

            $works[] = $work;
        }

        return array('total' => $total, 'works' => $works);
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (empty($data['Title'])) {
            $result['message'] = '请填写标题。';

            return $result;
        }

        if (empty($data['Face'])) {
            $result['message'] = '请选择脸型。';

            return $result;
        }

        if (count($data['PictureUrl']) <= 0) {
            $result['message'] = '请至少选择一张作品图片。';

            return $result;
        }

        $data['PictureUrl'] = json_encode($data['PictureUrl'], true);

        if ($data['WorkId'] == 0) {
            $data['CreatedDate'] = date('Y-m-d H:i:s');

            $newId = WorkRepository::getInstance()->save($data);
            if ($newId) {
                $data['WorkId'] = $newId;

                $result['success'] = true;
                $result['work'] = $data;

                return $result;
            } else {
                $result['message'] = '添加作品失败！';

                return $result;
            }
        } else {
            $data['LastModifiedDate'] = date('Y-m-d H:i:s');

            $result['success'] = WorkRepository::getInstance()->update($data['WorkId'], $data);
            $result['message'] = $result['success'] ? '更新作品成功！' : '更新作品失败！';

            return $result;
        }
    }

    public static function listAllWorks($page, $pageSize, $staffId)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = WorkRepository::getInstance()->getAllWorksCount($staffId);
        $workList = WorkRepository::getInstance()->getAllWorks($page, $pageSize, $staffId);
        $works = array();
        foreach ($workList as $work) {
            $work['PictureUrl'] = json_decode($work['PictureUrl'], true);
            $works[] = $work;
        }

        return array('total' => $total, 'works' => $works);
    }

    public static function getWorkById($workId)
    {
        $work = WorkRepository::getInstance()->findWorkById($workId);
        $work['PictureUrl'] = json_decode($work['PictureUrl'], true);

        return $work;
    }

}
