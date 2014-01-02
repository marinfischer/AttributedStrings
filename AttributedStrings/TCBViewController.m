//
//  TCBViewController.m
//  AttributedStrings
//
//  Created by Marin Fischer on 10/14/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import "TCBViewController.h"

@interface TCBViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIStepper *selectedWorlStepper;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TCBViewController

- (void)addLabelAttributes:(NSDictionary *)attributes range: (NSRange)range
{
    if (range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.textView.attributedText mutableCopy]; //make a mutable copy of the textView
        [mat addAttributes:attributes
                     range:range];
        self.textView.attributedText = mat;
    }

}

- (void)addSelectedWordAttributes: (NSDictionary *)attributes
{
    NSRange range = [[self.textView.attributedText string] rangeOfString:[self selectedWord]];
    [self addLabelAttributes:attributes range:range];
}

- (IBAction)underline
{
    [self addSelectedWordAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
}
- (IBAction)noUnderline
{
    [self addSelectedWordAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}];
    
}
- (IBAction)orangeButton:(UIButton *)sender
{
    [self addSelectedWordAttributes:@{NSForegroundColorAttributeName : sender.backgroundColor}]; 
}

- (IBAction)outline:(UIButton *)sender
{
    [self addSelectedWordAttributes:@{NSStrokeWidthAttributeName : @-2, NSStrokeColorAttributeName : [UIColor purpleColor]}];
}

- (IBAction)noOutline:(UIButton *)sender
{
    [self addSelectedWordAttributes:@{NSStrokeWidthAttributeName :@-0, NSStrokeColorAttributeName : [UIColor clearColor]}];
}


- (IBAction)changeFont:(UIButton *)sender
{
    CGFloat fontSize = [UIFont systemFontSize];
    NSDictionary *attributes = [self.textView.attributedText attributesAtIndex:0 effectiveRange:NULL];
    UIFont *existingFont = attributes[NSFontAttributeName];
    if (existingFont) fontSize = existingFont.pointSize;
    UIFont *font = [sender.titleLabel.font fontWithSize:fontSize];
    [self addSelectedWordAttributes:@{NSFontAttributeName : font}];
}


- (NSArray *)wordList
{
    //grabs the string out of the attributed text
    NSArray *wordList = [[self.textView.attributedText string]
                        //takes a string and divides it up based on characters that are in a certain character set (whitespaceAndNewLine is what we are using)
                        componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //never return an empty array
    if ([wordList count]) {
        return wordList;
    } else {
        return @[@" "];  //empty string
    }
}

- (NSString *)selectedWord
{
    return [self wordList] [(int) self.selectedWorlStepper.value];
}


- (IBAction)updateSelectedWord
{
    //set max word length to be how many words are in the text view. so the stepper does step off and crash the app
    self.selectedWorlStepper.maximumValue = [[self wordList] count] - 1;
    //set selected word label to be self selected word
    self.label.text = [self selectedWord];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self updateSelectedWord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
