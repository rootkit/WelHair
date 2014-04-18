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

namespace Welfony\Repository;

use Welfony\Repository\Base\AbstractRepository;

class FeedbackRepository extends AbstractRepository
{

    public function getAllFeedbackCount()
    {
        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Feedback F
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql);

        return $row['Total'];
    }

    public function getAllFeedback($page, $pageSize)
    {
        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       F.*
                   FROM Feedback F
                   ORDER BY F.FeedbackId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql);
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Feedback', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function remove($feedbackId)
    {
        try {
            $this->conn->delete('Feedback', array('FeedbackId' => $feedbackId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return true;
    }

}
