package;

import fox.hw.tplink.TPLinkDevice.TPLink_KP105;
import fox.hw.tplink.TPLinkDevice;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import no.logic.fox.utils.StringUtils;
import sys.net.Host;
import sys.net.Socket;

/**
 * ...
 * @author Tommy S.
 */

function main()
{
	var ip = "192.168.68.138";
	// trace(TPLink_KP105.toggle(ip));

	TPLinkDevice.setLEDOnOff(ip,true);
}