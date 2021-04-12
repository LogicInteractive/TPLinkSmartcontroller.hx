package fox.hw.tplink;

import haxe.Json;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import sys.net.Host;
import sys.net.Socket;

class TPLinkKasa
{
	/////////////////////////////////////////////////////////////////////////////////////

	static public inline var SMARTPLUG_ON		    : String  = '{"system":{"set_relay_state":{"state":1}}}';
	static public inline var SMARTPLUG_OFF		    : String  = '{"system":{"set_relay_state":{"state":0}}}';
	static public inline var GET_SYSINFO			: String  = '{"system":{"get_sysinfo":null}}';
	static public inline var LED_OFF				: String  = '{"system":{"set_led_off":{"off":1}}}';
	static public inline var LED_ON				    : String  = '{"system":{"set_led_off":{"off":0}}}';	

	/////////////////////////////////////////////////////////////////////////////////////

	static public function runCommand(ip:String,command:String,?encryption:TPLinkKasaEncryption=TPLinkKasaEncryption.hs105_hs220Encryption):TPLinkKasaResponseData
	{
		var returnData:TPLinkKasaResponseData = null;

		var b:Bytes = buildCommand(command,encryption);

		var socket = new Socket();
		var success = send(socket,ip,b);
		if (success)
			returnData = read(socket);

		socket.close();
		return returnData;
	}

	static function buildCommand(command:String, encryption:TPLinkKasaEncryption):Bytes
	{
		var payload:String = command;
    	var key:Int = 171;

		var bo:BytesOutput = new BytesOutput();
		bo.writeByte(0);
		bo.writeByte(0);
		bo.writeByte(0);
		if (encryption==TPLinkKasaEncryption.hs100_hs110Encryption)
			bo.writeByte(0);
		bo.writeInt8(payload.length);

		for (ch in 0...payload.length)
		{
      		var a:Int = key ^ payload.charCodeAt(ch); //simple XOR encryption
			key = a;
			bo.writeByte(a);
		}

		return bo.getBytes();
	}
	
	static function send(socket:Socket, ip:String,bytes:Bytes,port:Int=9999)
	{
		var success:Bool = false;
		try
		{
			socket.setTimeout(1);
			// socket.setBlocking(false);
			// socket.setFastSend(true);
			socket.connect(new Host(ip), port);
			socket.output.write(bytes);
			success = true;
		}
		catch (e:haxe.Exception)
		{ 
			trace(e.details());
			success = false;
		}
		return success;
	}

	static function read(socket:Socket):TPLinkKasaResponseData
	{
		var readBuffer:Bytes = Bytes.alloc(1024*8);
		var readBufferDataLength:Int = 0;

		var success:Bool = false;
		while(true)
		{
			try
			{
				readBufferDataLength = socket.input.readBytes(readBuffer,0,readBuffer.length);
				if (readBufferDataLength>0)
				{
					success = true;
					break;
				}
			}
			catch (e:haxe.Exception)
			{ 
				trace(e);
			}		
		}

		if (success && readBufferDataLength>0)
		{
			var data:TPLinkKasaResponseData = decode(readBuffer,readBufferDataLength);
			return data;
		}
		return null;
	}

	static function decode(buffer:Bytes,bufferDataLength:Int):TPLinkKasaResponseData
	{
    	var key:Int = 171;
		var msgStr:String="";
		var lead:Int = 4;

		var r:Int = 0;
		var a:Int = 0;

		var success:Bool = false;
		try
		{
			var bi:BytesInput = new BytesInput(buffer,0,bufferDataLength);
			for (i in 0...lead)
				bi.readByte(); // 0

			for (i in 0...bi.length-lead)
			{
				r = bi.readByte();
	      		a = key ^ r; //XOR decryption
				key = r;				
				msgStr+=String.fromCharCode(a);
			}
			success=true;
		}
		catch (e:haxe.Exception)
		{ 
			trace(e);
		}			

		if (!success || msgStr==null || msgStr.length==0)
			return null;

		var data:TPLinkKasaResponseData = null;
		success = false;
		try
		{
			data = Json.parse(msgStr);
			if (data!=null)
				success = true;
		}
		catch (e:haxe.Exception)
		{ 
			trace(e);
		}
		
		return success ? data : null;
	}

	/////////////////////////////////////////////////////////////////////////////////////
}


enum TPLinkKasaEncryption
{
	hs105_hs220Encryption;
	hs100_hs110Encryption;
}

typedef TPLinkKasaResponseData =
{
	var system			: TPLinkKasaSystemData;
}

typedef TPLinkKasaSystemData =
{
	var get_sysinfo		: TPLinkKasaSysInfo;
	var set_relay_state	: TPLinkKasaSetRelayStateResults;
}

typedef TPLinkKasaSysInfo =
{
	var sw_ver			: String;
	var hw_ver			: String;
	var model			: String;
	var deviceId		: String;
	var oemId			: String;
	var hwId			: String;
	var rssi			: Int;
	var longitude_i		: Int;
	var latitude_i		: Int;
	var alias			: String;
	var status			: String;
	var mic_type		: String;
	var feature			: String;
	var mac				: String;
	var updating		: Int;
	var led_off			: Int;
	var obd_src			: String;
	var relay_state		: Int;
	var on_time			: Int;
	var active_mode		: String;
	var icon_hash		: String;
	var dev_name		: String;
	var next_action		: Dynamic;
	var ntc_state		: Int;
	var err_code		: Int;
}


typedef TPLinkKasaSetRelayStateResults =
{
	var err_code		: Int;
}