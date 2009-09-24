//
//  HUDLayer.h
//  BMX
//
//  Created by Andre Torrez on 9/23/09.
//  Copyright 2009 Simpleform. All rights reserved.
//

#import "cocos2d.h"

@class GameLayer;

@interface HUDLayer : Layer {
    Label       *speed_label;
    Label       *lean_label;
}

- (void) setSpeed:(int)s lean:(int)l;
@end
