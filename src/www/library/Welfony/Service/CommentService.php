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

use Welfony\Repository\CommentRepository;

class CommentService
{

    public static function listComment($companyId, $workId, $userId, $goodsId, $page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;
        $result = array('');

        $total = CommentRepository::getInstance()->getAllCommentCount($companyId, $workId, $userId, $goodsId);

        $tempRst = CommentRepository::getInstance()->getAllComments($companyId, $workId, $userId, $goodsId, $page, $pageSize);
        $comments = self::assembleCommentList($tempRst);

        return array('total' => $total, 'comments' => $comments);
    }

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (!isset($data['CreatedBy']) || intval($data['CreatedBy']) <= 0) {
            $result['message'] = '不合法的用户！';
            return $result;
        }
        $createdBy = intval($data['CreatedBy']);

        if (!isset($data['Rate']) || intval($data['Rate']) <= 0) {
            $result['message'] = '请选择评分！';
            return $result;
        }
        $rate = intval($data['Rate']);

        if (!isset($data['Body']) || empty($data['Body'])) {
            $result['message'] = '请填写点什么吧！';
            return $result;
        }
        $body = htmlspecialchars($data['Body']);

        $comment = array(
            'Deep' => 0,
            'Rate' => $rate,
            'Body' => $body,
            'PictureUrl' => isset($data['PictureUrl']) && is_array($data['PictureUrl']) ? json_encode($data['PictureUrl']) : '{}',
            'CreatedBy' => $createdBy,
            'CreatedDate' => date('Y-m-d H:i:s')
        );

        if (isset($data['CompanyId'])) {
            $comment['CompanyId'] = intval($data['CompanyId']);
        }

        if (isset($data['WorkId'])) {
            $comment['WorkId'] = intval($data['WorkId']);
        }

        if (isset($data['UserId'])) {
            $comment['UserId'] = intval($data['UserId']);
        }

        if (isset($data['GoodsId'])) {
            $comment['GoodsId'] = intval($data['GoodsId']);
        }

        if (isset($data['ParentId'])) {
            $comment['ParentId'] = intval($data['ParentId']);
            $parent = CommentRepository::getInstance()->findCommentById($comment['ParentId']);
            if ($parent) {
                $comment['Deep'] = $parent['Deep'] + 1;
            }
        }

        $newId = CommentRepository::getInstance()->save($comment);
        if ($newId) {
            $comment['CommentId'] = $newId;
            $comment['PictureUrl'] = json_decode($comment['PictureUrl'], true);

            $result['success'] = true;
            $result['comment'] = $comment;
        }

        return $result;
    }

    private static function assembleCommentList($tempRst)
    {
        $comments = array();
        foreach ($tempRst as $row) {
            $comment = array(
                'CommentId' => $row['CommentId'],
                'Rate' => $row['Rate'],
                'Body' => htmlspecialchars_decode($row['Body']),
                'PictureUrl' => json_decode($row['PictureUrl'], true),
                'CreatedDate' => $row['CreatedDate'],
                'CreatedBy' => array(
                    'UserId' => $row['UserId'],
                    'Username' => $row['Username'],
                    'Nickname' => $row['Nickname'],
                    'Email' => $row['Email'],
                    'AvatarUrl' => $row['AvatarUrl']
                )
            );

            $comments[] = $comment;
        }

        return $comments;
    }

}
