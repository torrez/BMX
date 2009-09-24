//
//  ControlLayer.h
//  BMX
//
//  Created by Andre Torrez on 9/23/09.
//  Copyright 2009 Simpleform. All rights reserved.
//

#import "cocos2d.h"

@class GameLayer;

@interface ControlLayer : Layer {
    GameLayer   *game_layer;
    CGRect      dpad_rect;

}

@property (nonatomic,retain) GameLayer *game_layer;

- (void)testTouchPoint:(CGPoint)point isLifted:(BOOL)is_lifted;
@end
