//
//  YPGiveLikeButton.h
//  YPGiveLikeAnimation
//
//  Created by 王艳苹 on 2019/8/24.
//  Copyright © 2019 esk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YPGiveLikeButton;
@protocol YPGiveLikeButtonDelegate <NSObject>

- (void)clickInGiveLikeButton:(YPGiveLikeButton *)giveLikeButton;

@end

@interface YPGiveLikeButton : UIView
    
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *selectedImage;
@property (nonatomic,assign) BOOL selected;
    
@property (nonatomic,weak) id<YPGiveLikeButtonDelegate>delegate;
    
- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image selectedImage:(NSString *)selectedImage;
/**点赞动画*/
- (void)startAnimation;
/**取消点赞动画*/
- (void)cancelAnimation;

@end

NS_ASSUME_NONNULL_END
