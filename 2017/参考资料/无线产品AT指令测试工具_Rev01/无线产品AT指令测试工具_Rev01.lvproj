<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="12008004">
	<Item Name="我的电脑" Type="My Computer">
		<Property Name="IOScan.Faults" Type="Str"></Property>
		<Property Name="IOScan.NetVarPeriod" Type="UInt">100</Property>
		<Property Name="IOScan.NetWatchdogEnabled" Type="Bool">false</Property>
		<Property Name="IOScan.Period" Type="UInt">10000</Property>
		<Property Name="IOScan.PowerupMode" Type="UInt">0</Property>
		<Property Name="IOScan.Priority" Type="UInt">9</Property>
		<Property Name="IOScan.ReportModeConflict" Type="Bool">true</Property>
		<Property Name="IOScan.StartEngineOnDeploy" Type="Bool">false</Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">我的电脑/VI服务器</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">我的电脑/VI服务器</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="无线产品AT指令测试工具_Rev01.vi" Type="VI" URL="../无线产品AT指令测试工具_Rev01.vi"/>
		<Item Name="依赖关系" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="eventvkey.ctl" Type="VI" URL="/&lt;vilib&gt;/event_ctls.llb/eventvkey.ctl"/>
				<Item Name="Simple Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Simple Error Handler.vi"/>
				<Item Name="VISA Configure Serial Port" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port"/>
				<Item Name="VISA Configure Serial Port (Instr).vi" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port (Instr).vi"/>
				<Item Name="VISA Configure Serial Port (Serial Instr).vi" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port (Serial Instr).vi"/>
				<Item Name="VISA Open Access Mode.ctl" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Open Access Mode.ctl"/>
			</Item>
			<Item Name="接收数据保存到文件.vi" Type="VI" URL="../接收数据保存到文件.vi"/>
		</Item>
		<Item Name="程序生成规范" Type="Build">
			<Item Name="无线产品AT指令测试工具_Rev01" Type="EXE">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{9EB8C1EE-E442-4C99-93D7-592C4356896A}</Property>
				<Property Name="App_INI_GUID" Type="Str">{BF438AEE-27C2-46DF-B759-D295FC2019CD}</Property>
				<Property Name="App_winsec.description" Type="Str">http://www.LSD.com</Property>
				<Property Name="Bld_buildCacheID" Type="Str">{ABD9548A-1612-4B7E-AE65-2FDCD953609C}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">无线产品AT指令测试工具_Rev01</Property>
				<Property Name="Bld_defaultLanguage" Type="Str">ChineseS</Property>
				<Property Name="Bld_excludeInlineSubVIs" Type="Bool">true</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">/E/自写资料（包括原理图，程序，代码，标准）/2015年项目资料/labview上位机应用程序/NI_AB_PROJECTNAME</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{CBA41AB7-99E0-4D2C-A545-FC471E1A0B08}</Property>
				<Property Name="Destination[0].destName" Type="Str">无线产品AT指令测试工具_Rev01.exe</Property>
				<Property Name="Destination[0].path" Type="Path">/E/自写资料（包括原理图，程序，代码，标准）/2015年项目资料/labview上位机应用程序/NI_AB_PROJECTNAME/无线产品AT指令测试工具_Rev01.exe</Property>
				<Property Name="Destination[0].path.type" Type="Str">&lt;none&gt;</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">支持目录</Property>
				<Property Name="Destination[1].path" Type="Path">/E/自写资料（包括原理图，程序，代码，标准）/2015年项目资料/labview上位机应用程序/NI_AB_PROJECTNAME/data</Property>
				<Property Name="Destination[1].path.type" Type="Str">&lt;none&gt;</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Source[0].itemID" Type="Str">{9F1CF8BE-A94D-467E-8B4A-30976C343915}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/我的电脑/无线产品AT指令测试工具_Rev01.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">2</Property>
				<Property Name="TgtF_companyName" Type="Str">LSD</Property>
				<Property Name="TgtF_fileDescription" Type="Str">无线产品AT指令测试工具_Rev01</Property>
				<Property Name="TgtF_fileVersion.major" Type="Int">1</Property>
				<Property Name="TgtF_internalName" Type="Str">无线产品AT指令测试工具_Rev01</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">版权 2016 LSD</Property>
				<Property Name="TgtF_productName" Type="Str">无线产品AT指令测试工具_Rev01</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{FCED8903-A91E-4877-8E66-34198C3D3C3F}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">无线产品AT指令测试工具_Rev01.exe</Property>
			</Item>
		</Item>
	</Item>
</Project>
