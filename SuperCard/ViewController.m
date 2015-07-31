//
//  ViewController.m
//  SuperCard
//
//  Created by 布白 on 15/7/26.
//  Copyright (c) 2015年 DPC. All rights reserved.
//

#import "ViewController.h"
#import "CardView.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CardView *cardView;
@property (strong, nonatomic) Deck *deck;

@end

@implementation ViewController

- (Deck *)deck {
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    
    return _deck;
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    if (!self.cardView.faceUp) {
        Card *card = [self.deck drawRandomCard];
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            self.cardView.rank = playingCard.rank;
            self.cardView.suit = playingCard.suit;
        }
    }
    
    self.cardView.faceUp = !self.cardView.faceUp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.cardView.suit = @"♣︎";
    self.cardView.rank = 13;
    
    // Add gesture recognizer to view in code
    [self.cardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.cardView action:@selector(pinch:)]];
}

@end
