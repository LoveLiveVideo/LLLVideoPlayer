//
//  UIImageExtend.h
//  Utility
//
//  Created by test on 10-11-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Accelerate/Accelerate.h>

#import <UIKit/UIKit.h>


#pragma mark -

@interface UIImage (ImageWithName)
- (id) initWithName:(NSString *)name;
+ (UIImage *) imageWithName:(NSString *)name;
@end

@interface UIImage(ImageGenerator)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)blurImageWithSize:(CGSize)size
                     tintColor:(UIColor *)tintColor
                  cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)roundedRectangleImage:(CGSize)imageSize
                             color:(UIColor *)color
                       borderWidth:(CGFloat)borderWidth
                      cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)imageWithView:(UIView*)aView;

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end


#pragma mark -
@interface UIImage(ExtendedForRotaion) 
- (UIImage *)rotateImage;
- (UIImage *)leftRotatedImage;
- (UIImage *)rightRotatedImage;
@end

#pragma mark -
@interface UIImage(ExtendedForSizing)
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
- (UIImage *)croppedImage:(CGRect)bounds;

- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage*)imageWithSize:(CGSize)targetSize;
+ (UIImage*)stretchImage:(NSString*)aImageName withCapInsets:(UIEdgeInsets)aCapInsets;
+ (UIImage*)imageNamed:(NSString *)name retina:(BOOL)retina;

@end


#pragma mark -
@interface UIImage(ExtendedForTransparency)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
@end


#pragma mark -
@interface UIImage(ExtendedForReflection)
- (UIImage *)addImageReflection:(CGFloat)reflectionFraction;
@end

#pragma mark -
@interface UIImage (Blur)

//将图片模糊化
- (UIImage*)applyBlurOnImageWithRadius:(CGFloat)blurRadius;

@end

