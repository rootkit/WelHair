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

use Welfony\Repository\FeedbackRepository;

class FeedbackService
{

    public static function save($data)
    {
        $result = array('success' => false, 'message' => '');

        if (empty($data['Body'])) {
            $result['message'] = '请填写点儿什么吧。';

            return $result;
        }

        if ($data['FeedbackId'] == 0) {
            $data['CreatedDate'] = date('Y-m-d H:i:s');

            $newId = FeedbackRepository::getInstance()->save($data);
            if ($newId) {
                $data['FeedbackId'] = $newId;

                $result['success'] = true;
                $result['feedback'] = $data;

                return $result;
            } else {
                $result['message'] = '添加反馈失败！';

                return $result;
            }
        }
    }

    public static function listAllFeedback($page, $pageSize)
    {
        $page = $page <= 0 ? 1 : $page;
        $pageSize = $pageSize <= 0 ? 20 : $pageSize;

        $total = FeedbackRepository::getInstance()->getAllFeedbackCount();
        $feedbackList = FeedbackRepository::getInstance()->getAllFeedback($page, $pageSize);

        return array('total' => $total, 'feedback' => $feedbackList);
    }

}
