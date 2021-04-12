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

	static public function reboot(ip:String):TPLinkKasaResponseData
	{
		return TPLinkKasa.runCommand(ip, TPLinkKasa.REBOOT_DEVICE);
	}

	static public function setLEDOnOff(ip:String, on:Bool):TPLinkKasaResponseData
	{
		return TPLinkKasa.runCommand(ip, on ? TPLinkKasa.LED_ON : TPLinkKasa.LED_OFF);
	}
	
	static public function toggleLED(ip:String):Bool
	{
		var wasOn:Bool = isLEDOn(ip);
		TPLinkKasa.runCommand(ip, wasOn ? TPLinkKasa.LED_OFF : TPLinkKasa.LED_ON);
		return !wasOn;
	}
	
	static public function isLEDOn(ip:String):Bool
	{
		var r:TPLinkKasaResponseData = getStatus(ip);
		if (r==null)
			return false;

		var isOn:Bool = true;
		try
		{
			isOn = r.system.get_sysinfo.led_off==0;
		}
		catch(e:haxe.Exception)
		{
			//...
		}
		return isOn;
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