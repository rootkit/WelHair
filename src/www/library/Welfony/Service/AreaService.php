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

use Welfony\Repository\AreaRepository;

class AreaService
{

    const ROOT_ID = 0;

    public static function listAreaByParent($parentId)
    {
        $areaList = AreaRepository::getInstance()->getAreasByParent($parentId);
        return $areaList;
    }

    public static function listAllAreas()
    {
        $result = AreaRepository::getInstance()->getAreas();

        $rows = array();
        foreach ($result as $row) {
            $rows[$row['AreaId']] = $row;
        }

        $t = array();
        foreach ($rows as $id => $item) {
            if (isset($item['ParentId'])) {
                if (self::ROOT_ID == $item['ParentId']) {
                    $rows[$item['ParentId']][$item['AreaId']] = &$rows[$item['AreaId']];
                } else {
                    $rows[$item['ParentId']]['Children'][$item['AreaId']] = &$rows[$item['AreaId']];
                }

                $t[] = $id;
            }
        }

        foreach($t as $u) {
            unset($rows[$u]);
        }

        $areaList = array();
        foreach ($rows[0] as $area) {
            unset($area['Sort']);
            unset($area['ParentId']);

            $area['Child'] = array();

            if (isset($area['Children']) && count($area['Children']) > 0) {
                foreach ($area['Children'] as $child) {
                    unset($child['Sort']);
                    unset($child['ParentId']);

                    $child['Child'] = array();

                    if (isset($child['Children']) && count($child['Children']) > 0) {
                        foreach ($child['Children'] as $childChild) {
                            unset($childChild['Sort']);
                            unset($childChild['ParentId']);

                            $child['Child'][] = $childChild;
                        }

                        unset($child['Children']);
                    }

                    $area['Child'][] = $child;
                }

                unset($area['Children']);
            }

            $areaList[] = $area;
        }

        return $areaList;
    }

}
