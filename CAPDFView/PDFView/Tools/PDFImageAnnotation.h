//
//  PDFImageAnnotation.h
//  UmerChat
//
//  Created by umer on 2020/12/4.
//  Copyright © 2020 UmerQs. All rights reserved.
//

#import <PDFKit/PDFKit.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(11.0))
@interface PDFImageAnnotation : PDFAnnotation

-(instancetype)initWithPicture:(nonnull UIImage *)picture bounds:(CGRect) bounds;

@end

NS_ASSUME_NONNULL_END
