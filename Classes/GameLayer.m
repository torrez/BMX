//
//  GameLayer.m
//  BMX
//
//  Created by Andre Torrez on 9/23/09.
//  Copyright 2009 Simpleform. All rights reserved.
//

#import "GameLayer.h"
#import "HUDLayer.h"
#import "ControlLayer.h"

#define FRAMERATE 0.01



@implementation GameLayer

@synthesize hud_layer;

+(id) scene
{
	Scene *scene = [Scene node];
	
	GameLayer       *game_layer     = [GameLayer node];
    HUDLayer        *hud_layer      = [HUDLayer node];
    ControlLayer    *control_layer   = [ControlLayer node];
    
    control_layer.game_layer = game_layer;
    game_layer.hud_layer = hud_layer;
	
	[scene addChild: game_layer     z:0];
    [scene addChild: control_layer  z:1];
    [scene addChild: hud_layer      z:2];
    	
	return scene;
}

- (void) tick: (ccTime) dt
{	
    if (is_moving) {
        [self updateHUD];
    }   
}

- (void)shouldGo:(int)s lean:(int)l
{
    speed = s;
    lean  = l;
    is_moving = YES;
}

- (void)shouldStop
{
    speed   = 0;
    lean    = 0;
    is_moving = NO;
    [self updateHUD];
}

-(void) updateHUD
{
    [hud_layer setSpeed:speed lean:lean];
}

-(id) init
{
	if( (self=[super init] )) {
        is_moving = NO;
        speed = 0;
        lean = 0;        
        
		[self schedule: @selector(tick:) interval:FRAMERATE];
    }
	return self;
}

- (void) dealloc
{

    // don't forget to call "super dealloc"
	[super dealloc];
}



@end
