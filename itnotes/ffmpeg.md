## ffmpeg 命令
> ffmpeg -i a.webm -b:v 2000k -bufsize 2000k -maxrate 2500k output.mp4

> ffmpeg -i a.webm output.mp4

``` shell
ffmpeg -i input.mp4 -vf "drawtext=fontfile=simhei.ttf: text='watermarker':x=10:y=10:fontsize=24:fontcolor=white:shadowy=2" output.mp4
# fontfile:字体类型
# text:要添加的文字内容
# fontsize:字体大小
# fontcolor：字体颜色

ffmpeg -i input.mp4 -i logo.png -filter_complex 'overlay=x=10:y=main_h-overlay_h-10' output.mp4
# -filter_complex: 相比-vf, filter_complex适合开发复杂的滤镜功能，如同时对视频进行裁剪并旋转。参数之间使用逗号（，）隔开即可
# main_w:视频宽度
# overlay_w: 要添加的图片水印宽度
# main_h : 视频高度
# overlay_h:要添加的图片水印宽度
```