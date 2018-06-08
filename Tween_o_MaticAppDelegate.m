//
//  Tween_o_MaticAppDelegate.m
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 25/03/2010.
//

#import "Tween_o_MaticAppDelegate.h"
#import "TimingFunction.h"
#import "YXEasing.h"


@interface Tween_o_MaticAppDelegate ()

@property(nonatomic, assign) NSInteger curveTypeIndex;
@property(nonatomic, assign) NSInteger curveTypeIndex1;

@end

@implementation Tween_o_MaticAppDelegate

@synthesize window=_window;
@synthesize grid=_grid;
@synthesize demoImage=_demoImage;
@synthesize curveTypes=_curveTypes;
@synthesize timingFunction=_timingFunction;
@synthesize demoAnimationStartX=_demoAnimationStartX;
@synthesize demoAnimationEndX=_demoAnimationEndX;

@synthesize curveTypeDropDown=_curveTypeDropDown;
@synthesize cp1X=_cp1X;
@synthesize cp1Y=_cp1Y;
@synthesize cp2X=_cp2X;
@synthesize cp2Y=_cp2Y;
@synthesize constructor=_constructor;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.grid.cp1 = NSMakePoint(0.0, 0.3);
    self.grid.cp2 = NSMakePoint(0.8, 1.0);
    self.grid.delegate = self;
    
    self.curveTypes = [NSArray arrayWithObjects:
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionDefault 
                                    constantName:@"kCAMediaTimingFunctionDefault" 
                                  andDescription:@"默认值"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionEaseIn 
                                    constantName:@"kCAMediaTimingFunctionEaseIn" 
                                  andDescription:@"Ease In"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionEaseOut 
                                    constantName:@"kCAMediaTimingFunctionEaseOut" 
                                  andDescription:@"Ease Out"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionEaseInEaseOut 
                                    constantName:@"kCAMediaTimingFunctionEaseInEaseOut" 
                                  andDescription:@"Ease In Out"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionLinear 
                                    constantName:@"kCAMediaTimingFunctionLinear" 
                                  andDescription:@"线性"] autorelease],
       [[[TimingFunction alloc] initWithFunction:nil 
                                    constantName:nil 
                                  andDescription:@"自定义"] autorelease],
       [[[TimingFunction alloc] initWithFunction:nil
                                                    constantName:nil
                                                  andDescription:@"EasingFunctionLinearInterpolation"] autorelease],

                       [[[TimingFunction alloc] initWithFunction:nil
                                                    constantName:nil
                                                  andDescription:@"EasingFunctionEaseIn"] autorelease],

                       [[[TimingFunction alloc] initWithFunction:nil
                                                    constantName:nil
                                                  andDescription:@"EasingFunctionEaseOut"] autorelease],
                       [[[TimingFunction alloc] initWithFunction:nil
                                                    constantName:nil
                                                  andDescription:@"EasingFunctionEaseInOut"] autorelease],
      nil
    ];

    self.curveTypes1 = [NSArray arrayWithObjects:
                       [[[TimingFunction alloc] initWithFunction:@"Quadratic"
                                                    constantName:@"Quadratic"
                                                  andDescription:@"默认值"] autorelease],
                       [[[TimingFunction alloc] initWithFunction:@"Cubic"
                                                    constantName:@"Cubic"
                                                  andDescription:@"Cubic"] autorelease],
                        [[[TimingFunction alloc] initWithFunction:@"Quartic"
                                                     constantName:@"Quartic"
                                                   andDescription:@"Quartic"] autorelease],
                        [[[TimingFunction alloc] initWithFunction:@"Quintic"
                                                     constantName:@"Quintic"
                                                   andDescription:@"Quintic"] autorelease],
                        [[[TimingFunction alloc] initWithFunction:@"Sine"
                                                     constantName:@"Sine"
                                                   andDescription:@"Sine"] autorelease],
                        [[[TimingFunction alloc] initWithFunction:@"Circular"
                                                     constantName:@"Circular"
                                                   andDescription:@"Circular"] autorelease],
                        [[[TimingFunction alloc] initWithFunction:@"Exponential"
                                                     constantName:@"Exponential"
                                                   andDescription:@"Exponential"] autorelease],
                        [[[TimingFunction alloc] initWithFunction:@"Elastic"
                                                     constantName:@"Elastic"
                                                   andDescription:@"Elastic"] autorelease],
                        [[[TimingFunction alloc] initWithFunction:@"Back"
                                                     constantName:@"Back"
                                                   andDescription:@"Back"] autorelease],
                        [[[TimingFunction alloc] initWithFunction:@"Bounce"
                                                     constantName:@"Bounce"
                                                   andDescription:@"Bounce"] autorelease],
                       nil
                       ];
    
    [self.curveTypeDropDown removeAllItems];
    for (TimingFunction* tf in self.curveTypes) {
        [self.curveTypeDropDown addItemWithTitle:tf.description];
    }

    [self.curveTypeDropDown1 removeAllItems];
    for (TimingFunction* tf in self.curveTypes1) {
        [self.curveTypeDropDown1 addItemWithTitle:tf.description];
    }
    
    [self updateTimingFunction:nil];
    
    [self updateControlPointFromGridAtIndex:CP_1];
    [self updateControlPointFromGridAtIndex:CP_2];
    
    
    self.demoAnimationStartX = 17.0f;
    self.demoAnimationEndX   = 250.0f;
}

-(void)dealloc {
    self.window = nil;
    self.grid = nil;
    self.demoImage = nil;
    self.curveTypes = nil;
    self.timingFunction = nil;
    self.curveTypeDropDown = nil;
    self.cp1X = nil;
    self.cp2X = nil;
    self.cp1Y = nil;
    self.cp2Y = nil;
    self.constructor = nil;
    [super dealloc];
}

-(IBAction)doAnimationDemo:(id)sender {
    CALayer* demoLayer = self.demoImage.layer;
        
    double duration = 1.0;
    CGFloat y = demoLayer.position.y;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion = NO;
    animation.duration = duration;


    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = duration;

    if (_curveTypeIndex <= 5) {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, self.demoAnimationStartX, y);
            CGPathAddLineToPoint(path, NULL, self.demoAnimationEndX, y);
            animation.path = path;
            CGPathRelease(path);

            group.timingFunction = self.timingFunction;
    }else
    {
        AHEasingFunction fun;
        if (_curveTypeIndex == 6) {
            fun = LinearInterpolation;
        }else if (_curveTypeIndex == 7) {
            switch (_curveTypeIndex1) {
                case 0:
                    fun = QuadraticEaseIn;
                    break;
                case 1:
                    fun = CubicEaseIn;
                    break;
                case 2:
                    fun = QuarticEaseIn;
                    break;
                case 3:
                    fun = QuinticEaseIn;
                    break;
                case 4:
                    fun = SineEaseIn;
                    break;
                case 5:
                    fun = CircularEaseIn;
                    break;
                case 6:
                    fun = ExponentialEaseIn;
                    break;
                case 7:
                    fun = ElasticEaseIn;
                    break;
                case 8:
                    fun = BackEaseIn;
                    break;
                case 9:
                    fun = BounceEaseIn;
                    break;

                default:
                    fun = BounceEaseIn;
                    break;
            }
        }else if (_curveTypeIndex == 8) {
            switch (_curveTypeIndex1) {
                case 0:
                    fun = QuadraticEaseOut;
                    break;
                case 1:
                    fun = CubicEaseOut;
                    break;
                case 2:
                    fun = QuarticEaseOut;
                    break;
                case 3:
                    fun = QuinticEaseOut;
                    break;
                case 4:
                    fun = SineEaseOut;
                    break;
                case 5:
                    fun = CircularEaseOut;
                    break;
                case 6:
                    fun = ExponentialEaseOut;
                    break;
                case 7:
                    fun = ElasticEaseOut;
                    break;
                case 8:
                    fun = BackEaseOut;
                    break;
                case 9:
                    fun = BounceEaseOut;
                    break;

                default:
                    fun = BounceEaseOut;
                    break;
            }
        }else {
            switch (_curveTypeIndex1) {
                case 0:
                    fun = QuadraticEaseInOut;
                    break;
                case 1:
                    fun = CubicEaseInOut;
                    break;
                case 2:
                    fun = QuarticEaseInOut;
                    break;
                case 3:
                    fun = QuinticEaseInOut;
                    break;
                case 4:
                    fun = SineEaseInOut;
                    break;
                case 5:
                    fun = CircularEaseInOut;
                    break;
                case 6:
                    fun = ExponentialEaseInOut;
                    break;
                case 7:
                    fun = ElasticEaseInOut;
                    break;
                case 8:
                    fun = BackEaseInOut;
                    break;
                case 9:
                    fun = BounceEaseInOut;
                    break;

                default:
                    fun = BounceEaseInOut;
                    break;
            }
        }
        animation.values = [YXEasing calculateFrameFromPoint:CGPointMake(self.demoAnimationStartX, y) toPoint:CGPointMake(self.demoAnimationEndX, y)
                                                        func:fun frameCount:duration * 60.f];
    }


    group.animations = [NSArray arrayWithObjects:animation, nil];
    
    [demoLayer addAnimation:group forKey:@"doAnimationDemo"];
    
    demoLayer.position = CGPointMake(self.demoAnimationEndX, y);
}


-(void)windowDidResize:(NSNotification*)notification {
    [self updateTimingFunction:nil];
}

-(IBAction)updateTimingFunction:(id)sender {
    NSInteger curveTypeIndex = [self.curveTypeDropDown indexOfSelectedItem];
    _curveTypeIndex = curveTypeIndex;
    if (_curveTypeIndex > 6) {
        _curveTypeIndex1 = [self.curveTypeDropDown1 indexOfSelectedItem];
        _curveTypeDropDown1.hidden = NO;
        [self doAnimationDemo:nil];
        return ;
    }
    if (curveTypeIndex <= 4) {
        TimingFunction* tf = (TimingFunction*)[self.curveTypes objectAtIndex:curveTypeIndex];

        self.timingFunction = [CAMediaTimingFunction functionWithName:tf.function];
        
        // Update the grid with the appropriate control point coordinates
        float coords[2];
        [self.timingFunction getControlPointAtIndex:1 values:coords];
        self.grid.cp1 = NSMakePoint(coords[0], coords[1]);
        
        [self.timingFunction getControlPointAtIndex:2 values:coords];
        self.grid.cp2 = NSMakePoint(coords[0], coords[1]);
        
        // update the constructor field
        [self.constructor setStringValue:[NSString stringWithFormat:@"[CAMediaTimingFunction functionWithName:%@]", tf.constantName]];

        _curveTypeDropDown1.hidden = YES;
        [self doAnimationDemo:nil];
    } else if (curveTypeIndex == 5) {
        self.timingFunction = [CAMediaTimingFunction functionWithControlPoints:self.grid.cp1.x
                                                                         :self.grid.cp1.y
                                                                         :self.grid.cp2.x
                                                                         :self.grid.cp2.y];
        // update the constructor field
        [self.constructor setStringValue:[NSString stringWithFormat:@"[CAMediaTimingFunction functionWithControlPoints:%.2f :%.2f :%.2f :%.2f]", self.grid.cp1.x, self.grid.cp1.y, self.grid.cp2.x, self.grid.cp2.y]];
        _curveTypeDropDown1.hidden = YES;
        [self doAnimationDemo:nil];
    }else if (curveTypeIndex == 6)
    {
        // update the constructor field
        [self.constructor setStringValue:[NSString stringWithFormat:@"LinearInterpolation"]];
        _curveTypeDropDown1.hidden = YES;
        [self doAnimationDemo:nil];
    }else
    {
        _curveTypeDropDown1.hidden = NO;
    }
}

-(IBAction)updateControlPoints:(id)sender {
    [self.curveTypeDropDown selectItemAtIndex:5]; // set drop-down to "custom"
    self.grid.cp1 = NSMakePoint([self.cp1X floatValue], [self.cp1Y floatValue]);
    self.grid.cp2 = NSMakePoint([self.cp2X floatValue], [self.cp2Y floatValue]);
    [self updateTimingFunction:nil];
}

-(void)controlPointWasDraggedAtIndex:(unsigned int)index {
    [self.curveTypeDropDown selectItemAtIndex:5]; // set drop-down to "custom"
    [self updateControlPointFromGridAtIndex:index];
    [self updateTimingFunction:nil];
}
    
-(void)updateControlPointFromGridAtIndex:(unsigned int)index {
    if (index == CP_1) {
        [self.cp1X setFloatValue:self.grid.cp1.x];
        [self.cp1Y setFloatValue:self.grid.cp1.y];
    } else {
        [self.cp2X setFloatValue:self.grid.cp2.x];
        [self.cp2Y setFloatValue:self.grid.cp2.y];
    }
}

@end
