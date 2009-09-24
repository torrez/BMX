//
//  HUDLayer.m
//  BMX
//
//  Created by Andre Torrez on 9/23/09.
//  Copyright 2009 Simpleform. All rights reserved.
//

#import "HUDLayer.h"


@implementation HUDLayer

-(id) init
{
	if( (self=[super init] )) {		
        speed_label = [Label labelWithString:@"Speed: 0" fontName:@"Helvetica" fontSize:12];
        speed_label.position = ccp(50, 200);
        
        lean_label = [Label labelWithString:@"Lean: 0" fontName:@"Helvetica" fontSize:12];
        lean_label.position = ccp(50, 190);
        
        // add the label as a child to this Layer
        [self addChild: speed_label];
        [self addChild: lean_label];
	}
	return self;
}


-(void)setSpeed:(int)s lean:(int)l
{
    [speed_label    setString:[NSString stringWithFormat:@"Speed : %i", s]];
    [lean_label     setString:[NSString stringWithFormat:@"  Lean : %i", l]];   
}




- (void) dealloc
{
    
    // don't forget to call "super dealloc"
	[super dealloc];
}



@end
