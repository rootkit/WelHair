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

use Welfony\Controller\API\UploadController;

$app->post('/upload/image', function() use($app)
{
    $controller = new UploadController();
    $controller->image('uploadfile');
});

$app->post('/upload/image/crop', function() use($app)
{
    $controller = new UploadController();
    $controller->imageCrop();
});