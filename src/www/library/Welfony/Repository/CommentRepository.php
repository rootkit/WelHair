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

class CommentRepository extends AbstractRepository
{

    public function findCommentById($commentId)
    {
        $strSql = 'SELECT
                       *
                   FROM Comment C
                   WHERE C.CommentId = ?
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($commentId));
    }

    public function getAllCommentCount($companyId, $workId, $userId, $goodsId)
    {
        $filter = '';
        $paramArr = array();
        if ($companyId !== null) {
            $filter .= ' AND C.CompanyId = ?';
            $paramArr[] = $companyId;
        }
        if ($workId !== null) {
            $filter .= ' AND C.WorkId = ?';
            $paramArr[] = $workId;
        }
        if ($userId !== null) {
            $filter .= ' AND C.UserId = ?';
            $paramArr[] = $userId;
        }
        if ($goodsId !== null) {
            $filter .= ' AND C.GoodsId = ?';
            $paramArr[] = $goodsId;
        }

        $strSql = "SELECT
                       COUNT(1) `Total`
                   FROM Comment C
                   WHERE C.CommentId > 0 $filter
                   LIMIT 1";

        $row = $this->conn->fetchAssoc($strSql, $paramArr);

        return $row['Total'];
    }

    public function getAllComments($companyId, $workId, $userId, $goodsId, $page, $pageSize)
    {
        $filter = '';
        $paramArr = array();
        if ($companyId !== null) {
            $filter .= ' AND C.CompanyId = ?';
            $paramArr[] = $companyId;
        }
        if ($workId !== null) {
            $filter .= ' AND C.WorkId = ?';
            $paramArr[] = $workId;
        }
        if ($userId !== null) {
            $filter .= ' AND C.UserId = ?';
            $paramArr[] = $userId;
        }
        if ($goodsId !== null) {
            $filter .= ' AND C.GoodsId = ?';
            $paramArr[] = $goodsId;
        }

        $offset = ($page - 1) * $pageSize;
        $strSql = "SELECT
                       C.CommentId,
                       C.Rate,
                       C.Body,
                       C.PictureUrl,
                       C.CreatedDate,

                       U.UserId,
                       U.Username,
                       U.Nickname,
                       U.Email,
                       U.AvatarUrl
                   FROM Comment C
                   INNER JOIN Users U ON U.UserId = C.CreatedBy
                   WHERE C.CommentId > 0 $filter
                   ORDER BY C.CommentId DESC
                   LIMIT $offset, $pageSize";

        return $this->conn->fetchAll($strSql, $paramArr);
    }

    public function save($data)
    {
        try {
            if ($this->conn->insert('Comment', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($commentId, $data)
    {
        try {
            return $this->conn->update('Comment', $data, array('CommentId' => $commentId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
