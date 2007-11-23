<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes"/>
  <xsl:template match="/SectionList">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>System Information</title>
        <style type="text/css">
          body {background-color: #ffffff; color: #000000;}
          body, td, th, h1, h2 {font-family: sans-serif;}
          pre {margin: 0px; font-family: monospace;}
          a:link {color: #000099; text-decoration: none; background-color: #ffffff;}
          a:hover {text-decoration: underline;}
          table {border-collapse: collapse; border:0}
          td, th { border: 1px solid #000000; font-size: 75%; vertical-align: baseline;}
          h1 {font-size: 150%;}
          h2 {font-size: 125%;}
          .p {text-align: left;}
          .section {text-align: center;}
          .section table { margin-left: auto; margin-right: auto; text-align: left;}
          .section th { text-align: center !important; }
          .name {background-color: #ccccff; font-weight: bold; color: #000000;}
          .header {background-color: #9999cc; font-weight: bold; color: #000000;}
          .value {background-color: #cccccc; color: #000000;}
          .value_true {background-color: #cccccc; color: #00ff00;}
          .value_false {background-color: #cccccc; color: #ff0000;}
        </style>
      </head>
      <body>
        <div>
          <div class="sectionlist">
            <xsl:for-each select="Section">
              <div class="section">
                <h2>
                  <xsl:value-of select="@Name"/>
                </h2>
                <xsl:apply-templates select="Value" />
              </div>
            </xsl:for-each>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="Value">
    <table class="Information" width="80%">
      <tr class="header">
        <th>Name</th>
        <th>Value</th>
      </tr>
      <xsl:for-each select="NameValue">
        <tr>
          <td class="name">
            <xsl:value-of select="@Name"/>
          </td>
          <td class="value">
            <xsl:choose>
              <xsl:when test="Value='True'">
                <xsl:attribute name="class">value_true</xsl:attribute>
              </xsl:when>
              <xsl:when test="Value='False'">
                <xsl:attribute name="class">value_false</xsl:attribute>
              </xsl:when>
            </xsl:choose>
            <xsl:value-of select="Value"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
</xsl:stylesheet>

