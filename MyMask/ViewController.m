//
//  ViewController.m
//  MyMask
//
//  Created by liqunfei on 15/9/7.
//  Copyright (c) 2015年 chuchengpeng. All rights reserved.
//

#import "ViewController.h"
#import "CircleBTN.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong,nonatomic)CircleBTN *circleView;
@property (strong,nonatomic)UIView *movingView;
@property (strong,nonatomic)ABPeoplePickerNavigationController *peoplePicker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CircleBTN *btn = [[CircleBTN alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.cornerRadius = 50.0f;
    btn.bottomLeftRadius = YES;
    btn.topLeftRadius = YES;
    btn.bottomRightRadius = YES;
    btn.topRightRadius = YES;
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    btn.userInteractionEnabled = YES;
    _circleView = btn;
    self.myImageView.layer.mask = btn.layer;
    UIView *view2 = [[UIView alloc] initWithFrame:self.view.bounds];
   //[self.view addSubview:view2];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
   [self.view addSubview:view1];
    _movingView = view1;
   // view1.backgroundColor = [UIColor redColor];
    view2.backgroundColor = [UIColor greenColor];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];

    
    [view1 addGestureRecognizer:tap1];
    [view1 addGestureRecognizer:pan1];
    [view2 addGestureRecognizer:tap2];
    [view2 addGestureRecognizer:pan2];
    // Do any additional setup after loading the view, typically from a nib.
}

//获取通讯录信息
- (IBAction)getPhonenumber:(UIButton *)sender {
    [self selectPeople];
}

- (void)selectPeople {
    int __block tip = 0;
    ABAddressBookRef addbook = nil;
    addbook = ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addbook, ^(bool granted, CFErrorRef error) {
        if (!granted) {
            tip = 1;
        }
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    if (tip) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"tips" message:@"此应用程序没有权限访问您的联系人。" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
    else {
        _peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        _peoplePicker.peoplePickerDelegate = (id<ABPeoplePickerNavigationControllerDelegate>)self;
        NSArray *displayItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
        _peoplePicker.displayedProperties = displayItems;
        _peoplePicker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    
    [self presentViewController:_peoplePicker animated:YES completion:nil];
}

#pragma mark--ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0) {
    ABMultiValueRef valueRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    firstName = firstName?firstName:@"";
}

// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0) {
    
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = recognizer.state;
    if (!CGRectEqualToRect(_circleView.frame, _movingView.frame)) {
        [UIView animateWithDuration:0.5 animations:^{
            _circleView.frame = _movingView.frame;
        } completion:^(BOOL finished) {
            if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
                CGPoint current = [recognizer locationInView:self.view];
                CGFloat x = current.x;
                CGFloat y = current.y;
                if (x < CGRectGetWidth(_movingView.bounds)/2) {
                    x = CGRectGetWidth(_movingView.bounds)/2;
                }
                else if (x > CGRectGetWidth(self.view.bounds) - CGRectGetWidth(_movingView.bounds)/2) {
                    x = CGRectGetWidth(self.view.bounds) - CGRectGetWidth(_movingView.bounds)/2;
                }
                if (y < _movingView.frame.size.height /2){
                    y = _movingView.frame.size.height /2;
                }else if (y > self.view.frame.size.height - _movingView.frame.size.height / 2){
                    y =  self.view.frame.size.height - _movingView.frame.size.height / 2;
                }
                _movingView.center = CGPointMake(x, y);
                _circleView.frame = _movingView.frame;
            }
        }];
    }
    else {
        if (state == UIGestureRecognizerStateChanged || state == UIGestureRecognizerStateBegan) {
            CGPoint current = [recognizer locationInView:self.view];
            CGFloat X = current.x;
            CGFloat Y = current.y;
            if (X < _movingView.frame.size.width / 2){
                X = _movingView.frame.size.width/2;
            }else if (X > self.view.frame.size.width - _movingView.frame.size.width / 2){
                X =  self.view.frame.size.width - _movingView.frame.size.width / 2;
            }
            
            if (Y < _movingView.frame.size.height /2){
                Y = _movingView.frame.size.height /2;
            }else if (Y > self.view.frame.size.height - _movingView.frame.size.height / 2){
                Y =  self.view.frame.size.height - _movingView.frame.size.height / 2;
            }
            _movingView.center = CGPointMake(X, Y);
            _circleView.frame = _movingView.frame;
            
        }
        
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if (CGRectEqualToRect(_movingView.frame, _circleView.frame)) {
        [UIView animateWithDuration:0.5 animations:^{
            _circleView.frame = CGRectMake(_circleView.frame.origin.x - self.view.frame.size.height, _circleView.frame.origin.y - self.view.frame.size.height, _circleView.frame.size.width + self.view.frame.size.height * 2, _circleView.frame.size.height + self.view.frame.size.height * 2);
        }];
    }
    else {
        CGPoint point = [tap locationInView:self.view];
        _movingView.frame =CGRectMake(point.x - 50, point.y - 50, 100, 100);
        [UIView animateWithDuration:0.5 animations:^{
            _circleView.frame = _movingView.frame;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
