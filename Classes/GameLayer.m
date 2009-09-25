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


void updateShape(void* ptr, void* unused)
{
    cpShape *shape = (cpShape*)ptr;
    Sprite *sprite = shape->data;
    if (sprite) {
        cpBody *body = shape->body;
        [sprite setPosition:ccp(body->p.x, body->p.y)];
    }
}



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
    
    cpSpaceStep(space, 1.0f/60.0f);
    cpSpaceHashEach(space->activeShapes, &updateShape, nil);

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
     
        moe_sprite = [Sprite spriteWithFile:@"moe-block.png"];
        
        [moe_sprite setPosition:CGPointMake(150, 300)];
        
        [self addChild:moe_sprite];
        
        
        
        [self setupChipmunk];

		[self schedule: @selector(tick:) interval:FRAMERATE];
    }
	return self;
}

-(void)setupChipmunk{
    
    cpInitChipmunk();
    
    space = cpSpaceNew();
    space->gravity = cpv(0,-2000);
    space->elasticIterations = 1;
    
    
    cpBody* ballBody = cpBodyNew(200.0, INFINITY);
    ballBody->p = cpv(150, 400);
    cpSpaceAddBody(space, ballBody);
    cpShape* ballShape = cpCircleShapeNew(ballBody, 20.0, cpvzero);
    
    
    ballShape->e = 0.8;
    ballShape->u = 0.8;
    ballShape->data = moe_sprite;
    ballShape->collision_type = 1;
    
    cpSpaceAddShape(space, ballShape);
    
    cpBody* floorBody = cpBodyNew(INFINITY, INFINITY);    
    floorBody->p = cpv(0, 0);
    
    cpShape* floorShape = cpSegmentShapeNew(floorBody, cpv(0,0), cpv(320,0), 0);
    floorShape->e = 0.5;
    floorShape->u = 0.1;
    floorShape->collision_type = 0;
    
    cpSpaceAddStaticShape(space, floorShape);
    
}

- (void) dealloc
{
    [self unschedule:@selector(tick:)];
    
    // don't forget to call "super dealloc"
	[super dealloc];
}



@end
