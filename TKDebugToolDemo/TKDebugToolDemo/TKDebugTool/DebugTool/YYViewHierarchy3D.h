//
//  YYViewHierarchy3D.h
//  TestTe
//
//  Created by ibireme on 13-3-8.
//  2013 ibireme.
//

#import <UIKit/UIKit.h>


/// just add [YYViewHierarchy3D show]; at App startup
@interface YYViewHierarchy3D : UIWindow
+ (YYViewHierarchy3D *)sharedInstance;
- (void)toggleShow;
@end
