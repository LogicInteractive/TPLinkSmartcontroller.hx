package;

import fox.hw.tplink.TPLinkKasa;
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
	var check = TPLinkKasa.runCommand("192.168.68.138", TPLinkKasa.GET_SYSINFO);
	
	if (check.system.get_sysinfo.relay_state==0)
		TPLinkKasa.runCommand("192.168.68.138", TPLinkKasa.SMARTPLUG_ON);
	else
		TPLinkKasa.runCommand("192.168.68.138", TPLinkKasa.SMARTPLUG_OFF);
	
}