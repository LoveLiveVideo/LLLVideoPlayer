//
//  SVPlayerSlider.m
//  iPhoneVideo
//
//  Created by yu xiaoxiao on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SVPlayerSlider.h"
//#import "PlayerPointValue.h"

@interface SVPlayerSlider ()
@property (nonatomic,   copy) SliderPointClickBlock clickPointBlock;
@property (nonatomic, retain) NSMutableArray *pointBtnArray;
@property (nonatomic, retain) NSMutableArray *pointDataArray;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UIImageView *tailImageView;
@property (nonatomic, retain) UIImageView *downloadedImageView;
@property (nonatomic, retain) UIImageView *processImageView;
@property (nonatomic, assign) CGFloat downloadValue;
@property (nonatomic, assign) CGFloat processValue;
@property (nonatomic, retain) NSMutableDictionary *thumbImageDict;
@end

@implementation SVPlayerSlider

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"userInteractionEnabled" context:NULL];
    self.clickPointBlock = nil;
    self.pointDataArray=nil;
    self.pointBtnArray=nil;
    self.headImageView=nil;
    self.tailImageView=nil;
    self.processImageView = nil;
    self.downloadedImageView = nil;
    self.thumbImageDict = nil;
}

/**
 *  解决问题：在有看点的显示时候，拖动thumbImage没有响应，会触发到看点button
 *  http://jira.sohu-inc.com/browse/IPHONE-7317
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTestView = [super hitTest:point withEvent:event];
    //此方法当前系统版本有效，后续系统不一定管用
    UIView *thumbImageView = [self.subviews lastObject];
    BOOL isInside = CGRectContainsPoint(thumbImageView.frame, point);
    //如果是看点按钮响应，同时point点在slider的thumbImageView内，则将button屏蔽，返回SVPlayerSlider
    if ([self.pointBtnArray containsObject:hitTestView] && isInside) {
        return self;
    }
    return hitTestView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _downloadValue = 0.0f;
        self.clickPointBlock = nil;
        self.thumbImageDict = [NSMutableDictionary dictionary];
        [self addObserver:self forKeyPath:@"userInteractionEnabled" options:NSKeyValueObservingOptionNew context:NULL];
        [self addTarget:self action:@selector(valueChangeHandle:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self) {
        if ([keyPath isEqualToString:@"userInteractionEnabled"]) {
            if (!self.userInteractionEnabled) {
//                [self setThumbImage:nil forState:UIControlStateNormal];
                [self setThumbImage:[self.thumbImageDict objectForKey:@(UIControlStateDisabled)] forState:UIControlStateNormal];
            } else {
//                [self setThumbImage:nil forState:UIControlStateNormal];
                [self setThumbImage:[self.thumbImageDict objectForKey:@(UIControlStateNormal)] forState:UIControlStateNormal];
            }
            [self layoutSubviews];
        } else {
            [self removeObserver:self forKeyPath:keyPath context:NULL];
        }
    } else {
        [self removeObserver:object forKeyPath:keyPath context:NULL];
    }
}

- (void)valueChangeHandle:(UISlider *)sender {
    if (sender.value > 0 && !isnan(self.maximumValue) && self.maximumValue > 0) {
        CGFloat tempProcessValue = (sender.value / self.maximumValue);
        self.processValue = tempProcessValue;
    }
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state
{
    if (![self.thumbImageDict objectForKey:@(state)]) {
        [self.thumbImageDict setObject:image forKey:@(state)];
    }
    [super setThumbImage:image forState:state];
}

// 解决 enable == NO 时, thumbImage在iOS7+上模糊问题
- (void)setEnabled:(BOOL)enabled
{
    [self setUserInteractionEnabled:enabled];
}

- (void)clickPointEvent:(SliderPointClickBlock)block
{
    self.clickPointBlock = block;
}

- (void)setDownloadedImage:(UIImage *)image
{
    if (_downloadedImageView == nil) {
        _downloadedImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    if (image) {
        [_downloadedImageView setImage:image];
    }
}

- (void)setProcessImage:(UIImage *)image {
    if (_processImageView == nil) {
        _processImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    if (image) {
        [_processImageView setImage:image];
    }
}

- (void)setDownloadedValue:(CGFloat)value{
    if (_downloadValue != value) {
        _downloadValue = value;
        [self setNeedsLayout];
    }    
}

- (void)setProcessValue:(CGFloat)value {
    if (_processValue != value) {
        _processValue = value;
        [self setNeedsLayout];
    }
}

//-(void)addPointsJson:(NSArray*)pointJson{
//    if([pointJson count]<=0){
//        return;
//    }
//    if(self.maximumValue<=0.01f){
//        return;
//    }
//    if(_pointBtnArray==nil){
//        _pointBtnArray=[[NSMutableArray alloc] init];
//    }
//    if(_pointDataArray==nil){
//        _pointDataArray=[[NSMutableArray alloc] init];
//    }
////    [self removeAllPoints];
//    for(NSInteger i=0;i<[pointJson count];i++){
//        PlayerPointValue *obj=[[PlayerPointValue alloc] initWithDictionary:[pointJson objectAtIndex:i]];
//        [_pointDataArray addObject:obj];
//        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame=CGRectMake(0, 0, 20, 20);
//        [btn setImage:[UIImage imageNamed:@"PlayerFullScreen-Btn-Point"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"PlayerFullScreen-Btn-Point"] forState:UIControlStateDisabled];
//        CGPoint centerPos = CGPointMake((self.bounds.size.width-self.currentThumbImage.size.width)*(obj.pointSecond/self.maximumValue), self.bounds.size.height/2);
//        centerPos.x += self.currentThumbImage.size.width/2.0f;
//        btn.center = centerPos;
//        btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//        btn.backgroundColor=[UIColor clearColor];
//        [btn addTarget:self action:@selector(clickPointBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [btn addTarget:self action:@selector(pointBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
//        [btn addTarget:self action:@selector(pointBtnTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
//        [self insertSubview:btn aboveSubview:_processImageView];
//        [_pointBtnArray addObject:btn];
//        [obj release];
//    }
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.subviews.count > 1 && _downloadValue >= 0 && !isnan(_downloadValue)) {
        CGRect frame = [self trackRectForBounds:self.bounds];
        frame.size.width *= _downloadValue;
        if (frame.size.width < _downloadedImageView.image.size.width) {
            frame = CGRectZero;
        }
        _downloadedImageView.frame = frame;

        [self insertSubview:_downloadedImageView atIndex:1];
    } else {
        _downloadedImageView.frame = CGRectZero;
    }
    
    if (self.subviews.count > 3 && _processValue > 0 && !isnan(_processValue)) {
        CGRect frame = [self trackRectForBounds:self.bounds];
        frame.size.width = (_processValue * (frame.size.width - 24));
        frame.origin.x = 12;
        _processImageView.frame = frame;
        
        [self insertSubview:_processImageView atIndex:3];
    } else {
        _processImageView.frame = CGRectZero;
    }
}

-(void)clickPointBtn:(id)sender{
    UIButton *btn=(UIButton*)sender;
    NSInteger index=-1;
    for(NSInteger i=0;i<[_pointBtnArray count];i++){
        if([_pointBtnArray objectAtIndex:i]==btn){
            index=i;
            break;
        }
    }
    if(index>=0&&index<[_pointDataArray count]){
        PlayerPointValue *value=[_pointDataArray objectAtIndex:index];
        CGPoint point=CGPointMake(self.frame.origin.x+btn.center.x, self.frame.origin.y);
        if (self.clickPointBlock) {
            self.clickPointBlock(value,point,UIControlEventTouchUpInside);
        }
    }
    [self pointBtnTouchUp:sender];
}

-(void)pointBtnTouchDown:(id)sender{
    if (self.clickPointBlock) {
        self.clickPointBlock(nil,CGPointZero,UIControlEventTouchDown);
    }
}
-(void)pointBtnTouchUp:(id)sender{
    if (self.clickPointBlock) {
        self.clickPointBlock(nil,CGPointZero,UIControlEventTouchUpOutside);
    }
}

-(void)removeAllPoints{
    [_pointDataArray removeAllObjects];
    for(NSInteger i=0;i<[_pointBtnArray count];i++){
        UIButton *btn=[_pointBtnArray objectAtIndex:i];
        [btn removeFromSuperview];
    }
    [_pointBtnArray removeAllObjects];
}

-(void)addHeadTail:(NSInteger)headTime Tail:(NSInteger)tailTime{
    [self removeHeadTailIcon];
    if(self.maximumValue<=0.01f){
        return;
    }
    if(headTime>0&&headTime<self.maximumValue){
        _headImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2, 5)];
        _headImageView.image=[UIImage imageNamed:@"PlayerFullScreen-Bg-HeadTail"];
        _headImageView.center=CGPointMake((self.bounds.size.width-self.currentThumbImage.size.width)*(headTime/self.maximumValue)+self.currentThumbImage.size.width/2.0f, self.bounds.size.height/2);
        [self addSubview:_headImageView];
    }
    if(tailTime>0&&tailTime<self.maximumValue){
        _tailImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2, 5)];
        _tailImageView.image=[UIImage imageNamed:@"PlayerFullScreen-Bg-HeadTail"];
        _tailImageView.center=CGPointMake((self.bounds.size.width-self.currentThumbImage.size.width)*(tailTime/self.maximumValue)+self.currentThumbImage.size.width/2.0f, self.bounds.size.height/2);
        [self addSubview:_tailImageView];
    }
}

-(void)headTailIconShow:(BOOL)show
{
    _headImageView.hidden = !show;
    _tailImageView.hidden = !show;
}

-(void)removeHeadTailIcon{
    if(_headImageView!=nil){
        [_headImageView removeFromSuperview];
    }
    if(_tailImageView!=nil){
        [_tailImageView removeFromSuperview];
    }

}

-(CGRect)trackRectForBounds:(CGRect)bounds
{
    CGRect rect = [super trackRectForBounds:bounds];
    rect.size.height = 1.0;
    return rect;
}

@end
