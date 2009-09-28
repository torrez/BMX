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
        [sprite setRotation: CC_RADIANS_TO_DEGREES(-body->a)];
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
        cpBodyApplyImpulse(moe_body, cpv(10,10), cpv(-10,-10));

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
    
    
    cpVect moe_verts[] = { cpv(-10, -10), cpv(-10, 10), cpv(10, 10), cpv(10,-10) };
    cpFloat moe_mass = .5f;
    cpFloat moe_moment = cpMomentForPoly(moe_mass, 4, moe_verts, cpvzero);

    moe_body = cpBodyNew(moe_mass, moe_moment);
    moe_body->p = cpv(15, 140);
    cpSpaceAddBody(space, moe_body);

    
    cpShape *moe_shape = cpPolyShapeNew(moe_body, 4, moe_verts, cpvzero);
    moe_shape->e = 0.8f; 
    moe_shape->u = 0.8f; 
    moe_shape->collision_type = 1;  
    moe_shape->data = moe_sprite;
    cpSpaceAddShape(space, moe_shape);  
    
    
    cpBody* floorBody = cpBodyNew(INFINITY, INFINITY);    
    floorBody->p = cpv(0, 0);
    
    cpVect floor_verts1[] = {cpv(0,0), cpv(0,137), cpv(101,22), cpv(101,0)};
    cpVect floor_verts2[] = {cpv(101,0), cpv(101,22), cpv(207,22), cpv(207,0)};
    cpVect floor_verts3[] = {cpv(207,0), cpv(207,22), cpv(246,60), cpv(271,22), cpv(271,0)};
    cpVect floor_verts4[] = {cpv(271,0), cpv(271, 22), cpv(461,22), cpv(461,0)};
    
    
    cpShape *floorShape = cpPolyShapeNew(floorBody, 4, floor_verts1, cpvzero);
    floorShape->e = 0.5; floorShape->u = 0.1; floorShape->collision_type = 0;  
    //floorShape->data = floor;  
    cpSpaceAddStaticShape(space, floorShape); 
    
    floorShape = cpPolyShapeNew(floorBody, 4, floor_verts2, cpvzero);
    floorShape->e = 0.5; floorShape->u = 0.1; floorShape->collision_type = 0;  
    //floorShape->data = floor;  
    cpSpaceAddStaticShape(space, floorShape); 
  
    floorShape = cpPolyShapeNew(floorBody, 5, floor_verts3, cpvzero);
    floorShape->e = 0.5; floorShape->u = 0.1; floorShape->collision_type = 0;  
    //floorShape->data = floor;  
    cpSpaceAddStaticShape(space, floorShape); 
    
    floorShape = cpPolyShapeNew(floorBody, 4, floor_verts4, cpvzero);
    floorShape->e = 0.5; floorShape->u = 0.1; floorShape->collision_type = 0;  
    //floorShape->data = floor;  
    cpSpaceAddStaticShape(space, floorShape);     
}


-(void)draw{
    glColor4f(0.8, 1.0, 0.76, 1.0);  
    glLineWidth(2.0f);
    drawLine(CGPointMake(0, 137), CGPointMake(101, 22));
    drawLine(CGPointMake(101, 22), CGPointMake(207, 22));
    drawLine(CGPointMake(207, 22), CGPointMake(246, 60));
    drawLine(CGPointMake(246, 60), CGPointMake(271, 22));
    drawLine(CGPointMake(271, 22), CGPointMake(461, 22));
}    




- (void) dealloc
{
    [self unschedule:@selector(tick:)];
    
    // don't forget to call "super dealloc"
	[super dealloc];
}



@end
