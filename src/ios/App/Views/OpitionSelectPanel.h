//
//  OpitionSelectPanel.h
//  WelHair
//
//  Created by lu larry on 3/2/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectOpition.h"
typedef void(^cancelSelection)(void);
typedef void(^submitSelection)(SelectOpition *);

@interface OpitionSelectPanel : UIView

- (void)setupTitle:(NSString *)title
          opitions:(SelectOpition *)selectOptioin
            cancel:(cancelSelection )cancelHandler
            submit:(submitSelection )submitHandler;
;


@end
