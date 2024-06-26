# ffmpeg 命令

## 转码

``` shell
ffmpeg -i a.webm -b:v 2000k -bufsize 2000k -maxrate 2500k output.mp4

ffmpeg -i a.webm output.mp4
```

## 添加水印

``` shell
ffmpeg -i input.mp4 -vf "drawtext=fontfile=ziti.ttf: text='watermarker':x=10:y=10:fontsize=24:fontcolor=white:shadowy=2" output.mp4
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

## 添加封面

``` shell
ffmpeg -i input.mp4 -i cover.jpg -map 0 -map 1 -c copy -disposition:v:1 attached_pic output.mp4
```

## 拼接视频

``` shell
ffmpeg -f concat -i video.txt -c copy output.mp4
```
* video.txt 格式如下

``` shell
file '1.mp4'
file '2.mp4'
file '3.mp4'
file '4.mp4'
```

## 压缩视频

### 视觉无损压缩
``` shell
ffmpeg -i input.mp4 -c:v libx265 -x265-params crf=18:preset=placebo output.mp4
ffmpeg -i input.mov -c:v libx264 -preset veryslow -crf 18 -c:acopy output.mp4 # -crf 18-28是一个合理的范围。18被认为是视觉无损的（从技术角度上看当然还是有损的），它的输出视频质量和输入视频相当。
ffmpeg -i input.mp4 -b:v 500k -r 25 output.mp4 # -r 帧率 -b 码率，建议不小于500k；-itsoffset -00:00:00.900 视频偏移，解决音画不同步
ffmpeg -itsoffset -00:00:00.900 -i input.mp4 -b:v 500k -r 25 output.mp4 # -itsoffset -00:00:00.900 视频偏移，解决音画不同步，该参数位置在命令后：Move this option before the file it belongs to.
```

