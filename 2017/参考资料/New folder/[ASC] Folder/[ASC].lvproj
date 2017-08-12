<?xml version='1.0'?>
<Project Type="Project" LVVersion="8508002">
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">3363</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="LV Source" Type="Folder">
			<Item Name="Initialization" Type="Folder"/>
			<Item Name="Communication" Type="Folder">
				<Item Name="PC-MCU" Type="Folder">
					<Item Name="ASC-Original Comuciation.vi" Type="VI" URL="Source/LV Source/Communication/PC-MCU/ASC-Original Comuciation.vi"/>
				</Item>
				<Item Name="PC-PC" Type="Folder"/>
				<Item Name="ASC-Check Packet.vi" Type="VI" URL="Source/LV Source/Communication/ASC-Check Packet.vi"/>
				<Item Name="ASC-IP To Number.vi" Type="VI" URL="Source/LV Source/Communication/ASC-IP To Number.vi"/>
			</Item>
			<Item Name="Error Handling" Type="Folder">
				<Item Name="ASC-Errors Handle Dialoge.vi" Type="VI" URL="Source/LV Source/Error Handling/ASC-Errors Handle Dialoge.vi"/>
			</Item>
			<Item Name="Utilities" Type="Folder">
				<Item Name="ASC-Data Source.vi" Type="VI" URL="Source/LV Source/Utilities/ASC-Data Source.vi"/>
			</Item>
			<Item Name="Variables" Type="Folder"/>
			<Item Name="[ASC]Top Level VI.vi" Type="VI" URL="Source/LV Source/[ASC]Top Level VI.vi"/>
		</Item>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
	<Item Name="[Remote Target 1]" Type="RT FIELDPOINT">
		<Property Name="alias.name" Type="Str">[Remote Target 1]</Property>
		<Property Name="alias.value" Type="Str">0.0.0.0</Property>
		<Property Name="Bound" Type="Bool">false</Property>
		<Property Name="CCSymbols" Type="Str">RT,1;FP,1;</Property>
		<Property Name="Type" Type="Str">cFP-2120</Property>
		<Item Name="cFP-2120 @0" Type="FP Device">
			<Item Name="LED A ([Remote Target 1]\cFP-2120 @0)" Type="FP Point"/>
			<Item Name="LED B ([Remote Target 1]\cFP-2120 @0)" Type="FP Point"/>
			<Item Name="LED C ([Remote Target 1]\cFP-2120 @0)" Type="FP Point"/>
			<Item Name="LED D ([Remote Target 1]\cFP-2120 @0)" Type="FP Point"/>
			<Item Name="Input 1 ([Remote Target 1]\cFP-2120 @0)" Type="FP Point"/>
			<Item Name="Input 2 ([Remote Target 1]\cFP-2120 @0)" Type="FP Point"/>
			<Item Name="Temperature ([Remote Target 1]\cFP-2120 @0)" Type="FP Point"/>
			<Item Name="DIP Switch 3 ([Remote Target 1]\cFP-2120 @0)" Type="FP Point"/>
			<Item Name="DIP Switch 4 ([Remote Target 1]\cFP-2120 @0)" Type="FP Point"/>
			<Item Name="Power Source ([Remote Target 1]\cFP-2120 @0)" Type="FP Point"/>
		</Item>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
