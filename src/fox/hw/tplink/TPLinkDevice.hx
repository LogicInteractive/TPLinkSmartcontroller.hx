package fox.hw.tplink;

import fox.hw.tplink.TPLinkKasa.TPLinkKasaResponseData;
import haxe.Json;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import sys.net.Host;
import sys.net.Socket;

class TPLinkDevice
{
	/////////////////////////////////////////////////////////////////////////////////////

	static public function getStatus(ip:String):TPLinkKasaResponseData
	{
		return TPLinkKasa.runCommand(ip, TPLinkKasa.GET_SYSINFO);
	}

	/////////////////////////////////////////////////////////////////////////////////////

}

class TPLink_KP105 extends TPLinkDevice
{
	/////////////////////////////////////////////////////////////////////////////////////

	static public function turnOn(ip:String):TPLinkKasaResponseData
	{
		return TPLinkKasa.runCommand(ip, TPLinkKasa.SMARTPLUG_ON);
	}

	static public function turnOff(ip:String):TPLinkKasaResponseData
	{
		return TPLinkKasa.runCommand(ip, TPLinkKasa.SMARTPLUG_OFF);
	}
	
	static public function toggle(ip:String):Bool
	{
		var wasOn:Bool = isOn(ip);
		TPLinkKasa.runCommand(ip, wasOn ? TPLinkKasa.SMARTPLUG_OFF : TPLinkKasa.SMARTPLUG_ON);
		return !wasOn;
	}
	
	static public function getStatus(ip:String):TPLinkKasaResponseData
	{
		return TPLinkDevice.getStatus(ip);
	}
	
	static public function isOn(ip:String):Bool
	{
		var r:TPLinkKasaResponseData = getStatus(ip);
		if (r==null)
			return false;

		var isOn:Bool = false;
		try
		{
			isOn = r.system.get_sysinfo.relay_state==1;
		}
		catch(e:haxe.Exception)
		{
			//...
		}
		return isOn;
	}

	/////////////////////////////////////////////////////////////////////////////////////
}