[[MainPage\_zh\_CN 中文](.md) ]

# Introduction #

The project is a ASP.Net System Information Prober. It's a single page which trying to get as much as possible of useful hosting information. The concept is similar to PHP page which contains `phpinfo()`.

# Information Probed #

## System Information ##
  * Server Name
  * Server IP
  * Server Domain
  * Server Port
  * Web Server Version
  * Virtual Request Path
  * Physical Request Path
  * Virtual Application Root Path
  * Physical Application Root Path
  * Operating System
  * Operating System Installation Directory
  * .Net Version
  * .Net Language
  * Server Current Time
  * System Uptime
  * Script Timeout

## Processor Information ##
  * Number of Processor
  * Processor Id
  * Processor Type
  * Processor Level
  * Processor OEM Id
  * Page Size

## Memory Information ##
  * Current Working Set
  * Physical Memory Size
  * Physical Free Memory Size
  * Physical Used Memory Size
  * Page File Size
  * Available Page File Size
  * Virtual Memory Size
  * Available Memory Size

## Storage Information ##
  * Logical Driver Information
  * Drive name
  * Volume label
  * Drive format
  * Drive type
  * free and total space.

## Request Headers ##

## Server Variables ##

## Environment Variables ##

## Session Information ##

## System COM Components ##
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

## Mail COM Components ##
  * `JMail.SMTPMail`
  * `JMail.Message`
  * `CDONTS.NewMail`
  * `CDO.Message`
  * `Persits.MailSender`
  * `SMTPsvg.Mailer`
  * `DkQmail.Qmail`
  * `SmtpMail.SmtpMail`
  * `Geocel.Mailer`

## Upload COM Components ##
  * `LyfUpload.UploadFile`
  * `Persits.Upload`
  * `Ironsoft.UpLoad`
  * `aspcn.Upload`
  * `SoftArtisans.FileUp`
  * `SoftArtisans.FileManager`
  * `Dundas.Upload`
  * `w3.upload`

## Graphics COM Components ##
  * `SoftArtisans.ImageGen`
  * `W3Image.Image`
  * `Persits.Jpeg`
  * `XY.Graphics`
  * `Ironsoft.DrawPic`
  * `Ironsoft.FlashCapture`

## Other COM Components ##
  * `dyy.zipsvr`
  * `hin2.com_iis`
  * `Socket.TCP`

# Usage #

Download current version zip file from [the download page](http://code.google.com/p/aspnetsysinfo/downloads/list). Decompress and put `info.aspx` on any web server directory with the permission and ability to run `*.aspx`. And visit the page use browser.

E.g. put the files under web root of `www.example.com`, then visit the result by the link: `http://www.example.com/info.aspx`.

# Requirement #

It will support both IIS server on Windows Server and Apache with [Mono](Mono.md) on Linux/Unix.

Supported Platform:

  * Microsoft .Net Framework 1.0/1.1
  * Microsoft .Net Framework 2.0
  * Mono .Net Framework 1.0
  * Mono .Net Framework 2.0