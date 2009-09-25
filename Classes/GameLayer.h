#import "cocos2d.h"
#import "chipmunk.h"

@class HUDLayer;

@interface GameLayer : Layer {
    HUDLayer    *hud_layer;
    BOOL        is_moving;
    int         speed;
    int         lean;

    Sprite      *moe_sprite;
    cpSpace     *space;
}

@property (nonatomic,retain) HUDLayer *hud_layer;

+(id) scene;
-(void) shouldStop;
-(void) shouldGo:(int)speed lean:(int)lean;
-(void) updateHUD;
-(void) setupChipmunk;
@end
