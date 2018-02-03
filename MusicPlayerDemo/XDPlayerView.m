//
//  XDPlayerView.m
//  MusicPlayerDemo
//
//  Created by Heaton on 2018/1/23.
//  Copyright © 2018年 WangMingDeveloper. All rights reserved.
//

#import "XDPlayerView.h"
#import "XDMusicModel.h"
@interface XDPlayerView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton *buttonPlayer;// 播放按钮
@property(nonatomic,strong) UIButton *buttonNext;  // 下一首
@property(nonatomic,strong) UIButton *buttonLast;  // 上一首
@property(nonatomic,strong) UIButton *buttonModel; // 播放模式
@property(nonatomic,strong) UIButton *buttonSort;  // 分类
@property(nonatomic,strong) UIView   *viewButtons; 

@property(nonatomic,strong) UIView *viewSliderVolume;
@property(nonatomic,strong) UIView *viewSliderProgress;
@end

@implementation XDPlayerView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.viewButtons = [[UIView alloc] init];
        [self addSubview:self.viewButtons];
    
        self.buttonPlayer = [self creatButtonWithNorImageName:@"player_play" selectedName:@"player_pause" event:@selector(playerButtonTapped:)];
        [self.viewButtons addSubview:self.buttonPlayer];
        
        self.buttonNext = [self creatButtonWithNorImageName:@"player_next" selectedName:@"player_next" event:@selector(nextButtonTapped:)];
        [self.viewButtons addSubview:self.buttonNext];
        
        self.buttonLast = [self creatButtonWithNorImageName:@"player_last" selectedName:@"player_last" event:@selector(lastButtonTapped:)];
        [self.viewButtons addSubview:self.buttonLast];
        
        self.buttonModel = [self creatButtonWithNorImageName:@"player_random" selectedName:@"player_random" event:@selector(modelButtonTapped:)];
        [self.viewButtons addSubview:self.buttonModel];
        
        
        self.buttonSort = [self creatButtonWithNorImageName:@"音乐" selectedName:@"音乐" event:@selector(sortButtonTapped:)];
        [self.viewButtons addSubview:self.buttonSort];
        
        [self addSubview:self.tableViewMusicList];
        
        self.viewSliderProgress = [[UIView alloc] init];
        [self addSubview:self.viewSliderProgress];
        
        self.viewSliderVolume = [[UIView alloc] init];
        [self addSubview:self.viewSliderVolume];
        
        self.sliderVolume = [self creatSliderWithBackgroundImageName:@"volumeBackgruond" trackImageName:@"volumeTrack" events:@selector(volumeChange:)];
        self.sliderVolume.value = 0.8;
        [self.viewSliderVolume addSubview:self.sliderVolume];
        
        self.sliderProgress  = [self creatSliderWithBackgroundImageName:@"volumeBackgruond" trackImageName:@"volumeTrack" events:@selector(progressChange:)];
        [self.viewSliderProgress addSubview:self.sliderProgress];
        
        self.labelMusicName = [self creatLabel:@"歌曲名" textColor:[UIColor greenColor] font:[UIFont fontWithName:@"xxx" size:14]];
        [self addSubview:self.labelMusicName];
        
        self.labelAritst = [self creatLabel:@"歌手名" textColor:[UIColor greenColor] font:[UIFont fontWithName:@"xxx" size:12]];
        [self addSubview:self.labelAritst];
        
        
        self.labelTotalTime = [self creatLabel:@"00:00" textColor:[UIColor greenColor] font:[UIFont fontWithName:@"xxx" size:12]];
        [self.viewSliderProgress addSubview:self.labelTotalTime];
        
        self.labelPlayingTime = [self creatLabel:@"00:00" textColor:[UIColor greenColor] font:[UIFont fontWithName:@"xxx" size:12]];
        [self.viewSliderProgress addSubview:self.labelPlayingTime];
        
    }
    return self;
}

-(void)layoutSubviews{
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    
    CGFloat tableView_W = self.frame.size.width - 40;
    CGFloat tableView_H = viewHeight * 0.7;
    
    self.labelMusicName.frame = CGRectMake(0,20,viewWidth, 30);
    self.labelAritst.frame = CGRectMake(0,CGRectGetMaxY(self.labelMusicName.frame)+5,viewWidth,20);
    
    
    self.viewSliderVolume.frame = CGRectMake(20,CGRectGetMaxY(self.labelAritst.frame)+5, tableView_W,30);
    self.sliderVolume.frame = CGRectMake(0,0,tableView_W,30);
    
    self.tableViewMusicList.frame = CGRectMake(20,CGRectGetMaxY(self.viewSliderVolume.frame)+5, viewWidth- 40,tableView_H);
    
    CGFloat  viewButtons_W = viewWidth;
    CGFloat  viewButtons_H = 60;
    
    self.viewButtons.frame = CGRectMake(0,viewHeight - viewButtons_H,viewButtons_W,viewButtons_H);
    NSArray *array = @[self.buttonModel,self.buttonLast,self.buttonPlayer,self.buttonNext,self.buttonSort];
    CGFloat buttonW = 50;
    CGFloat buttonH = 50;
    CGFloat buttonY = (viewButtons_H - buttonH)/2;
    CGFloat margin = (viewWidth - 250)/6;
    for (int i = 0;i < array.count;i++) {
        UIButton *button = array[i];
        button.frame = CGRectMake(margin + (margin * i) + buttonW * i,buttonY,buttonW, buttonH);
    }
    
    self.labelPlayingTime.frame = CGRectMake(0,0,60,30);
    self.labelTotalTime.frame = CGRectMake(tableView_W - 60,0,60,30);
    self.viewSliderProgress.frame = CGRectMake(self.viewSliderVolume.frame.origin.x,CGRectGetMinY(self.viewButtons.frame)- 30,tableView_W,30);
    self.sliderProgress.frame = CGRectMake(60,0,tableView_W-120,30);
}
    

-(void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    if(_isPlaying){
        self.buttonPlayer.selected = YES;
    }else{
        self.buttonPlayer.selected = NO;
    }
}

-(void)playerButtonTapped:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(self.blockPlayerButton){
        self.blockPlayerButton(sender);
    }
}

-(void)nextButtonTapped:(UIButton *)sender{
    if(self.blockNextButton){
        self.blockNextButton(sender);
    }
}

-(void)lastButtonTapped:(UIButton *)sender{
    if(self.blockLastButton){
        self.blockLastButton(sender);
    }
}


-(void)modelButtonTapped:(UIButton *)sender{
    self.playType = (self.playType + 1) % 3;
    if(self.blockModelButton){
        self.blockModelButton(sender,self.playType);
    }
}


-(void)sortButtonTapped:(UIButton *)sender{
    if(self.blockSortButton){
        self.blockSortButton(sender);
    }
}


-(void)volumeChange:(UISlider *)sender{
    if(self.blockVolumeChange){
        self.blockVolumeChange(sender);
    }
}

-(void)progressChange:(UISlider *)sender{
    if(self.blockProgressChange){
        self.blockProgressChange(sender);
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    XDMusicModel *musicModel = self.dataSource[indexPath.row];
    cell.textLabel.text = musicModel.musicName;
    cell.detailTextLabel.text = musicModel.artist;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.blockDidSelected){
        self.blockDidSelected(indexPath.row);
    }
}


-(UITableView *)tableViewMusicList{
    if(_tableViewMusicList == nil){
        _tableViewMusicList = [[UITableView alloc] initWithFrame:CGRectMake(0,0,0,0) style:UITableViewStylePlain];
        _tableViewMusicList.rowHeight = 50;
        _tableViewMusicList.delegate = self;
        _tableViewMusicList.dataSource = self;
        _tableViewMusicList.showsVerticalScrollIndicator = NO;
        _tableViewMusicList.showsHorizontalScrollIndicator = NO;
        _tableViewMusicList.backgroundColor = [UIColor clearColor];
    }
    return _tableViewMusicList;
}

-(NSMutableArray<XDMusicModel *> *)dataSource{
    if(_dataSource == nil){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UIButton *)creatButtonWithNorImageName:(NSString *)nor selectedName:(NSString *)sel event:(SEL)action{
    UIButton *button = [[UIButton alloc] init];
    [button  setBackgroundImage:[UIImage imageNamed:nor] forState:UIControlStateNormal];// 暂停
    [button  setBackgroundImage:[UIImage imageNamed:sel] forState:UIControlStateSelected];// 播放
    [button  addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(UILabel *)creatLabel:(NSString *)title textColor:(UIColor *)textColor font:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.font = font;
    label.numberOfLines = 0;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(UISlider *)creatSliderWithBackgroundImageName:(NSString *)backgroundImageName trackImageName:(NSString *)trackImageName events:(SEL)action{
    UISlider *slider = [[UISlider alloc] init];
    UIImage *sliderLeftTrackImage = [[UIImage imageNamed:backgroundImageName] stretchableImageWithLeftCapWidth:0 topCapHeight: 0];
    UIImage *sliderRightTrackImage = [[UIImage imageNamed:trackImageName] stretchableImageWithLeftCapWidth:0 topCapHeight: 0];
    [slider setThumbTintColor:[UIColor clearColor]];
    [slider setMinimumTrackImage:sliderLeftTrackImage forState:UIControlStateNormal];
    [slider setMaximumTrackImage:sliderRightTrackImage forState:UIControlStateNormal];
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.value = 0.0;
    return slider;
}


-(void)setPlayType:(XDPlayType)playType{
    _playType = playType;
    NSString *imageName = @"player_loop";
    switch (playType) {
        case XDPlayTypeRepeatAll:
            imageName = @"player_loop";
            break;
        case XDPlayTypeSingCycle:
            imageName = @"player_single_cycle";
            break;
        case XDPlayTypeRandom:
            imageName = @"player_random";
            break;
        default:
            break;
    }
    [self.buttonModel setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(CGFloat)getVolume{
    return self.sliderVolume.value;
}
@end
