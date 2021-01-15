//
//  PDFImageAnnotation.m
//  UmerChat
//
//  Created by umer on 2020/12/4.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import "PDFImageAnnotation.h"

@implementation PDFImageAnnotation {
    UIImage * _picture;
    CGRect _bounds;
};

-(instancetype)initWithPicture:(nonnull UIImage *)picture bounds:(CGRect) bounds{
    
    self = [super initWithBounds:bounds
                  forType:PDFAnnotationSubtypeWidget
                  withProperties:nil];

    if(self){
        _picture = picture;
        _bounds = bounds;
    }
    return  self;
}

- (void)drawWithBox:(PDFDisplayBox) box
          inContext:(CGContextRef)context {
    [super drawWithBox:box inContext:context];
    
    UIGraphicsPushContext(context);
    CGContextSaveGState(context);

    CGContextTranslateCTM(context, _bounds.origin.x, _bounds.origin.y + _bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [_picture drawInRect:CGRectMake(0, 0, _bounds.size.width, _bounds.size.height)];

    CGContextRestoreGState(context);
    UIGraphicsPopContext();
    
}

@end
