//
//  UIView+BorderLine.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "UIView+BorderLine.h"
#import <objc/runtime.h>

static CGFloat const kDefaultBorderLineWidth = 1.f;

static char const kKeyBorderEdgeKey = '\0';
static char const kKeyBorderLineLayerKey = '\0';

@interface UIView()

@property (nonatomic, strong) CAShapeLayer *ty_borderLineLayer;

@end

@implementation UIView (BorderLine)

+ (void)load
{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(layoutSubviews)), class_getInstanceMethod(self, @selector(ty_bl_layoutSubviews)));
}

- (void)ty_bl_layoutSubviews
{
    [self ty_bl_layoutSubviews];
    if (self.ty_borderLineLayer) {
        self.ty_borderLineLayer.frame = self.bounds;
        [self ty_p_resetBorderPath:self.ty_borderEdge];
    }
}

#pragma mark - Setter / Getter

#pragma mark borderLineLayer

- (void)setTy_borderLineLayer:(CAShapeLayer *)ty_borderLineLayer
{
    objc_setAssociatedObject(self, &kKeyBorderLineLayerKey, ty_borderLineLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)ty_borderLineLayer
{
    return objc_getAssociatedObject(self, &kKeyBorderLineLayerKey);
}

#pragma mark borderLineColor

- (void)setTy_borderColor:(CGColorRef)ty_borderColor
{
    [self ty_p_borderLayerInstance].strokeColor = ty_borderColor;
}

- (CGColorRef)ty_borderColor
{
    return self.ty_borderLineLayer.strokeColor;
}

#pragma mark ty_borderEdge

- (void)setTy_borderEdge:(UIRectEdge)ty_borderEdge
{
    if (self.ty_borderEdge == ty_borderEdge) {
        return;
    }
    NSNumber *number = [NSNumber numberWithUnsignedInteger:ty_borderEdge];
    objc_setAssociatedObject(self, &kKeyBorderEdgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self ty_p_resetBorderPath:ty_borderEdge];
}

- (UIRectEdge)ty_borderEdge
{
    NSNumber *number = objc_getAssociatedObject(self, &kKeyBorderEdgeKey);
    if (!number) {
        return UIRectEdgeNone;
    } else {
        return [number unsignedIntegerValue];
    }
}

#pragma mark ty_borderWidth

- (void)setTy_borderWidth:(CGFloat)ty_borderWidth
{
    [self ty_p_borderLayerInstance].lineWidth = ty_borderWidth;
}

- (CGFloat)ty_borderWidth
{
    return self.ty_borderLineLayer.lineWidth;
}

#pragma mark - Private Helper

- (CAShapeLayer *)ty_p_borderLayerInstance
{
    CAShapeLayer *layer = self.ty_borderLineLayer;
    if (layer == nil) {
        layer = [[CAShapeLayer alloc] init];
        layer.lineWidth = kDefaultBorderLineWidth;
        self.ty_borderLineLayer = layer;
        [self.layer addSublayer:layer];
    }
    return layer;
}

- (void)ty_p_resetBorderPath:(UIRectEdge)edge
{
    CGMutablePathRef path = CGPathCreateMutable();
    // Top
    if (edge & UIRectEdgeTop) {
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, self.bounds.size.width, 0);
    }
    // Right
    if (edge & UIRectEdgeRight) {
        CGPathMoveToPoint(path, NULL, self.bounds.size.width, 0);
        CGPathAddLineToPoint(path, NULL, self.bounds.size.width, self.bounds.size.height);
    }
    // Bottom
    if (edge & UIRectEdgeBottom) {
        CGPathMoveToPoint(path, NULL, self.bounds.size.width, self.bounds.size.height);
        CGPathAddLineToPoint(path, NULL, 0, self.bounds.size.height);
    }
    // Left
    if (edge & UIRectEdgeLeft) {
        CGPathMoveToPoint(path, NULL, 0, self.bounds.size.height);
        CGPathAddLineToPoint(path, NULL, 0, 0);
    }
    
    [self ty_p_borderLayerInstance].path = path;
    CFRelease(path);
}


@end
