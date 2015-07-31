//
//  CardView.m
//  SuperCard
//
//  Created by 布白 on 15/7/26.
//  Copyright (c) 2015年 DPC. All rights reserved.
//

#import "CardView.h"

@interface CardView()

@property (nonatomic) CGFloat cardFaceScaleFactor;

@end

@implementation CardView

#pragma mark - Proporties

- (void)setRank:(NSUInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit {
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#define CARD_FACE_SCALE_FACTOR 0.9

@synthesize cardFaceScaleFactor = _cardFaceScaleFactor;

- (CGFloat)cardFaceScaleFactor {
    if (!_cardFaceScaleFactor) {
        _cardFaceScaleFactor = CARD_FACE_SCALE_FACTOR;
    }
    
    return _cardFaceScaleFactor;
}

- (void)setCardFaceScaleFactor:(CGFloat)cardFaceScaleFactor {
    _cardFaceScaleFactor = cardFaceScaleFactor;
    [self setNeedsDisplay];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        self.cardFaceScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 160.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor {
    return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius {
    return CORNER_RADIUS * [self cornerScaleFactor];
}

- (CGFloat)cornerOffset {
    return [self cornerRadius] / 2.0;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundRect addClip];
    
    if (self.faceUp) {
        [[UIColor blackColor] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    //UIRectFill(self.bounds);
    [roundRect fill];
    
    [[UIColor whiteColor] setStroke];
    [roundRect setLineWidth:2.0];
    [roundRect stroke];
    
    // Draw card face
    if (self.faceUp) {
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]];
        if (faceImage) {
            CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * (1 - [self cardFaceScaleFactor]), self.bounds.size.height * (1 - self.cardFaceScaleFactor));
            [faceImage drawInRect:imageRect];
        } else {
            [self drawPips];
        }
        
        [self drawCorner];
    } else {
        [[UIImage imageNamed:@"CardBack"] drawInRect:self.bounds]; 
    }
}

- (void)drawPips {
    
}

- (NSString *)rankAsString {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

- (void)drawCorner {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc]
                                      initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit]
                                      attributes:@{NSFontAttributeName : cornerFont, NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paraStyle}];
    
    CGRect textBound;
    textBound.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBound.size = [cornerText size];
    [cornerText drawInRect:textBound];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    [cornerText drawInRect:textBound];
}

#pragma mark - Initialization

- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode =  UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [self setup];
}

@end
