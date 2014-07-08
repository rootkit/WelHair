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

    public function findParentAreaByChildId($childId)
    {
        $strSql = 'SELECT
                       *
                   FROM Area A
                   WHERE A.AreaId = (SELECT ParentId FROM Area CA WHERE CA.AreaId = ?)
                   LIMIT 1';

        return $this->conn->fetchAssoc($strSql, array($childId));
    }

    public function getAreasByParent($parentId)
    {
        $strSql = "SELECT
                       *
                   FROM Area A
                   WHERE A.ParentId = ?
                   ORDER BY A.Sort DESC";

        return $this->conn->fetchAll($strSql, array($parentId));
    }

    public function getAreaByName($name)
    {
        $strSql = "SELECT
                       *
                   FROM Area A
                   WHERE A.Name = ?
                   LIMIT 1";

        return $this->conn->fetchAssoc($strSql, array($name));
    }

    public function getAreaById($id)
    {
        $strSql = "SELECT
                       *
                   FROM Area A
                   WHERE A.AreaId = ?
                   LIMIT 1";

        return $this->conn->fetchAssoc($strSql, array($id));
    }

    public function getAreas()
    {
        $strSql = "SELECT
                       *
                   FROM Area A
                   ORDER BY A.AreaId ASC";

        return $this->conn->fetchAll($strSql);
    }

}
