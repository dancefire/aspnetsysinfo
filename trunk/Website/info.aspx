<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Xml.Serialization" %>
<%@ Import Namespace="System.Runtime.InteropServices" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
    #region Assistance Class
    public class SystemInfo
    {
        [DllImport("kernel32", CharSet = CharSet.Auto, SetLastError = true)]
        internal static extern void GetSystemInfo(ref CpuInfo cpuinfo);
        [DllImport("kernel32", CharSet = CharSet.Auto, SetLastError = true)]
        internal static extern void GlobalMemoryStatus(ref MemoryInfo meminfo);

        [StructLayout(LayoutKind.Sequential)]
        public struct CpuInfo
        {
            public uint dwOemId;
            public uint dwPageSize;
            public uint lpMinimumApplicationAddress;
            public uint lpMaximumApplicationAddress;
            public uint dwActiveProcessorMask;
            public uint dwNumberOfProcessors;
            public uint dwProcessorType;
            public uint dwAllocationGranularity;
            public uint dwProcessorLevel;
            public uint dwProcessorRevision;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct MemoryInfo
        {
            public uint dwLength;
            public uint dwMemoryLoad;
            public uint dwTotalPhys;
            public uint dwAvailPhys;
            public uint dwTotalPageFile;
            public uint dwAvailPageFile;
            public uint dwTotalVirtual;
            public uint dwAvailVirtual;
        }

        public static MemoryInfo Memory
        {
            get
            {
                MemoryInfo obj = new MemoryInfo();
                GlobalMemoryStatus(ref obj);
                return obj;
            }
        }

        public static CpuInfo Cpu
        {
            get
            {
                CpuInfo obj = new CpuInfo();
                GetSystemInfo(ref obj);
                return obj;
            }
        }

    }

    public class TNameValue<TName, TValue>
    {
        private TName name;

        [XmlAttribute]
        public TName Name
        {
            get { return name; }
            set { this.name = value; }
        }
        private TValue value;

        public TValue Value
        {
            get { return value; }
            set { this.value = value; }
        }
        public TNameValue() { }
        public TNameValue(TName name, TValue value) { this.name = name; this.value = value; }
    }

    public class NameValue : TNameValue<string, string>
    {
        public NameValue() : base() { }
        public NameValue(string name, string value) : base(name, value) { }
    }
    public class Section : TNameValue<string, Information>
    {
        public Section() : base() { }
        public Section(string name, Information value) : base(name, value) { }
    }

    [XmlRoot("Information")]
    public class Information : List<NameValue>
    {
        public void Add(string name, string value) { this.Add(new NameValue(name, value)); }
    }

    [XmlRoot("SectionList")]
    public class SectionList : List<Section>
    {
        public void Add(string name, Information value) { this.Add(new Section(name, value)); }
    }
    #endregion

    #region Get Information Function

    private Information GetSystemInfo()
    {
        string text = string.Empty;
        Information dict = new Information();
        //	Server Name
        dict.Add("Server Name", Server.MachineName);
        dict.Add("Server IP", Request.ServerVariables["LOCAl_ADDR"]);
        dict.Add("Server Domain", Request.ServerVariables["Server_Name"]);
        dict.Add("Server Port", Request.ServerVariables["Server_Port"]);
        //	Web Server
        dict.Add("Web Server Version", Request.ServerVariables["Server_SoftWare"]);
        //	Path
        dict.Add("Virtual Request Path", Request.FilePath);
        dict.Add("Physical Request Path", Request.PhysicalPath);
        dict.Add("Virtual Application Root Path", Request.ApplicationPath);
        dict.Add("Physical Application Root Path", Request.PhysicalApplicationPath);
        //	Platform
        OperatingSystem os = Environment.OSVersion;
        text = string.Empty;
        switch (os.Platform)
        {
            case PlatformID.Win32Windows:
                switch (os.Version.Minor)
                {
                    case 0:
                        text = "Microsoft Windows 95";
                        break;
                    case 10:
                        text = "Microsoft Windows 98";
                        break;
                    case 90:
                        text = "Microsoft Windows Millennium Edition";
                        break;
                    default:
                        text = "Microsoft Windows 95 or later";
                        break;
                }
                break;
            case PlatformID.Win32NT:
                switch (os.Version.Major)
                {
                    case 3:
                        text = "Microsoft Windows NT 3.51";
                        break;
                    case 4:
                        text = "Microsoft Windows NT 4.0";
                        break;
                    case 5:
                        switch (os.Version.Minor)
                        {
                            case 0:
                                text = "Microsoft Windows 2000";
                                break;
                            case 1:
                                text = "Microsoft Windows XP";
                                break;
                            case 2:
                                text = "Microsoft Windows 2003";
                                break;
                            default:
                                text = "Microsoft NT 5.x";
                                break;
                        }
                        break;
                    case 6:
                        text = "Microsoft Windows Vista or 2008 Server";
                        break;
                }
                break;
        }
        text = string.Format("{0}{1} -- {2}", text, Environment.NewLine, os.ToString());
        dict.Add("Operating System", text);
        dict.Add("Operating System Installation Directory", Environment.SystemDirectory);
        dict.Add(".Net Version", Environment.Version.ToString());
        dict.Add(".Net Language", System.Globalization.CultureInfo.InstalledUICulture.EnglishName);
        dict.Add("Server Current Time", DateTime.Now.ToString());
        dict.Add("System Uptime", TimeSpan.FromMilliseconds(Environment.TickCount).ToString());
        dict.Add("Script Timeout", TimeSpan.FromSeconds(Server.ScriptTimeout).ToString());
        return dict;
    }
    private Information GetSystemStorageInfo()
    {
        Information dict = new Information();
        
        try { dict.Add("Logical Driver Information", string.Join(", ", Directory.GetLogicalDrives()).Replace(Path.DirectorySeparatorChar.ToString(), "")); }
        catch (Exception) { }

        try
        {
            foreach (DriveInfo d in DriveInfo.GetDrives())
            {
                try
                {
                    string label = string.Empty;
                    string size = string.Empty;

                    if (d.IsReady)
                    {
                        label = string.Format("{3,-10} {0} - <{1}> [{2}]", d.Name, d.VolumeLabel, d.DriveFormat, d.DriveType);
                        size = string.Format("Free {0} MB / Total {1} MB",
                            (d.TotalFreeSpace / (1024 * 1024)).ToString("N"),
                            (d.TotalSize / (1024 * 1024)).ToString("N")
                            );
                    }
                    else
                    {
                        label = string.Format("{1,-10} {0}", d.Name, d.DriveType);
                    }

                    dict.Add(
                        label,
                        size
                    );
                }
                catch (Exception) { }
            }
        }
        catch (Exception)
        { }
        
        return dict;
    }
    private Information GetSystemMemoryInfo()
    {
        Information dict = new Information();
        dict.Add("Current Working Set", string.Format("{0,10} MB", (Environment.WorkingSet / (1024 * 1024)).ToString("N")));
        try
        {
            if (Environment.OSVersion.Platform == PlatformID.Win32NT)
            {
                SystemInfo.MemoryInfo memory = SystemInfo.Memory;
                dict.Add("Physical Memory Size", string.Format("{0,10} MB", (memory.dwTotalPhys / (1024 * 1024)).ToString("N")));
                dict.Add("Physical Free Memory Size", string.Format("{0,10} MB", (memory.dwAvailPhys / (1024 * 1024)).ToString("N")));
                dict.Add("Physical Used Memory Size", string.Format("{0,10} MB", (memory.dwMemoryLoad / (1024 * 1024)).ToString("N")));
                dict.Add("PageFile Size", string.Format("{0,10} MB", (memory.dwTotalPageFile / (1024 * 1024)).ToString("N")));
                dict.Add("Available PageFile Size", string.Format("{0,10} MB", (memory.dwAvailPageFile / (1024 * 1024)).ToString("N")));
                dict.Add("Virtual Memory Size", string.Format("{0,10} MB", (memory.dwTotalVirtual / (1024 * 1024)).ToString("N")));
                dict.Add("Available Memory Size", string.Format("{0,10} MB", (memory.dwAvailVirtual / (1024 * 1024)).ToString("N")));
            }
        }
        catch (Exception) { }
        return dict;
    }
    private Information GetSystemProcessorInfo()
    {
        Information dict = new Information();
        dict.Add("Number of Processor", Environment.ProcessorCount.ToString());
        dict.Add("Processor Id", Environment.GetEnvironmentVariable("PROCESSOR_IDENTIFIER"));
        try
        {
            if (Environment.OSVersion.Platform == PlatformID.Win32NT)
            {
                SystemInfo.CpuInfo cpu = SystemInfo.Cpu;
                dict.Add("Processor Type", cpu.dwProcessorType.ToString());
                dict.Add("Processor Level", cpu.dwProcessorLevel.ToString());
                dict.Add("Processor OEM Id", cpu.dwOemId.ToString());
                dict.Add("Page Size", cpu.dwPageSize.ToString());
            }
        }
        catch (Exception) { }
        return dict;
    }

    private Information GetServerVariables()
    {
        Information dict = new Information();
        foreach (string key in Request.ServerVariables.AllKeys)
        {
            dict.Add(key, Request.ServerVariables[key]);
        }
        return dict;
    }
    private Information GetEnvironmentVariables()
    {
        Information dict = new Information();
        foreach (DictionaryEntry de in System.Environment.GetEnvironmentVariables())
        {
            dict.Add(de.Key.ToString(), de.Value.ToString());
        }
        return dict;
    }

    private Information GetSystemObjectInfo()
    {
        Information dict = new Information();
        dict.Add("Adodb.Connection", TestObject("Adodb.Connection").ToString());
        dict.Add("Adodb.RecordSet", TestObject("Adodb.RecordSet").ToString());
        dict.Add("Adodb.Stream", TestObject("Adodb.Stream").ToString());
        dict.Add("Scripting.FileSystemObject", TestObject("Scripting.FileSystemObject").ToString());
        dict.Add("Microsoft.XMLHTTP", TestObject("Microsoft.XMLHTTP").ToString());
        dict.Add("WScript.Shell", TestObject("WScript.Shell").ToString());
        dict.Add("MSWC.AdRotator", TestObject("MSWC.AdRotator").ToString());
        dict.Add("MSWC.BrowserType", TestObject("MSWC.BrowserType").ToString());
        dict.Add("MSWC.NextLink", TestObject("MSWC.NextLink").ToString());
        dict.Add("MSWC.Tools", TestObject("MSWC.Tools").ToString());
        dict.Add("MSWC.Status", TestObject("MSWC.Status").ToString());
        dict.Add("MSWC.Counters", TestObject("MSWC.Counters").ToString());
        dict.Add("IISSample.ContentRotator", TestObject("IISSample.ContentRotator").ToString());
        dict.Add("IISSample.PageCounter", TestObject("IISSample.PageCounter").ToString());
        dict.Add("MSWC.PermissionChecker", TestObject("MSWC.PermissionChecker").ToString());
        return dict;
    }
    private Information GetMailObjectInfo()
    {
        Information dict = new Information();
        dict.Add("JMail.SMTPMail", TestObject("JMail.SMTPMail").ToString());
        dict.Add("JMail.Message", TestObject("JMail.Message").ToString());
        dict.Add("CDONTS.NewMail", TestObject("CDONTS.NewMail").ToString());
        dict.Add("CDO.Message", TestObject("CDO.Message").ToString());
        dict.Add("Persits.MailSender", TestObject("Persits.MailSender").ToString());
        dict.Add("SMTPsvg.Mailer", TestObject("SMTPsvg.Mailer").ToString());
        dict.Add("DkQmail.Qmail", TestObject("DkQmail.Qmail").ToString());
        dict.Add("SmtpMail.SmtpMail.1", TestObject("SmtpMail.SmtpMail.1").ToString());
        dict.Add("Geocel.Mailer.1", TestObject("Geocel.Mailer.1").ToString());
        return dict;
    }
    private Information GetUploadObjectInfo()
    {
        Information dict = new Information();
        dict.Add("LyfUpload.UploadFile", TestObject("LyfUpload.UploadFile").ToString());
        dict.Add("Persits.Upload", TestObject("Persits.Upload").ToString());
        dict.Add("Ironsoft.UpLoad", TestObject("Ironsoft.UpLoad").ToString());
        dict.Add("aspcn.Upload", TestObject("aspcn.Upload").ToString());
        dict.Add("SoftArtisans.FileUp", TestObject("SoftArtisans.FileUp").ToString());
        dict.Add("SoftArtisans.FileManager", TestObject("SoftArtisans.FileManager").ToString());
        dict.Add("Dundas.Upload", TestObject("Dundas.Upload").ToString());
        dict.Add("w3.upload", TestObject("w3.upload").ToString());
        return dict;
    }
    private Information GetGraphicsObjectInfo()
    {
        Information dict = new Information();
        dict.Add("SoftArtisans.ImageGen", TestObject("SoftArtisans.ImageGen").ToString());
        dict.Add("W3Image.Image", TestObject("W3Image.Image").ToString());
        dict.Add("Persits.Jpeg", TestObject("Persits.Jpeg").ToString());
        dict.Add("XY.Graphics", TestObject("XY.Graphics").ToString());
        dict.Add("Ironsoft.DrawPic", TestObject("Ironsoft.DrawPic").ToString());
        dict.Add("Ironsoft.FlashCapture", TestObject("Ironsoft.FlashCapture").ToString());
        return dict;
    }
    private Information GetOtherObjectInfo()
    {
        Information dict = new Information();
        dict.Add("dyy.zipsvr", TestObject("dyy.zipsvr").ToString());
        dict.Add("hin2.com_iis", TestObject("hin2.com_iis").ToString());
        dict.Add("Socket.TCP", TestObject("Socket.TCP").ToString());
        return dict;
    }

    private Information GetSessionInfo()
    {
        Information dict = new Information();
        dict.Add("Session Count", Session.Contents.Count.ToString());
        dict.Add("Application Count", Application.Contents.Count.ToString());
        return dict;
    }
    private Information GetRequestHeaderInfo()
    {
        Information dict = new Information();
        foreach (string key in Request.Headers.AllKeys)
        {
            dict.Add(key, Request.Headers[key]);
        }
        return dict;
    }

    #endregion

    private bool TestObject(string progID)
    {
        try
        {
            Server.CreateObject(progID);
            return true;
        }
        catch (Exception)
        {
            return false;
        }
    }

    private void Output(Xml xml, SectionList obj, string xslPath)
    {
        XmlSerializer serializer = new XmlSerializer(typeof(SectionList));

        using (StringWriter writer = new StringWriter())
        {
            serializer.Serialize(writer, obj);
            xml.DocumentContent = writer.ToString();
            xml.TransformSource = xslPath;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        SectionList sections = new SectionList();

        sections.Add("System Information", GetSystemInfo());
        sections.Add("Processor Information", GetSystemProcessorInfo());
        sections.Add("Memory Information", GetSystemMemoryInfo());
        sections.Add("System Storage Information", GetSystemStorageInfo());
        sections.Add("Request Headers", GetRequestHeaderInfo());
        sections.Add("Server Variables", GetServerVariables());
        sections.Add("Environment Variables", GetEnvironmentVariables());
        sections.Add("Session Information", GetSessionInfo());
        sections.Add("System Object Information", GetSystemObjectInfo());
        sections.Add("Mail Object Information", GetMailObjectInfo());
        sections.Add("Upload Object Information", GetUploadObjectInfo());
        sections.Add("Graphics Object Information", GetGraphicsObjectInfo());
        sections.Add("Other Object Information", GetOtherObjectInfo());

        string xslpath = ConfigurationSettings.AppSettings["XslPath"];

        try { File.ReadAllText(MapPath(xslpath)); }
        catch (Exception) { xslpath = string.Empty; }

        if (string.IsNullOrEmpty(xslpath)) { xslpath = "~/info.xsl"; }

        Output(xmlSections, sections, xslpath);
    }
</script>
<asp:xml id="xmlSections" runat="server"></asp:xml>
