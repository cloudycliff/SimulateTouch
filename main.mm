/*
 * Name: libSimulateTouch
 * Author: iolate <iolate@me.com>
 *
 */

#import <CoreGraphics/CoreGraphics.h>
#import "SimulateTouch.h"

#define PRINT_USAGE printf("[Usage]\n 1. Touch:\n    %s touch x y [orientation]\n\n 2. Swipe:\n   %s swipe fromX fromY toX toY [duration(0.3)] [orientation]\n\n[Example]\n   # %s touch 50 100\n   # %s swipe 50 100 100 200 0.5\n\n[Orientation]\n    Portrait:1 UpsideDown:2 Right:3 Left:4\n", argv[0], argv[0], argv[0], argv[0]);

int main(int argc, char **argv, char **envp) {
    if (argc == 1) {
        PRINT_USAGE;
        return 0;
    }
    
    if (!strcmp(argv[1], "touch")) {
        if (argc != 4 && argc != 5) {
            PRINT_USAGE;
            return 0;
        }
        
        if (argc == 4) {
            int x = atoi(argv[2]);
            int y = atoi(argv[3]);
            
            int r = [SimulateTouch simulateTouch:0 atPoint:CGPointMake(x, y) withType:STTouchDown];
            [SimulateTouch simulateTouch:r atPoint:CGPointMake(x, y) withType:STTouchUp];
        }else if (argc == 5) {
            int px = atoi(argv[2]);
            int py = atoi(argv[3]);
            CGPoint p = CGPointMake(px, py);
            
            CGPoint rp = [SimulateTouch STWindowToScreenPoint:p withOrientation:atoi(argv[4])];
            int r = [SimulateTouch simulateTouch:0 atPoint:rp withType:STTouchDown];
            [SimulateTouch simulateTouch:r atPoint:rp withType:STTouchUp];
        }
        
    }else if (!strcmp(argv[1], "swipe")) {
        if (argc < 6 || argc > 8) {
            PRINT_USAGE;
            return 0;
        }
        
        float duration = 0.3f;
        if (argc == 6) {
            CGPoint fromPoint = CGPointMake(atoi(argv[2]), atoi(argv[3]));
            CGPoint toPoint = CGPointMake(atoi(argv[4]), atoi(argv[5]));
            
            [SimulateTouch simulateSwipeFromPoint:fromPoint toPoint:toPoint duration:duration];
        }else if (argc == 7) {
            CGPoint fromPoint = CGPointMake(atoi(argv[2]), atoi(argv[3]));
            CGPoint toPoint = CGPointMake(atoi(argv[4]), atoi(argv[5]));
            duration = atof(argv[6]);
            [SimulateTouch simulateSwipeFromPoint:fromPoint toPoint:toPoint duration:duration];
        }else if (argc == 8) {
            CGPoint pfromPoint = CGPointMake(atoi(argv[2]), atoi(argv[3]));
            CGPoint ptoPoint = CGPointMake(atoi(argv[4]), atoi(argv[5]));
            
            CGPoint fromPoint = [SimulateTouch STWindowToScreenPoint:pfromPoint withOrientation:atoi(argv[7])];
            CGPoint toPoint = [SimulateTouch STWindowToScreenPoint:ptoPoint withOrientation:atoi(argv[7])];
            
            duration = atof(argv[6]);
            [SimulateTouch simulateSwipeFromPoint:fromPoint toPoint:toPoint duration:duration];
        }
        
        CFRunLoopRunInMode(kCFRunLoopDefaultMode , duration+0.1f, NO);
    }else if (!strcmp(argv[1], "multi")) {
        if (argc < 8 || argc > 9) {
            PRINT_USAGE;
            return 0;
        }

        //duration should be long enough to give every step enough time, or the corners will not be sharp enough
        float duration = 3.0f;
        CGPoint fromPoint = CGPointMake(atoi(argv[2]), atoi(argv[3]));
        CGPoint middlePoint = CGPointMake(atoi(argv[4]), atoi(argv[5]));
        CGPoint toPoint = CGPointMake(atoi(argv[6]), atoi(argv[7]));
        //add more test points
        CGPoint p = CGPointMake(250, 200);
        CGPoint p1 = CGPointMake(20, 320);
        CGPoint p2 = CGPointMake(190, 260);
        CGPoint p3 = CGPointMake(50, 190);

        NSArray *array = [[NSArray alloc] initWithObjects:
            [NSValue valueWithCGPoint:fromPoint], 
            [NSValue valueWithCGPoint:middlePoint], 
            [NSValue valueWithCGPoint:toPoint],
            [NSValue valueWithCGPoint:p],
            [NSValue valueWithCGPoint:p1],
            [NSValue valueWithCGPoint:p2],
            [NSValue valueWithCGPoint:p3], nil];
        if (argc == 9) {
            duration = atof(argv[8]);
        }
        [SimulateTouch simulateMoveFromArray:array duration:duration];
        
        CFRunLoopRunInMode(kCFRunLoopDefaultMode , duration+0.1f, NO);
    }else{
        PRINT_USAGE;
        return 0;
    }
    
    return 0;
}