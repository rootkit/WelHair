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

class AreaRepository extends AbstractRepository
{

    public function getAreasByParent($parentId)
    {
        $strSql = "SELECT
                       *
                   FROM Area A
                   WHERE A.ParentId = ?
                   ORDER BY A.Sort DESC";

        return $this->conn->fetchAll($strSql, array($parentId));
    }

}
