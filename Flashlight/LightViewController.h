//
//  LightViewController.h
//  Flashlight
//
//  Created by 邑动 on 15/5/7.
//  Copyright (c) 2015年 邑动. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightViewController : UIViewController
{
    int shineFreq;
    NSTimer *timerShine;
    bool enableShine;
    bool isShineOn;
}
@property  bool isLightOn;
@property (nonatomic,retain)UIButton *btnOnOff;
@property (nonatomic,retain)UIButton *btnSetting;
@property (nonatomic,retain)UIButton *btnShine;
@property (nonatomic,retain)UILabel *labelFreq;
@property (nonatomic,retain)UILabel *labelhelp;
@property (nonatomic,retain)UISlider *sliderFreq;
@property (nonatomic,retain)UISwitch  *switchShine;
@property (nonatomic,copy)UIButton *advertasiBtn;

- (void) turnOnLed:(bool)update;
- (void) turnOffLed:(bool)update;
- (void)onBtnOnOff:(id)sender;
- (void)onBtnOnOffDown:(id)sender;
- (void)onBtnSetting:(id)sender;
- (void)onBtnSettingDown:(id)sender;
- (void)onBtnShine:(id)sender;
- (void) SliderProgressChanged:(id)sender;
- (void) SliderProgressUp:(id)sender;
-(void)onSwitch:(id)sender;
@end
