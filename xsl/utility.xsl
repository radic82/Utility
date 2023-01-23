<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:java="http://xml.apache.org/xalan/java" exclude-result-prefixes="java" 
	xmlns:date="http://exslt.org/dates-and-times" extension-element-prefixes="date">
	<xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>
	<xsl:variable name="CRLF">
		<xsl:text>&#10;</xsl:text>
	</xsl:variable>
	<!--====================================================================-->
	<!--Uppercase-->
	<!--====================================================================-->
	<xsl:template name="Uppercase">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:param name="string"/>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:value-of select="translate($string,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" disable-output-escaping="yes"/>
	</xsl:template>
	<!--====================================================================-->
	<!--Escape-->
	<!--====================================================================-->
	<xsl:template name="EscapeQuot">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:param name="string"/>
		<xsl:variable name="quot">&quot;</xsl:variable>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:choose>
			<xsl:when test="contains($string,$quot)">
				<xsl:value-of select="substring-before($string,$quot)" disable-output-escaping="yes"/>
				<xsl:text disable-output-escaping="yes"><![CDATA[\"]]></xsl:text>
				<xsl:call-template name="EscapeQuot">
					<xsl:with-param name="string" select="substring-after($string,$quot)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string" disable-output-escaping="yes"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--====================================================================-->
	<!--Escape-->
	<!--====================================================================-->
	<xsl:template name="EscapeApice">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:param name="string"/>
		<xsl:variable name="apice">&apos;</xsl:variable>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:choose>
			<xsl:when test="contains($string, $apice)">
				<xsl:value-of select="substring-before($string, $apice)" disable-output-escaping="no"/>
				<xsl:text disable-output-escaping="yes"><![CDATA[\']]></xsl:text>
				<xsl:call-template name="EscapeApice">
					<xsl:with-param name="string" select="substring-after($string,$apice)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string" disable-output-escaping="yes"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--====================================================================-->
	<!--Capitalize-->
	<!--====================================================================-->
	<xsl:template name="Capitalize">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:param name="string"/>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:choose>
			<xsl:when test="contains($string,'/')">
				<xsl:call-template name="Capitalize">
					<xsl:with-param name="string" select="contains($string,'/')"/>
				</xsl:call-template>
				<xsl:text/>
				<xsl:call-template name="Capitalize">
					<xsl:with-param name="string" select="contains($string,'/')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(translate(substring($string,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring($string,2))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--====================================================================-->
	<!--Truncate-->
	<!--====================================================================-->
	<xsl:template name="Truncate">
		<xsl:param name="text"/>
		<xsl:param name="lunghezza">180</xsl:param>
		<xsl:choose>
			<xsl:when test="string-length($text) &lt; number($lunghezza)">
				<xsl:value-of select="$text" disable-output-escaping="yes"/>
			</xsl:when>
			<xsl:when test="(number($lunghezza) &gt; 0) and (substring($text,number($lunghezza)) != ' ') and (substring($text,number($lunghezza)+1) != ' ')">
				<xsl:call-template name="TroncaTesto">
					<xsl:with-param name="text" select="substring($text,1,number($lunghezza)-1)"/>
					<xsl:with-param name="lunghezza" select="number($lunghezza)-1"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" disable-output-escaping="yes"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--====================================================================-->
	<!--StrMin-->
	<!--====================================================================-->
	<xsl:template name="LowerCase">
		<xsl:param name="string"/>
		<xsl:value-of select="translate($string,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" disable-output-escaping="yes"/>
	</xsl:template>
	<!--====================================================================-->
	<!--DateFormat-->
	<!--====================================================================-->
	<xsl:template name="DateFormat">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:param name="string"/>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:value-of select="concat(substring($string,9,2),'/',substring($string,6,2), '/',substring($string,1,4) ) "/>
	</xsl:template>
	<!--====================================================================-->
	<!--DateFormatFromDB-->
	<!-- from dd/mm/yyyy to yyyy-mm-dd -->
	<!--====================================================================-->
	<xsl:template name="DateFormatFromDB">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:param name="string"/>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:value-of select="concat(substring($string,7,4), '-', substring($string,4,2), '-', substring($string,1,2))"/>
	</xsl:template>
	<!--====================================================================-->
	<!--FullDateFormat-->
	<!--====================================================================-->
	<xsl:template name="FullDateFormat">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:param name="date"/>
		<xsl:param name="lang">it</xsl:param>
		<!-- vars ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="month" select="number(substring($date,6,2))"/>
		<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:choose>
			<xsl:when test="$lang = 'it'">
				<xsl:value-of select="concat(number(substring($date,9,2)), ' ')"/>
				<xsl:choose>
					<xsl:when test="number($month) = 1">gennaio</xsl:when>
					<xsl:when test="number($month) = 2">febbraio</xsl:when>
					<xsl:when test="number($month) = 3">marzo</xsl:when>
					<xsl:when test="number($month) = 4">aprile</xsl:when>
					<xsl:when test="number($month) = 5">maggio</xsl:when>
					<xsl:when test="number($month) = 6">giugno</xsl:when>
					<xsl:when test="number($month) = 7">luglio</xsl:when>
					<xsl:when test="number($month) = 8">agosto</xsl:when>
					<xsl:when test="number($month) = 9">settembre</xsl:when>
					<xsl:when test="number($month) = 10">ottobre</xsl:when>
					<xsl:when test="number($month) = 11">novembre</xsl:when>
					<xsl:when test="number($month) = 12">dicembre</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="number($month) = 1">january</xsl:when>
					<xsl:when test="number($month) = 2">february</xsl:when>
					<xsl:when test="number($month) = 3">march</xsl:when>
					<xsl:when test="number($month) = 4">april</xsl:when>
					<xsl:when test="number($month) = 5">may</xsl:when>
					<xsl:when test="number($month) = 6">june</xsl:when>
					<xsl:when test="number($month) = 7">july</xsl:when>
					<xsl:when test="number($month) = 8">august</xsl:when>
					<xsl:when test="number($month) = 9">september</xsl:when>
					<xsl:when test="number($month) = 10">october</xsl:when>
					<xsl:when test="number($month) = 11">november</xsl:when>
					<xsl:when test="number($month) = 12">december</xsl:when>
				</xsl:choose>
				<xsl:value-of select="concat(' ', number(substring($date,9,2)), ',')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="concat(' ', number(substring($date,1,4)))"/>
	</xsl:template>
	<!--====================================================================-->
	<!--CurrentDate-->
	<!--====================================================================-->
	<xsl:template name="CurrentDate">
		<!-- vars ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="locale" select="java:java.util.Locale.new('it','IT')"/>
		<xsl:variable name="calendar" select="java:java.util.GregorianCalendar.getInstance($locale)"/>
		<xsl:variable name="dateformat" select="java:java.text.SimpleDateFormat.new('yyyy-MM-dd')"/>
		<xsl:variable name="date" select="java:getTime($calendar)"/>
		<xsl:variable name="datevalue" select="java:format($dateformat,$date)"/>
		<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:value-of select="$datevalue"/>
	</xsl:template>
	<!--====================================================================-->
	<!--CurrentDateTime-->
	<!--====================================================================-->
	<xsl:template name="CurrentDateTime">
		<!--2009-11-03T16:47-->
		<xsl:variable name="locale" select="java:java.util.Locale.new('it','IT')"/>
		<xsl:variable name="calendar" select="java:java.util.GregorianCalendar.getInstance($locale)"/>
		<xsl:variable name="dateformat" select="java:java.text.SimpleDateFormat.new('yyyy-MM-dd')"/>
		<xsl:variable name="hourformat" select="java:java.text.SimpleDateFormat.new('HH:mm')"/>
		<xsl:variable name="date" select="java:getTime($calendar)"/>
		<xsl:variable name="datevalue" select="java:format($dateformat,$date)"/>
		<xsl:variable name="hourvalue" select="java:format($hourformat,$date)"/>
		<xsl:value-of select="concat($datevalue,'T',$hourvalue)"/>
	</xsl:template>
	<!--====================================================================-->
	<!-- RemoveHtmlTags -->
	<!--====================================================================-->
	<xsl:template name="RemoveHtmlTags">
		<xsl:param name="string"/>
		<xsl:choose>
			<xsl:when test="contains($string,'&lt;')">
				<xsl:value-of select="substring-before($string,'&lt;')" disable-output-escaping="yes"/>
				<xsl:text disable-output-escaping="yes"><![CDATA[]]></xsl:text>
				<xsl:call-template name="RemoveHtmlTags">
					<xsl:with-param name="string" select="substring-after($string,'&gt;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--====================================================================-->
	<!--RemoveNBSP -->
	<!--====================================================================-->
	<xsl:template name="RemoveNBSP">
		<xsl:param name="string"/>
		<xsl:call-template name="ReplaceString">
			<xsl:with-param name="text" select="$string"/>
			<xsl:with-param name="from">
				<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
			</xsl:with-param>
			<xsl:with-param name="to">
				<xsl:text><![CDATA[ ]]></xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--====================================================================-->
	<!-- Replace-->
	<!--====================================================================-->
	<xsl:template name="ReplaceString">
		<xsl:param name="text"/>
		<xsl:param name="from"/>
		<xsl:param name="to"/>
		<xsl:choose>
			<xsl:when test="contains($text, $from)">
				<xsl:variable name="before" select="substring-before($text, $from)"/>
				<xsl:variable name="after" select="substring-after($text, $from)"/>
				<xsl:variable name="prefix" select="concat($before, $to)"/>
				<xsl:value-of select="$before"/>
				<xsl:value-of select="$to"/>
				<xsl:call-template name="ReplaceString">
					<xsl:with-param name="text" select="$after"/>
					<xsl:with-param name="from" select="$from"/>
					<xsl:with-param name="to" select="$to"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--====================================================================-->
	<!-- javaReplaceString-->
	<!--====================================================================-->
	<xsl:template name="javaReplaceString">
		<xsl:param name="text"/>
		<xsl:param name="from"/>
		<xsl:param name="to" select="''"/>
		<xsl:variable name="str" select="java:java.lang.String.new($text)"/>
		<xsl:variable name="clean" select="java:replaceAll($str,$from, $to)"/>
		<xsl:value-of select="$clean"/>
	</xsl:template>
	<!--====================================================================-->
	<!--LastIndexOf-->
	<!--====================================================================-->
	<xsl:template name="lastIndexOf">
		<xsl:param name="string"/>
		<xsl:param name="char"/>
		<xsl:choose>
			<xsl:when test="contains($string, $char)">
				<xsl:call-template name="lastIndexOf">
					<xsl:with-param name="string" select="substring-after($string, $char)"/>
					<xsl:with-param name="char" select="$char"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--====================================================================-->
	<!--createLink -->
	<!--====================================================================-->
	<xsl:template name="createLink">
		<xsl:param name="link"/>
		<xsl:param name="target"/>
		<xsl:param name="text"/>
		<xsl:param name="color"/>
		<a href="{$link}" title="{$text}">
			<xsl:if test="$target = 'true'">
				<xsl:attribute name="target">_blank</xsl:attribute>
			</xsl:if>
			<xsl:if test="$color != ''">
				<xsl:attribute name="style"><xsl:value-of select="concat('color:',$color,';')"/></xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$text"/>
		</a>
	</xsl:template>
	<!--====================================================================-->
	<!--createImage -->
	<!--====================================================================-->
	<xsl:template name="createImage">
		<xsl:param name="image"/>
		<xsl:param name="format"/>
		<xsl:param name="urlsite"/>
		<xsl:variable name="dim">
			<xsl:choose>
				<xsl:when test="$format!='' and $preview!='true' ">
					<xsl:value-of select="concat($format,'_')"/>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$urlsite!=''">
				<xsl:value-of select="concat($urlsite,$image/@mediaserverpath,'/',$dim,$image/@resourcename)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($frontendpath,$image/@mediaserverpath,'/',$dim,$image/@resourcename)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--====================================================================-->
	<!--randomNumber-->
	<!--====================================================================-->
	<xsl:template name="randomNumber">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<!-- nMin e nMax compresi -->
		<xsl:param name="nMin">1</xsl:param>
		<xsl:param name="nMax"/>
		<!-- vars ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="random" select="java:java.util.Random.new()"/>
		<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:value-of select="java:nextInt($random, ($nMax + 1 - $nMin)) + $nMin"/>
	</xsl:template>
	<!--====================================================================-->
	<!-- format date with this format: 2010-06-11 11:02:26.051 -->
	<!--====================================================================-->
	<xsl:template name="FormatDate">
		<xsl:param name="DateTime"/>
		<xsl:variable name="YYYY">
			<xsl:value-of select="substring($DateTime,1,4)"/>
		</xsl:variable>
		<xsl:variable name="MM">
			<xsl:value-of select="substring($DateTime,6,2)"/>
		</xsl:variable>
		<xsl:variable name="DD">
			<xsl:value-of select="substring($DateTime,9,2)"/>
		</xsl:variable>
		<xsl:variable name="hh">
			<xsl:value-of select="substring($DateTime,12,2)"/>
		</xsl:variable>
		<xsl:variable name="mm">
			<xsl:value-of select="substring($DateTime,15,2)"/>
		</xsl:variable>
		<xsl:variable name="ss">
			<xsl:value-of select="substring($DateTime,18,2)"/>
		</xsl:variable>
		<xsl:variable name="fff">
			<xsl:value-of select="substring($DateTime,21,3)"/>
		</xsl:variable>
		<xsl:value-of select="$DD"/>/<xsl:value-of select="$MM"/>/<xsl:value-of select="$YYYY"/>
	</xsl:template>
	<!--====================================================================-->
	<!--EncodeUrl-->
	<!--====================================================================-->
	<xsl:template name="EncodeUrl">
		<xsl:param name="string"/>
		<xsl:variable name="str">
			<xsl:call-template name="LowerCase">
				<xsl:with-param name="string" select="$string"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="java:java.net.URLEncoder.encode($str)" disable-output-escaping="yes"/>
	</xsl:template>
	<!--====================================================================-->
	<!--DencodeUrl-->
	<!--====================================================================-->
	<xsl:template name="DecodeUrl">
		<xsl:param name="string"/>
		<xsl:value-of select="java:java.net.URLDecoder.decode($string)" disable-output-escaping="yes"/>
	</xsl:template>
	<!--====================================================================-->
	<!--cleanTextJson -->
	<!--====================================================================-->
	<xsl:template name="cleanTextJson">
		<xsl:param name="text"/>
		<xsl:call-template name="EscapeQuot">
			<xsl:with-param name="string">
				<xsl:call-template name="RemoveHtmlTags">
					<xsl:with-param name="string">
						<xsl:call-template name="RemoveNBSP">
							<xsl:with-param name="string" select="normalize-space($text)"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-->
	<!-- JSON Element -->
	<!--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-->
	<xsl:template name="JSONElement">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="type"/>
		<xsl:param name="first"/>
		<xsl:param name="last"/>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:variable name="openchar">
			<xsl:if test="($first='true')">
				<xsl:text>{</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="closechar">
			<xsl:choose>
				<xsl:when test="($last='true')">
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="stringmark">
			<xsl:if test="($type='string')">
				<xsl:text>"</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="escapedvalue">
			<xsl:choose>
				<xsl:when test="($type='string')">
					<xsl:call-template name="cleanTextJson">
						<xsl:with-param name="text" select="$value"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:value-of select="$openchar"/>
		<xsl:text>"</xsl:text>
		<xsl:value-of select="$name"/>
		<xsl:text>":</xsl:text>
		<xsl:value-of select="$stringmark"/>
		<xsl:value-of select="$escapedvalue"/>
		<xsl:value-of select="$stringmark"/>
		<xsl:value-of select="$closechar"/>
	</xsl:template>
	<!--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-->
	<!-- JS Array -->
	<!--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-->
	<xsl:template name="JSArray">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:param name="nodelist"/>
		<xsl:param name="type"/>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:variable name="stringmark">
			<xsl:if test="($type='string')">'</xsl:if>
		</xsl:variable>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:text>[</xsl:text>
		<xsl:for-each select="$nodelist">
			<xsl:value-of select="$stringmark"/>
			<xsl:choose>
				<xsl:when test="($type='string')">
					<xsl:call-template name="cleanTextJson">
						<xsl:with-param name="text" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$stringmark"/>
			<xsl:if test="position() &lt; last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>]</xsl:text>
	</xsl:template>
	<!--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-->
	<!-- JS Array Element -->
	<!--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-->
	<xsl:template name="JSArrayElement">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:param name="value"/>
		<xsl:param name="type"/>
		<xsl:param name="first"/>
		<xsl:param name="last"/>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:variable name="openchar">
			<xsl:if test="($first='true')">
				<xsl:text>[</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="closechar">
			<xsl:choose>
				<xsl:when test="($last='true')">
					<xsl:text>]</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="stringmark">
			<xsl:if test="($type='string')">
				<xsl:text>"</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="escapedvalue">
			<xsl:choose>
				<xsl:when test="($type='string')">
					<xsl:call-template name="cleanTextJson">
						<xsl:with-param name="text" select="$value"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:value-of select="$openchar"/>
		<xsl:value-of select="$stringmark"/>
		<xsl:value-of select="$escapedvalue"/>
		<xsl:value-of select="$stringmark"/>
		<xsl:value-of select="$closechar"/>
	</xsl:template>
	<!--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-->
	<!-- Set JS Var -->
	<!--::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-->
	<xsl:template name="SetJSVar">
		<!--params~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="type"/>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:variable name="stringmark">
			<xsl:if test="($type='string')">
				<xsl:text>"</xsl:text>
			</xsl:if>
		</xsl:variable>
		<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
		<xsl:text>var </xsl:text>
		<xsl:value-of select="$name"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$stringmark"/>
		<xsl:value-of select="$value"/>
		<xsl:value-of select="$stringmark"/>
		<xsl:text>;</xsl:text>
		<xsl:value-of select="$CRLF"/>
	</xsl:template>
	<!--====================================================================-->
	<!--CDataOpen-->
	<!--====================================================================-->
	<xsl:template name="CDataOpen">
		<xsl:text disable-output-escaping="yes"><![CDATA[<![C]]></xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[DATA[]]></xsl:text>
	</xsl:template>
	<!--====================================================================-->
	<!--CDataClose-->
	<!--====================================================================-->
	<xsl:template name="CDataClose">
		<xsl:text disable-output-escaping="yes"><![CDATA[]]]></xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[]>]]></xsl:text>
	</xsl:template>
</xsl:stylesheet>

