//
//  KGChannelTableViewCell.m
//  Mattermost
//
//  Created by Tatiana on 09/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChannelTableViewCell.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"

@interface KGChannelTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
@implementation KGChannelTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    return self;
}

- (void)awakeFromNib {
    //[super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self setupDeleteButton];
    [self setupChannelNameLabel];
    [self setupBachground];
    [self setupTypeImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.selectedView.backgroundColor = [UIColor kg_lightBlueColor];
        self.channelNameLabel.textColor = [UIColor kg_whiteColor];
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.8];
    } else {
        self.selectedView.backgroundColor = [UIColor kg_blueColor];
        self.channelNameLabel.textColor = [UIColor kg_lightBlueColor];
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1.f];
    }
}


#pragma mark - Setup

- (void)setupDeleteButton {
    [self.deleteButton setImage:[UIImage imageNamed:@"map_close_icon"] forState:UIControlStateNormal];
    [self.deleteButton.imageView setTintColor:[UIColor kg_lightBlueColor]];
}

- (void)setupBachground {
    self.backgroundColor = [UIColor kg_blueColor];
}

- (void)setupChannelNameLabel {
    self.channelNameLabel.font = [UIFont kg_regular16Font];
    self.channelNameLabel.textColor = [UIColor kg_lightBlueColor];
}

- (void)setupTypeImageView {
   // self.typeImageView.image = [UIImage imageNamed:@"map_close_icon"];
}
#pragma mark - Configurate

- (void)configureWitChannelName:(NSString *)channelName {
    self.channelNameLabel.text = channelName;
}

- (void)configurateWithChannel:(KGChannel *)channel {
    self.channelNameLabel.text = channel.displayName;
    if (channel.type == KGChannelTypePrivate){
        NSLog(@"%@", channel.backendType);
        self.deleteButton.hidden = NO;
    } else {
        self.deleteButton.hidden = YES;
    }
}
+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}
+ (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}
@end
