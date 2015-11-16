//
//  LightViewController.m
//  Flashlight
//
//  Created by 邑动 on 15/5/7.
//  Copyright (c) 2015年 邑动. All rights reserved.
//

#import "LightViewController.h"
#import "SettingViewController.h"
#import <AVFoundation/AVFoundation.h>

#define MIN_FREQ   1
#define MAX_FREQ   20
#define CH_SCREEN_width [[UIScreen mainScreen] bounds].size.width
#define CH_SCREEN_height [[UIScreen mainScreen] bounds].size.height
#define CH_IMAGE(_name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:_name]]
#define CH_COLOR_normal(_R,_G,_B) [UIColor colorWithRed:_R / 255.0f green:_G / 255.0f blue:_B / 255.0f alpha:1]

@interface LightViewController ()
- (void)setUIInterface;
@end

@implementation LightViewController

@synthesize btnShine;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CH_COLOR_normal(44, 44, 44);
     [self setUIInterface];
}


- (void)setUIInterface
{
    _isLightOn = YES;
    shineFreq = MIN_FREQ;
    
    
    _btnOnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnOnOff.frame = CGRectMake(100, 104, CH_SCREEN_width - 200, CH_SCREEN_width - 200);
    [_btnOnOff addTarget:self action:@selector(onBtnOnOff:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnOnOff];
    
    _switchShine = [[UISwitch alloc]init];
    _switchShine.bounds = CGRectMake(0, 0, 60, 30);
    _switchShine.center = CGPointMake(CH_SCREEN_width / 2, 104 + CH_SCREEN_width - 200 + 30 + 15);
    _switchShine.on = NO;
    [_switchShine addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_switchShine];
    
    _sliderFreq = [[UISlider alloc]init];
    _sliderFreq.bounds = CGRectMake(0, 0, CH_SCREEN_width - 100, 20);
    _sliderFreq.center = CGPointMake(CH_SCREEN_width / 2, 104 + CH_SCREEN_width - 200 + 30 + 30 + 30 + 10);
    [_sliderFreq addTarget:self action:@selector(SliderProgressChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_sliderFreq];
    
    
    _labelFreq = [[UILabel alloc]init];
    _labelFreq.bounds = CGRectMake(0, 0, CH_SCREEN_width, 20);
    _labelFreq.center = CGPointMake(CH_SCREEN_width / 2, 104 + CH_SCREEN_width - 200 + 30 + 30 + 30 + 20 + 10 + 10);
    _labelFreq.textAlignment = NSTextAlignmentCenter;
    _labelFreq.textColor = [UIColor whiteColor];
    [self.view addSubview:_labelFreq];
    
    
    
    _btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSetting.frame = CGRectMake(CH_SCREEN_width - 60, 30, 30, 30);
    [_btnSetting setBackgroundImage:CH_IMAGE(@"help.png") forState:UIControlStateNormal];
    [_btnSetting addTarget:self action:@selector(onBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSetting];
   
    
    _labelFreq.text = [NSString stringWithFormat:@"%dhz",shineFreq];
    _sliderFreq.value = shineFreq*1.0/(MAX_FREQ-MIN_FREQ);
    _switchShine.on = enableShine;
    
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch]) {
        //没有闪光灯
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"闪光灯" message:@"抱歉，该设备没有闪光灯而无法使用手电筒功能！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        
        [alert show];
        

        
    }
    
    
    
    [self turnOnLed:YES];
}



-(void) turnOnLed:(bool)update
{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
    if (update)
    {
        [_btnOnOff setBackgroundImage:CH_IMAGE(@"close.png") forState:UIControlStateNormal];
    }
    
    
}
-(void) turnOffLed:(bool)update
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
    if (update)
    {
        [_btnOnOff setBackgroundImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
    }
    
}

-(IBAction)onBtnOnOff:(id)sender
{
    
    
    if (isShineOn) {
        [self onBtnShine:nil];
    }else{
        _isLightOn = 1-_isLightOn;
        if (_isLightOn) {
            [self turnOnLed:YES];
        }else{
            [self turnOffLed:YES];
        }
    }
    
}

-(void)onBtnSetting:(id)sender
{
    SettingViewController *settingViewController = [[SettingViewController alloc]init];
    [self presentViewController:settingViewController animated:NO completion:nil];
    
    
}


-(void)onBtnOnOffDown:(id)sender
{
    
    
}

-(void)onBtnSettingDown:(id)sender
{
    
    
}

-(void)onSwitch:(id)sender
{
    UISwitch *uiSwitch = (UISwitch *)sender;
    
    enableShine = uiSwitch.on;
    
    {
        
        if (!enableShine)
        {
            
            if (sender)
            {
                if (_isLightOn) {
                    [self turnOnLed:YES];
                }else{
                    [self turnOffLed:YES];
                }
                isShineOn = NO;
            }else{
                _isLightOn = NO;
                [self turnOffLed:YES];
                [_btnOnOff setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
            }
            
        }else{
            //闪锁
            if (sender)
            {
                isShineOn = YES;
            }
            else{
                [_btnOnOff setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
            }
            _isLightOn = YES;
            [self turnOnLed:YES];
        }
        
        if (enableShine) {
            [btnShine setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        }else{
            [btnShine setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
            
        }
        [self SliderProgressUp:nil];
        
    }
    
}


-(void)onBtnShine:(id)sender
{
    enableShine = 1-enableShine;
    if (!enableShine)
    {
        
        if (sender)
        {
            if (_isLightOn) {
                [self turnOnLed:YES];
            }else{
                [self turnOffLed:YES];
            }
            isShineOn = NO;
        }else{
            _isLightOn = NO;
            [self turnOffLed:YES];
            [_btnOnOff setImage:[UIImage imageNamed:@"BtnOff.png"] forState:UIControlStateNormal];
            _switchShine.on = enableShine;
        }
        
    }else{
        //闪锁
        if (sender)
        {
            isShineOn = YES;
        }
        else{
            [_btnOnOff setImage:[UIImage imageNamed:@"BtnOn.png"] forState:UIControlStateNormal];
            _switchShine.on = enableShine;
        }
        _isLightOn = YES;
        [self turnOnLed:YES];
    }
    
    if (enableShine) {
        [btnShine setImage:[UIImage imageNamed:@"BtnOn.png"] forState:UIControlStateNormal];
    }else{
        [btnShine setImage:[UIImage imageNamed:@"BtnOff.png"] forState:UIControlStateNormal];
        
    }
    [self SliderProgressUp:nil];
    
}


- (void) SliderProgressUp:(id)sender
{
    
    //shineFreq = 10;//hz
    double time = 1.0/shineFreq;
    
    if (!enableShine) {
        return;
    }
    
    if (timerShine) {
        // [timerShine release];
        
        [timerShine invalidate];
        timerShine = nil;
        
        
    }
    timerShine= [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(onTimerShine) userInfo:nil repeats:YES];
    
    
    
    
}


- (void) SliderProgressChanged:(id)sender
{
    UISlider *slider=(UISlider *)sender;
    //將slider的值加上0.5後轉為整數
    int percent=(int)(slider.value*100);
    shineFreq = MIN_FREQ+(MAX_FREQ-MIN_FREQ)*percent/100.0;
    _labelFreq.text = [NSString stringWithFormat:@"%dhz",shineFreq];
    
}


-(void) onTimerShine
{
    static int count=0;
    
    if (!enableShine) {
        return;
    }
    
    if (count%2) {
        [self turnOnLed:NO];
    }else{
        [self turnOffLed:NO];
    }
    count ++;
    
}

@end
