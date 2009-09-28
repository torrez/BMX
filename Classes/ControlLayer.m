//
//  ControlLayer.m
//  BMX
//
//  Created by Andre Torrez on 9/23/09.
//  Copyright 2009 Simpleform. All rights reserved.
//

#import "ControlLayer.h"
#import "GameLayer.h"

@implementation ControlLayer

@synthesize game_layer;

-(id) init
{
	if( (self=[super init] )) {		
        isTouchEnabled = YES;
        
        Sprite *sprite = [Sprite spriteWithFile:@"dpad.png"];
        sprite.position = ccp((float)420, (float)60);
        dpad_rect = CGRectMake(sprite.position.x - (100 /2), sprite.position.y - (100 /2), 100,100);
        [self addChild: sprite];
	}
	return self;
}


- (BOOL) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{	
	// Loop through new touches and test the points of contact
	for (id item in touches)
	{
        UITouch *touch   = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        CGPoint cLoc     = [[Director sharedDirector] convertCoordinate: location];

		[self testTouchPoint:cLoc isLifted:NO];        
	}
	
	return YES;
}

- (BOOL) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *) event
{
	// Get all current touches on screen
	NSSet *allTouches = [event allTouches];
	
	// Loop through all touches and check which buttons are pressed
	for (id item in allTouches)
	{
        UITouch *touch   = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        CGPoint cLoc     = [[Director sharedDirector] convertCoordinate: location];
        
		[self testTouchPoint:cLoc isLifted:NO];
	}
    return kEventHandled;
}

- (BOOL) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *) event
{
	// Loop through touches that have ended and check the point of lift
	for (id item in touches)
	{
        UITouch *touch   = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        CGPoint cLoc     = [[Director sharedDirector] convertCoordinate: location];
        
		[self testTouchPoint:cLoc isLifted:YES];
	}
	
    return kEventHandled;
}


- (void) testTouchPoint: (CGPoint)point isLifted:(BOOL)is_lifted
{
    if (is_lifted) {
        [game_layer shouldStop];
    } else {
        if (CGRectContainsPoint(dpad_rect, point))
        {
            int speed = 0;
            int lean = 0;
            
            //where in the box?
            speed = (point.y - dpad_rect.origin.y);
            lean = (point.x - dpad_rect.origin.x) - 50;
            
            [game_layer shouldGo:speed lean:lean];
        } else {
            [game_layer shouldStop];
        }
    }
}


- (void) dealloc
{
    
    // don't forget to call "super dealloc"
	[super dealloc];
}


@end
