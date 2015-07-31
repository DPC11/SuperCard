//
//  CardView.h
//  SuperCard
//
//  Created by 布白 on 15/7/26.
//  Copyright (c) 2015年 DPC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture; 

@end
