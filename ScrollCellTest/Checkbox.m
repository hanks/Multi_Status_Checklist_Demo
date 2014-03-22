#import "Checkbox.h"

@implementation Checkbox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set white background color
        [self setBackgroundColor:[UIColor whiteColor]];
        NSLog(@"%f", self.bounds.size.width);
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat size = MIN(self.bounds.size.width, self.bounds.size.height);
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // Account for non-square frames.
    if (self.bounds.size.width < self.bounds.size.height) {
        // Vertical Center
        transform = CGAffineTransformMakeTranslation(0, (self.bounds.size.height - size)/2);
    } else if (self.bounds.size.width > self.bounds.size.height) {
        // Horizontal Center
        transform = CGAffineTransformMakeTranslation((self.bounds.size.width - size)/2, 0);
    }
    
    const CGFloat strokeWidth = 0.068359375f * size;
    const CGFloat checkBoxInset = 0.171875f * size;
    CGRect checkboxRect = CGRectMake(checkBoxInset, checkBoxInset, size - checkBoxInset*2, size - checkBoxInset*2);
    
    // Draw the checkbox
    {
        UIBezierPath *checkboxPath = [UIBezierPath bezierPathWithRect:checkboxRect];
        
        [checkboxPath applyTransform:transform];
        
        if (!self.tintColor)
            self.tintColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        [self.tintColor setStroke];
        
        checkboxPath.lineWidth = strokeWidth;
        
        [checkboxPath stroke];
    }
    
    
#define P(POINT) (POINT * size)
    // Draw the checkmark if self.checked==YES
    if (self.checked)
    {
        // The checkmark is drawn as a bezier path using Quartz2D.
        // The control points for this path are stored (hardcoded) as normalized
        // values so that the path can be accurately reconstructed at any size.
        
        // A small macro to scale the normalized control points for the
        // checkmark bezier path to the size of the control.

        
        CGContextSetGrayFillColor(context, 0.0f, 1.0f);
        CGContextConcatCTM(context, transform);
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context,
                             P(0.304f), P(0.425f));
        CGContextAddLineToPoint(context, P(0.396f), P(0.361f));
        CGContextAddCurveToPoint(context,
                                 P(0.396f), P(0.361f),
                                 P(0.453f), P(0.392f),
                                 P(0.5f), P(0.511f));
        CGContextAddCurveToPoint(context,
                                 P(0.703f), P(0.181f),
                                 P(0.988f), P(0.015f),
                                 P(0.988f), P(0.015f));
        CGContextAddLineToPoint(context, P(0.998f), P(0.044f));
        CGContextAddCurveToPoint(context,
                                 P(0.998f), P(0.044f),
                                 P(0.769f), P(0.212f),
                                 P(0.558f), P(0.605f));
        CGContextAddLineToPoint(context, P(0.458f), P(0.681f));
        CGContextAddCurveToPoint(context,
                                 P(0.365f), P(0.451f),
                                 P(0.304f), P(0.425f),
                                 P(0.302f), P(0.425f));
        CGContextClosePath(context);
        
        CGContextFillPath(context);
        
    }
    
    // Draw the checkmark if self.cancelled ==YES
    if (self.cancelled) {
        NSLog(@"mark xxxxx");
        
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextConcatCTM(context, transform);
        
        // draw x mark in the checkbox
        CGContextMoveToPoint(context,
                             9.0f, 9.0f);
        CGContextAddLineToPoint(context, 21.0f, 21.0f);
        CGContextMoveToPoint(context,
                             9.0f, 21.0f);
        CGContextAddLineToPoint(context, 21.0f, 9.0f);
        CGContextStrokePath(context);
    }
    
#undef P
    
}

#pragma mark - Control
- (void)setChecked:(BOOL)checked
{
    if (checked != _checked) {
        _checked = checked;
        
        // Flag ourself as needing to be redrawn.
        [self setNeedsDisplay];
        [self.delegate changeCellStatusWithChecked:checked];
    }
}

- (void)setCancelled:(BOOL)cancelled
{
    if (cancelled != _cancelled) {
        _cancelled = cancelled;
        
        // Flag ourself as needing to be redrawn.
        [self setNeedsDisplay];
        [self.delegate changeCellStatusWithCancelled:cancelled];
    }
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent*)event
{
    NSSet *allTargets = [self allTargets];
    
    for (id target in allTargets) {
        
        NSArray *actionsForTarget = [self actionsForTarget:target forControlEvent:controlEvents];
        
        // Actions are returned as NSString objects, where each string is the
        // selector for the action.
        for (NSString *action in actionsForTarget) {
            SEL selector = NSSelectorFromString(action);
            [self sendAction:selector to:target forEvent:event];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[touches anyObject] tapCount] == 1) {
        // Toggle our state.
        self.checked = !self.checked;
        
        // Notify our target (if we have one) of the change.
        [self sendActionsForControlEvents:UIControlEventValueChanged withEvent:event];
    }
}


@end
