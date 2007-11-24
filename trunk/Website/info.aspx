<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Runtime.InteropServices" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>System Information</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style type="text/css">
      a:link {color: #000099; text-decoration: none; background-color: #ffffff;}
      a:hover {text-decoration: underline;}
      body {font-family: Georgia, "Times New Roman", Times, serif; text-align: center}
      table {margin-left: auto; margin-right: auto; text-align: left; border-collapse: collapse; border:0;}
      td, th {border: 1px solid #000000; font-size: 75%; vertical-align: baseline;}
      .title {font-size: 150%;}
      .section {text-align: center; width=90%}
      .header {text-align: center; background-color: #9999cc; font-weight: bold; color: #000000;}
      .name {background-color: #ccccff; font-weight: bold; color: #000000;}
      .value {background-color: #cccccc; color: #000000;}
      .value_true {background-color: #cccccc; color: #00ff00;}
      .value_false {background-color: #cccccc; color: #ff0000;}
    </style>
</head>
<body>
    <asp:Panel ID="PanelGeneral" runat="server"></asp:Panel>
    <br id="br1" runat="server" />
</body>
</html>
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
    #endregion

    #region Get Information Function

    private DataTable GetSystemInfo()
    {
        DataTable table = GenerateDataTable("System Information");
        //	Server Name
        Assign(table, "Server Name", Server.MachineName);
        Assign(table, "Server IP", Request.ServerVariables["LOCAl_ADDR"]);
        Assign(table, "Server Domain", Request.ServerVariables["Server_Name"]);
        Assign(table, "Server Port", Request.ServerVariables["Server_Port"]);
        //	Web Server
        Assign(table, "Web Server Version", Request.ServerVariables["Server_SoftWare"]);
        //	Path
        Assign(table, "Virtual Request Path", Request.FilePath);
        Assign(table, "Physical Request Path", Request.PhysicalPath);
        Assign(table, "Virtual Application Root Path", Request.ApplicationPath);
        Assign(table, "Physical Application Root Path", Request.PhysicalApplicationPath);
        //	Platform
        OperatingSystem os = Environment.OSVersion;
        string text = string.Empty;
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
        Assign(table, "Operating System", text);
        Assign(table, "Operating System Installation Directory", Environment.SystemDirectory);
        Assign(table, ".Net Version", Environment.Version.ToString());
        Assign(table, ".Net Language", System.Globalization.CultureInfo.InstalledUICulture.EnglishName);
        Assign(table, "Server Current Time", DateTime.Now.ToString());
        Assign(table, "System Uptime", TimeSpan.FromMilliseconds(Environment.TickCount).ToString());
        Assign(table, "Script Timeout", TimeSpan.FromSeconds(Server.ScriptTimeout).ToString());
        return table;
    }
    private DataTable GetSystemStorageInfo()
    {
        DataTable table = GenerateDataTable("Storage Information");

        try { Assign(table, "Logical Driver Information", string.Join(", ", Directory.GetLogicalDrives()).Replace(Path.DirectorySeparatorChar.ToString(), "")); }
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

                    Assign(table,
                        label,
                        size
                    );
                }
                catch (Exception) { }
            }
        }
        catch (Exception)
        { }

        return table;
    }
    private DataTable GetSystemMemoryInfo()
    {
        DataTable table = GenerateDataTable("Memory Information"); ;
        Assign(table, "Current Working Set", string.Format("{0,10} MB", (Environment.WorkingSet / (1024 * 1024)).ToString("N")));
        try
        {
            if (Environment.OSVersion.Platform == PlatformID.Win32NT)
            {
                SystemInfo.MemoryInfo memory = SystemInfo.Memory;
                Assign(table, "Physical Memory Size", string.Format("{0,10} MB", (memory.dwTotalPhys / (1024 * 1024)).ToString("N")));
                Assign(table, "Physical Free Memory Size", string.Format("{0,10} MB", (memory.dwAvailPhys / (1024 * 1024)).ToString("N")));
                Assign(table, "Physical Used Memory Size", string.Format("{0,10} MB", (memory.dwMemoryLoad / (1024 * 1024)).ToString("N")));
                Assign(table, "PageFile Size", string.Format("{0,10} MB", (memory.dwTotalPageFile / (1024 * 1024)).ToString("N")));
                Assign(table, "Available PageFile Size", string.Format("{0,10} MB", (memory.dwAvailPageFile / (1024 * 1024)).ToString("N")));
                Assign(table, "Virtual Memory Size", string.Format("{0,10} MB", (memory.dwTotalVirtual / (1024 * 1024)).ToString("N")));
                Assign(table, "Available Memory Size", string.Format("{0,10} MB", (memory.dwAvailVirtual / (1024 * 1024)).ToString("N")));
            }
        }
        catch (Exception) { }
        return table;
    }
    private DataTable GetSystemProcessorInfo()
    {
        DataTable table = GenerateDataTable("Processor Information");
        Assign(table, "Number of Processor", Environment.ProcessorCount.ToString());
        Assign(table, "Processor Id", Environment.GetEnvironmentVariable("PROCESSOR_IDENTIFIER"));
        try
        {
            if (Environment.OSVersion.Platform == PlatformID.Win32NT)
            {
                SystemInfo.CpuInfo cpu = SystemInfo.Cpu;
                Assign(table, "Processor Type", cpu.dwProcessorType.ToString());
                Assign(table, "Processor Level", cpu.dwProcessorLevel.ToString());
                Assign(table, "Processor OEM Id", cpu.dwOemId.ToString());
                Assign(table, "Page Size", cpu.dwPageSize.ToString());
            }
        }
        catch (Exception) { }
        return table;
    }

    private DataTable GetServerVariables()
    {
        DataTable table = GenerateDataTable("Server Variables");
        foreach (string key in Request.ServerVariables.AllKeys)
        {
            Assign(table, key, Request.ServerVariables[key]);
        }
        return table;
    }
    private DataTable GetEnvironmentVariables()
    {
        DataTable table = GenerateDataTable("Environment Variables");
        foreach (DictionaryEntry de in System.Environment.GetEnvironmentVariables())
        {
            Assign(table, de.Key.ToString(), de.Value.ToString());
        }
        return table;
    }

    private DataTable GetSystemObjectInfo()
    {
        DataTable table = GenerateDataTable("System COM Component Information");
        Assign(table, "Adodb.Connection", TestObject("Adodb.Connection").ToString());
        Assign(table, "Adodb.RecordSet", TestObject("Adodb.RecordSet").ToString());
        Assign(table, "Adodb.Stream", TestObject("Adodb.Stream").ToString());
        Assign(table, "Scripting.FileSystemObject", TestObject("Scripting.FileSystemObject").ToString());
        Assign(table, "Microsoft.XMLHTTP", TestObject("Microsoft.XMLHTTP").ToString());
        Assign(table, "WScript.Shell", TestObject("WScript.Shell").ToString());
        Assign(table, "MSWC.AdRotator", TestObject("MSWC.AdRotator").ToString());
        Assign(table, "MSWC.BrowserType", TestObject("MSWC.BrowserType").ToString());
        Assign(table, "MSWC.NextLink", TestObject("MSWC.NextLink").ToString());
        Assign(table, "MSWC.Tools", TestObject("MSWC.Tools").ToString());
        Assign(table, "MSWC.Status", TestObject("MSWC.Status").ToString());
        Assign(table, "MSWC.Counters", TestObject("MSWC.Counters").ToString());
        Assign(table, "IISSample.ContentRotator", TestObject("IISSample.ContentRotator").ToString());
        Assign(table, "IISSample.PageCounter", TestObject("IISSample.PageCounter").ToString());
        Assign(table, "MSWC.PermissionChecker", TestObject("MSWC.PermissionChecker").ToString());
        return table;
    }
    private DataTable GetMailObjectInfo()
    {
        DataTable table = GenerateDataTable("Mail COM Component Information");
        Assign(table, "JMail.SMTPMail", TestObject("JMail.SMTPMail").ToString());
        Assign(table, "JMail.Message", TestObject("JMail.Message").ToString());
        Assign(table, "CDONTS.NewMail", TestObject("CDONTS.NewMail").ToString());
        Assign(table, "CDO.Message", TestObject("CDO.Message").ToString());
        Assign(table, "Persits.MailSender", TestObject("Persits.MailSender").ToString());
        Assign(table, "SMTPsvg.Mailer", TestObject("SMTPsvg.Mailer").ToString());
        Assign(table, "DkQmail.Qmail", TestObject("DkQmail.Qmail").ToString());
        Assign(table, "SmtpMail.SmtpMail.1", TestObject("SmtpMail.SmtpMail.1").ToString());
        Assign(table, "Geocel.Mailer.1", TestObject("Geocel.Mailer.1").ToString());
        return table;
    }
    private DataTable GetUploadObjectInfo()
    {
        DataTable table = GenerateDataTable("Upload COM Component Information");
        Assign(table, "LyfUpload.UploadFile", TestObject("LyfUpload.UploadFile").ToString());
        Assign(table, "Persits.Upload", TestObject("Persits.Upload").ToString());
        Assign(table, "Ironsoft.UpLoad", TestObject("Ironsoft.UpLoad").ToString());
        Assign(table, "aspcn.Upload", TestObject("aspcn.Upload").ToString());
        Assign(table, "SoftArtisans.FileUp", TestObject("SoftArtisans.FileUp").ToString());
        Assign(table, "SoftArtisans.FileManager", TestObject("SoftArtisans.FileManager").ToString());
        Assign(table, "Dundas.Upload", TestObject("Dundas.Upload").ToString());
        Assign(table, "w3.upload", TestObject("w3.upload").ToString());
        return table;
    }
    private DataTable GetGraphicsObjectInfo()
    {
        DataTable table = GenerateDataTable("Graphics COM Component Information");
        Assign(table, "SoftArtisans.ImageGen", TestObject("SoftArtisans.ImageGen").ToString());
        Assign(table, "W3Image.Image", TestObject("W3Image.Image").ToString());
        Assign(table, "Persits.Jpeg", TestObject("Persits.Jpeg").ToString());
        Assign(table, "XY.Graphics", TestObject("XY.Graphics").ToString());
        Assign(table, "Ironsoft.DrawPic", TestObject("Ironsoft.DrawPic").ToString());
        Assign(table, "Ironsoft.FlashCapture", TestObject("Ironsoft.FlashCapture").ToString());
        return table;
    }
    private DataTable GetOtherObjectInfo()
    {
        DataTable table = GenerateDataTable("Other COM Component Information");
        Assign(table, "dyy.zipsvr", TestObject("dyy.zipsvr").ToString());
        Assign(table, "hin2.com_iis", TestObject("hin2.com_iis").ToString());
        Assign(table, "Socket.TCP", TestObject("Socket.TCP").ToString());
        return table;
    }

    private DataTable GetSessionInfo()
    {
        DataTable table = GenerateDataTable("Session Information");
        Assign(table, "Session Count", Session.Contents.Count.ToString());
        Assign(table, "Application Count", Application.Contents.Count.ToString());
        return table;
    }
    private DataTable GetRequestHeaderInfo()
    {
        DataTable table = GenerateDataTable("Request Headers");
        foreach (string key in Request.Headers.AllKeys)
        {
            Assign(table, key, Request.Headers[key]);
        }
        return table;
    }

    #endregion

    #region Helper Methods

    private DataTable GenerateDataTable(string name)
    {
        DataTable table = new DataTable(name);
        table.Columns.Add("Name", typeof(string));
        table.Columns.Add("Value", typeof(string));
        return table;
    }

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

    private void Assign(DataTable table, string name, string value)
    {
        DataRow row = table.NewRow();
        row["Name"] = name;
        row["Value"] = value;
        table.Rows.Add(row);
    }

    private void LoadInformation(DataTable table)
    {
        DataGrid grid = new DataGrid();
        BoundColumn col;

        col = new BoundColumn();
        col.DataField = "Name";
        col.HeaderText = "Name";
        col.ItemStyle.CssClass = "name";
        grid.Columns.Add(col);

        col = new BoundColumn();
        col.DataField = "Value";
        col.HeaderText = "Value";
        col.ItemStyle.CssClass = "value";
        grid.Columns.Add(col);

        grid.AutoGenerateColumns = false;
        grid.HeaderStyle.CssClass = "header";
        grid.DataSource = new DataView(table);
        grid.DataBind();
        
        
        foreach(DataGridItem item in grid.Items)
        {
            if(item.Cells.Count == 2){
                TableCell cell = item.Cells[1];
                //  change true/false style
                switch (cell.Text.ToLower())
                {
                    case "true":
                        cell.CssClass = "value_true";
                        break;
                    case "false":
                        cell.CssClass = "value_false";
                        break;
                }
                //  wrap <pre> for text contain newline.
                if (cell.Text.Contains(Environment.NewLine))
                {
                    cell.Text = string.Format("<pre>{0}</pre>", cell.Text);
                }
            }
        }

        HtmlGenericControl title = new HtmlGenericControl("h1");
        title.InnerText = Server.HtmlEncode(table.TableName);
        title.Attributes.Add("class", "title");

        Panel panel = new Panel();
        panel.CssClass = "section";

        panel.Controls.Add(title);
        panel.Controls.Add(grid);
        panel.Controls.Add(new HtmlGenericControl("p"));
        
        PanelGeneral.Controls.Add(panel);
    }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        LoadInformation(GetSystemInfo());
        LoadInformation(GetSystemProcessorInfo());
        LoadInformation(GetSystemMemoryInfo());
        LoadInformation(GetSystemStorageInfo());
        LoadInformation(GetRequestHeaderInfo());
        LoadInformation(GetServerVariables());
        LoadInformation(GetEnvironmentVariables());
        LoadInformation(GetSessionInfo());
        LoadInformation(GetSystemObjectInfo());
        LoadInformation(GetMailObjectInfo());
        LoadInformation(GetUploadObjectInfo());
        LoadInformation(GetGraphicsObjectInfo());
        LoadInformation(GetOtherObjectInfo());
    }
</script>
