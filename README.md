# TPLinkKasa_SmartController

TP-Link WiFi SmartPlug Controller for written for Haxe 4.2 +

#### Description ####

A Haxe library for the proprietary TP-Link Smart Home protocol to control TP-Link HS100 and HS110 WiFi Smart Plugs.
The SmartHome protocol runs on TCP port 9999 and uses a trivial XOR autokey encryption that provides no security. 
There is no authentication mechanism and commands are accepted independent of device state (configured/unconfigured).

#### TDDP ####

TDDP is implemented across a whole range of TP-Link devices including routers, access points, cameras and smartplugs.
TDDP can read and write a device's configuration and issue special commands. UDP port 1040 is used to send commands, replies come back on UDP port 61000.

#### Support / tested ####

| Device      | Supported / tested           |
|-------------|------------------------------|
| KP105 Kasa  | Kasa Smart Wi-Fi Plug Slim   |
|             | More to come!                |

Credits goes to https://github.com/softScheck/tplink-smartplug for the research and python implementation which this
library is based upon.

