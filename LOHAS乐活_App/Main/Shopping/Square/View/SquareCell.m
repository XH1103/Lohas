//
//  SquareCell.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/18/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "SquareCell.h"
#import "SquareCellLayout.h"
#import "WXPhotoBrowser.h"
@interface SquareCell()<PhotoBrowerDelegate>{

    UIImageView *_atImage;
    UILabel *_atLabel;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet WXLabel *nameLabel;
@property (weak, nonatomic) IBOutlet WXLabel *timeLabel;

@property (strong, nonatomic)WXLabel *sqTextLabel;
@property (strong, nonatomic)NSArray *imageArray;
@property (strong, nonatomic)UIView *articleView;
@end
@implementation SquareCell


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}
-(void)setSqModel:(SquareModel *)sqModel {
    
        _sqModel = sqModel;
        [_iconImg sd_setImageWithURL:_sqModel.avatar];
        _nameLabel.text = _sqModel.username;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_sqModel.dateline];
        //时间格式化
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        //设置格式化的格式
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        //对时间对象进行格式化输出
        //格式化过程中  会根据设备的时区  自动的计算时差
        NSString *s = [formatter stringFromDate:date];
        _timeLabel.text = s;
    
//        ---------布局对象创建-----------------
        SquareCellLayout *layout = [SquareCellLayout layoutWithSquareModel:_sqModel];
    
    self.sqTextLabel.text = _sqModel.content.content;
    self.sqTextLabel.frame = layout.squareTextFrame;
    
    if (_sqModel.content.file_image_thumb.count>0) {
        for (int i = 0; i < 9; i++) {
            //取出ImageView
            UIImageView *iv = self.imageArray[i];
            //设置frame
            NSValue *value = layout.imageFrameArray[i];
            CGRect frame = [value CGRectValue];
            iv.frame = frame;
            if (i < _sqModel.content.file_image_thumb.count) {
                //设置内容
                NSURL *url = [NSURL URLWithString:_sqModel.content.file_image_thumb[i]];
                [iv sd_setImageWithURL:url];
            }
        }
    } else if(_sqModel.content.file_image_thumb.count == 0) {
        for (UIImageView *iv in _imageArray) {
            iv.frame = CGRectZero;
        }
    }

    if (_sqModel.article.count>0){
        self.articleView.frame = CGRectMake(10, layout.squareTextFrame.origin.y + layout.squareTextFrame.size.height, kScreenWidth - 20, 70);
        _atImage.frame = CGRectMake(0, 0, 70, 70);
        _atLabel.frame = CGRectMake(100, (70-30)/2, kScreenWidth- 20- 100, 30);
        NSURL *url = [NSURL URLWithString:_sqModel.article[@"app_cover"]];
        [_atImage sd_setImageWithURL:url];
        _atLabel.text =_sqModel.article[@"title"];
    }else if(_sqModel.article.count == 0){
        self.articleView.frame = CGRectZero;
        _atLabel.frame = CGRectZero;
        _atImage.frame = CGRectZero;
    }
    
}

#pragma mark - 懒加载方式
-(NSArray *)imageArray {
    if (_imageArray == nil) {
        NSMutableArray *mArray = [[NSMutableArray alloc]init];
        for (int i = 0;  i < 9; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:imageView];
            [mArray addObject:imageView];
            //给图片添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [imageView addGestureRecognizer:tap];
            
            //开启图片的点击事件
            imageView.userInteractionEnabled = YES;
            
            imageView.tag = i;
            
        }
        _imageArray = [mArray copy];
    }
    
    return _imageArray;
}
-(UIView *)articleView {
    if (_articleView == nil) {
        _articleView = [[UIView alloc] initWithFrame:CGRectZero];
        _articleView.backgroundColor = [UIColor grayColor];
        _articleView.alpha = 0.8;
        [self.contentView addSubview:_articleView];
        
        _atImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_articleView addSubview:_atImage];
        
        _atLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _atLabel.numberOfLines = 0;
        _atLabel.font = [UIFont systemFontOfSize:15];
        _atLabel.textColor =[UIColor blackColor];
        [_articleView addSubview:_atLabel];
        
    }
    
    return _articleView;
}
- (WXLabel *)sqTextLabel {
    if (_sqTextLabel == nil) {
        _sqTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
        _sqTextLabel.font = kSquareTextFont;
        _sqTextLabel.numberOfLines = 0;
        //设置行间距
        _sqTextLabel.linespace = LineSpace;
        
        [self.contentView addSubview: _sqTextLabel];
    }
    
    return _sqTextLabel;
}
#pragma mark - 图片点击
- (void)tapImageViewAction:(UITapGestureRecognizer *)tap {
    //获取被点击的视图
    UIImageView *imageView = (UIImageView *)tap.view;
    //    NSLog(@"tag = %li",imageView.tag);
    
    //显示图片浏览器
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:imageView.tag delegate:self];
    
}
#pragma  mark - PhotoBrowerDelegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:
(WXPhotoBrowser *)photoBrowser{
   return _sqModel.content.file_image_thumb.count;
   
}
//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    //创建Photo对象
    WXPhoto *photo = [[WXPhoto alloc] init];
//    NSDictionary *dic = _sqModel.content.file_image_thumb[index];
    NSString *imageUrlStr = _sqModel.content.file_image_thumb[index];
    if (imageUrlStr == nil) {
        return nil;
    }
    //    NSLog(@"%@",imageUrlStr);//这是缩略图地址
    //将缩略图地址转化为原图（字符串替换）
    imageUrlStr = [imageUrlStr stringByReplacingOccurrencesOfString:@".jpg-200-200.jpg" withString:@".jpg"];
    
    photo.url = [NSURL URLWithString:imageUrlStr];
    //原来、ImageView 获取ImageView的Frame 来实现动画效果 以及ImageView中的缩略图
    
    photo.srcImageView  = _imageArray[index];
    
    return photo;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
