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

class UserLikeRepository extends AbstractRepository
{

    public function save($data)
    {
        try {
            if ($this->conn->insert('UserLike', $data)) {
                return $this->conn->lastInsertId();
            }
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }

        return false;
    }

    public function update($userLikeId, $data)
    {
        try {
            return $this->conn->update('UserLike', $data, array('UserLikeId' => $userLikeId));
        } catch (\Exception $e) {
            $this->logger->log($e, \Zend_Log::ERR);

            return false;
        }
    }

}
