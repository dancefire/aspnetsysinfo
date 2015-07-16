[[MainPage English](.md) ]

# 简介 #

这个项目实现了一个ASP.Net的系统信息探针(探测器)。它用一个aspx页面取得并显示尽量多的主机信息。这与PHP中的`phpinfo()`很相似。

# 探测的信息 #

## 系统信息 ##

  * 服务器名
  * 服务器IP
  * 服务器域名
  * 服务器端口
  * Web服务器版本
  * 请求链接的虚拟路径
  * 请求链接的物理路径
  * 应用程序根路径的虚拟路径
  * 应用程序根路径的物理路径
  * 操作系统
  * 操作系统安装的目录
  * .Net 版本
  * .Net 语言
  * 服务器当前时间
  * 服务器持续开机时间
  * 脚本超时时间

## 处理器信息 ##

  * 处理器个数
  * 处理器Id
  * 处理器类型
  * 处理器Level
  * 处理器OEM Id
  * 页面大小

## 内存信息 ##

  * .Net应用程序所影射的当前工作内存大小
  * 物理内存大小
  * 物理空闲内存大小
  * 物理使用空间大小
  * 页面文件大小
  * 可用页面文件大小
  * 虚拟内存大小
  * 可用内存大小

## 存储器信息 ##

  * 逻辑驱动器信息
  * 驱动器名
  * 卷标
  * 驱动器文件格式 (FAT32, NTFS...)
  * 驱动器类型 (固定硬盘，CDROM...)
  * 空闲和全部的空间

## Request Headers ##

## Server Variables ##

## 环境变量 ##

## Session Information ##

## 系统 COM 组件 ##

  * `Adodb.Connection`
  * `Adodb.RecordSet`
  * `Adodb.Stream`
  * `Scripting.FileSystemObject`
  * `Microsoft.XMLHTTP`
  * `WScript.Shell`
  * `MSWC.AdRotator`
  * `MSWC.BrowserType`
  * `MSWC.Counters`
  * `MSWC.NextLink`
  * `MSWC.PermissionChecker`
  * `MSWC.Status`
  * `MSWC.Tools`
  * `IISSample.ContentRotator`
  * `IISSample.PageCounter`

## 邮件 COM 组件 ##

  * `JMail.SMTPMail`
  * `JMail.Message`
  * `CDONTS.NewMail`
  * `CDO.Message`
  * `Persits.MailSender`
  * `SMTPsvg.Mailer`
  * `DkQmail.Qmail`
  * `SmtpMail.SmtpMail`
  * `Geocel.Mailer`

## 上传 COM 组件 ##

  * `LyfUpload.UploadFile`
  * `Persits.Upload`
  * `Ironsoft.UpLoad`
  * `aspcn.Upload`
  * `SoftArtisans.FileUp`
  * `SoftArtisans.FileManager`
  * `Dundas.Upload`
  * `w3.upload`

## 图像 COM 组件 ##

  * `SoftArtisans.ImageGen`
  * `W3Image.Image`
  * `Persits.Jpeg`
  * `XY.Graphics`
  * `Ironsoft.DrawPic`
  * `Ironsoft.FlashCapture`

## 其他 COM 组件 ##

  * `dyy.zipsvr`
  * `hin2.com_iis`
  * `Socket.TCP`

# 使用方法 #

请从[下载页面](http://code.google.com/p/aspnetsysinfo/downloads/list)下载当前版本的zip文件，解压缩后，将 `info.aspx` 文件置于服务器上任何可以执行 `*.aspx` 的目录下，然后通过浏览器访问该文件即可。

如，置于服务器 `www.example.com` 的Web根目录下，那么通过 `http://www.example.com/info.aspx`，就可以看到结果。

# 需求 #

该页面支持Windows的IIS服务器和Linux/Unix下的装有[Mono](Mono_zh_CN.md)的Apache服务器。

支持的平台:

  * Microsoft .Net Framework 1.0/1.1
  * Microsoft .Net Framework 2.0
  * Mono .Net Framework 1.0
  * Mono .Net Framework 2.0