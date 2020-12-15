#import "ImageGallerySaverPlugin.h"
#import <Photos/Photos.h>

@implementation ImageGallerySaverPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                        methodChannelWithName:@"image_gallery_saver"
                                        binaryMessenger:[registrar messenger]];
       ImageGallerySaverPlugin *instance = [[ImageGallerySaverPlugin alloc] init];
       [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"saveImageToGallery" isEqualToString:call.method]) {
        NSMutableDictionary *argument = call.arguments;
        if(argument == nil){
            result(FlutterMethodNotImplemented);
            return;
        }
        FlutterStandardTypedData *imageData = (FlutterStandardTypedData*)argument[@"imageBytes"];
        NSNumber *quality = (NSNumber*)argument[@"quality"];
//        NSString *name = (NSString*)argument[@"name"];
        CGFloat compression = [quality intValue] / 100;
        UIImage *shareImage = [UIImage imageWithData:imageData.data scale:compression];
        [self createdAssets:shareImage result:result];
    } else if ([@"saveFileToGallery" isEqualToString:call.method]) {
        
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark -- <获取相片>
- (void)createdAssets:(nonnull UIImage *)image result:(FlutterResult)result{
    // 同步执行修改操作
    NSError *error = nil;
    __block NSString *assertId = nil;
    // 保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        assertId =  [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if (error) {
        NSLog(@"保存失败");
        result(@{@"isSuccess":@(FALSE),
                     @"filePath":@"",
                     @"errorMessage":error.domain
                     });
    }else{
             NSLog(@"保存失败");
            result(@{@"isSuccess":@(YES),
            @"filePath":@"",
            @"errorMessage":@""
            });
    }
}

@end
