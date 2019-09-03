//
//  ViewController.m
//  性能优化
//
//  Created by 赵鹏 on 2019/8/28.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 在屏幕成像的过程中，CPU和GPU起着至关重要的作用：
 1、CPU（Central Processing Unit，中央处理器）：对象的创建和销毁、对象属性的调整、布局计算、文本的计算和排版、图片的格式转换和解码、图像的绘制（Core Graphics）；
 2、GPU（Graphics Processing Unit，图形处理器）：纹理的渲染。
 CPU把将要在屏幕上显示的图片、文字等内容的尺寸、位置、颜色等算好后交给GPU进行渲染。在渲染之前，系统会把CPU计算好后的数据放在“帧缓存”中，然后交给“视频控制器”进行读取，然后显示到“屏幕”上面；
 在iOS中是双缓存机制，有前帧缓存、后帧缓存，即两个“帧缓存”，当其中的一个帧缓存忙碌的时候可以用另外一个帧缓存来工作。
 
 屏幕卡顿的原因：
 CPU把将要显示的元件的尺寸计算好之后交给GPU进行渲染，接下来这个时候就来了一个VSync（垂直同步信号），将刚才CPU计算好、GPU渲染好的元件显示到屏幕上，从而就完成了这一帧的显示了。接下来就要进行显示下一帧的操作了，有可能CPU计算完了以后，GPU需要比较长的一段时间进行渲染，在GPU还没有处理完渲染过程的时候，这个时候VSync就过来了，当下只能显示上一帧GPU渲染好的数据了，当前正在渲染的这一帧就丢失了，俗称“丢帧”、“掉帧”，所以这样就形成卡顿了。
 
 卡顿解决的主要思路：
 尽可能地减少CPU、GPU的资源消耗。
 
 按照60FPS的刷帧率，每隔16ms就会有一次VSync信号，即每隔16ms刷帧一次。
 
 卡顿优化 - CPU：
 1、尽量用轻量级的对象，比如用不到事件处理的地方，可以考虑使用CALayer取代UIView；
 2、不要频繁地调用UIView的相关属性，比如frame、bounds、transform等属性，尽量减少不必要的修改；
 3、尽量提前计算好布局，在有需要时一次性调整对应的属性，不要多次修改属性；
 4、Autolayout会比直接设置frame消耗更多的CPU资源；
 5、图片的size最好刚好跟UIImageView的size保持一致；
 6、控制一下线程的最大并发数量；
 7、尽量把耗时的操作放到子线程中去处理，比如：文本处理（尺寸计算、绘制）、图片处理（解码、绘制）。
 
 卡顿优化 - GPU：
 1、尽量避免短时间内大量图片的显示，尽可能将多张图片合成一张进行显示；
 2、GPU能处理的最大纹理尺寸是4096x4096，一旦超过这个尺寸，就会占用CPU资源进行处理，所以纹理尽量不要超过这个尺寸；
 3、尽量减少视图数量和层次；
 4、尽量不要设置像"image.alpha = 0.5"这样的语句；
 5、尽量避免出现离屏渲染。
 
 离屏渲染：
 在OpenGL中，GPU有2种渲染方式：
 1、On-Screen Rendering：当前屏幕渲染，在当前用于显示的屏幕缓冲区进行渲染操作；
 2、Off-Screen Rendering：离屏渲染，在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作。
 
 离屏渲染消耗性能的原因：
 1、需要创建新的缓冲区；
 2、离屏渲染的整个过程，需要多次切换上下文环境，先是从当前屏幕（On-Screen）切换到离屏（Off-Screen），然后等到离屏渲染结束后，将离屏缓冲区的渲染结果显示到屏幕上，又需要将上下文环境从离屏切换到当前屏幕。
 
 下面的这些操作会触发离屏渲染，应尽量避免：
 1、设置光栅化：layer.shouldRasterize = YES；
 2、这只遮罩：layer.mask；
 3、设置圆角：同时设置"layer.masksToBounds = YES"和"layer.cornerRadius大于0"两句代码，如果只单独设置其中的一句代码的话则不会触发离屏渲染。为了避免离屏渲染，应该考虑通过CoreGraphics绘制裁剪圆角，或者让美工提供带圆角的图片；
 4、设置阴影：layer.shadowXXX。如果设置了layer.shadowPath就不会产生离屏渲染。
 */
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
