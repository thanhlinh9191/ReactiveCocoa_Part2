//
//  RWSearchFormViewController.m
//  TwitterInstant
//
//  Created by THANHLINH on 9/06/15.
//  Copyright (c) 2015 THANHLINH. All rights reserved.
//

#import "RWSearchFormViewController.h"
#import "RWSearchResultsViewController.h"
#import <ReactiveCocoa.h>
#import "RACEXTScope.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

typedef NS_ENUM(NSInteger, RWTwitterInstantError) {
    RWTwitterInstantErrorAccessDenied,
    RWTwitterInstantErrorNoTwitterAccounts,
    RWTwitterInstantErrorInvalidResponse
};

static NSString * const RWTwitterInstantDomain = @"TwitterInstant";

@interface RWSearchFormViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (strong, nonatomic) RWSearchResultsViewController *resultsViewController;

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *twitterAccountType;

@end

@implementation RWSearchFormViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Twitter Instant";
  
  [self styleTextField:self.searchText];
  
  self.resultsViewController = self.splitViewController.viewControllers[1];
    
  //get twitter account
    self.accountStore = [[ACAccountStore alloc] init];
    self.twitterAccountType = [self.accountStore
                               accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
   @weakify(self)
    [[self.searchText.rac_textSignal
    map:^id(NSString *text) {
      return [self isValidSearchText:text]?[UIColor whiteColor]:[UIColor yellowColor];
  }]
   subscribeNext:^(UIColor* color) {
    @strongify(self)
      self.searchText.backgroundColor = color;
  }];
 
    //After a completed or error event, a subscription removes itself automatically
    //we can remove subscription mannually by below code
    /*RACSignal *backgroundColorSignal =
    [self.searchText.rac_textSignal
     map:^id(NSString *text) {
         return [self isValidSearchText:text] ?
         [UIColor whiteColor] : [UIColor yellowColor];
     }];
    
    RACDisposable *subscription =
    [backgroundColorSignal
     subscribeNext:^(UIColor *color) {
         self.searchText.backgroundColor = color;
     }];

    [subscription dispose];*/
    
    //get access to twitter account
    [[self requestAccessToTwitterSignal]
     subscribeNext:^(id x) {
         NSLog(@"Access granted");
     } error:^(NSError *error) {
         NSLog(@"An error occurred: %@", error);
     }];
  
}

- (BOOL)isValidSearchText:(NSString *)text {
    return text.length > 2;
}

- (void)styleTextField:(UITextField *)textField {
  CALayer *textFieldLayer = textField.layer;
  textFieldLayer.borderColor = [UIColor grayColor].CGColor;
  textFieldLayer.borderWidth = 2.0f;
  textFieldLayer.cornerRadius = 0.0f;
}

#pragma makr - create new signals for services
- (RACSignal *)requestAccessToTwitterSignal {
    
    // 1 - define an error
    NSError *accessError = [NSError errorWithDomain:RWTwitterInstantDomain
                                               code:RWTwitterInstantErrorAccessDenied
                                           userInfo:nil];
    
    // 2 - create the signal
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 3 - request access to twitter
        @strongify(self)
        [self.accountStore
         requestAccessToAccountsWithType:self.twitterAccountType
         options:nil
         completion:^(BOOL granted, NSError *error) {
             // 4 - handle the response
             if (!granted) {
                 [subscriber sendError:accessError];
             } else {
                 [subscriber sendNext:nil];
                 [subscriber sendCompleted];
             }
         }];
        return nil;
    }];
}

@end
