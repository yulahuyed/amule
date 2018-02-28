#!/usr/bin/env sh

set -x

AMULE_HOME=/home/amule/.aMule
AMULE_CONF=${AMULE_HOME}/amule.conf
REMOTE_CONF=${AMULE_HOME}/remote.conf
AMULE_DEFAULT_PWD=plop
AMULE_ENCODED_PWD=$(echo -n ${AMULE_DEFAULT_PWD} | md5sum | cut -d ' ' -f 1)

if [ ! -f ${AMULE_CONF} ]; then
    echo "${AMULE_CONF} file NOT found. Generating new default configuration ..."
    cat > ${AMULE_CONF} <<- EOM
[eMule]
AppVersion=2.3.1
Nick=http://www.aMule.org
QueueSizePref=50
MaxUpload=0
MaxDownload=0
SlotAllocation=2
Port=4662
UDPPort=4672
UDPEnable=1
Address=
Autoconnect=1
MaxSourcesPerFile=300
MaxConnections=500
MaxConnectionsPerFiveSeconds=20
RemoveDeadServer=1
DeadServerRetry=3
ServerKeepAliveTimeout=0
Reconnect=1
Scoresystem=1
Serverlist=0
AddServerListFromServer=0
AddServerListFromClient=0
SafeServerConnect=0
AutoConnectStaticOnly=0
UPnPEnabled=0
UPnPTCPPort=50000
SmartIdCheck=1
ConnectToKad=1
ConnectToED2K=1
TempDir=/temp
IncomingDir=/incoming
ICH=1
AICHTrust=0
CheckDiskspace=1
MinFreeDiskSpace=1
AddNewFilesPaused=0
PreviewPrio=0
ManualHighPrio=0
StartNextFile=0
StartNextFileSameCat=0
StartNextFileAlpha=0
FileBufferSizePref=16
DAPPref=1
UAPPref=1
AllocateFullFile=0
OSDirectory=${AMULE_HOME}
OnlineSignature=0
OnlineSignatureUpdate=5
EnableTrayIcon=0
MinToTray=0
ConfirmExit=1
StartupMinimized=0
3DDepth=10
ToolTipDelay=1
ShowOverhead=0
ShowInfoOnCatTabs=1
VerticalToolbar=0
GeoIPEnabled=1
ShowVersionOnTitle=0
VideoPlayer=
StatGraphsInterval=3
statsInterval=30
DownloadCapacity=300
UploadCapacity=100
StatsAverageMinutes=5
VariousStatisticsMaxValue=100
SeeShare=2
FilterLanIPs=1
ParanoidFiltering=1
IPFilterAutoLoad=1
IPFilterURL=
FilterLevel=127
IPFilterSystem=0
FilterMessages=1
FilterAllMessages=0
MessagesFromFriendsOnly=0
MessageFromValidSourcesOnly=1
FilterWordMessages=0
MessageFilter=
ShowMessagesInLog=1
FilterComments=0
CommentFilter=
ShareHiddenFiles=0
AutoSortDownloads=0
NewVersionCheck=0
AdvancedSpamFilter=1
MessageUseCaptchas=1
Language=
SplitterbarPosition=75
YourHostname=
DateTimeFormat=%A, %x, %X
AllcatType=0
ShowAllNotCats=0
SmartIdState=0
DropSlowSources=0
KadNodesUrl=http://upd.emule-security.org/nodes.dat
Ed2kServersUrl=http://gruk.org/server.met.gz
ShowRatesOnTitle=0
GeoLiteCountryUpdateUrl=http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
StatsServerName=Shorty's ED2K stats
StatsServerURL=http://ed2k.shortypower.dyndns.org/?hash=
[Browser]
OpenPageInTab=1
CustomBrowserString=
[Proxy]
ProxyEnableProxy=0
ProxyType=0
ProxyName=
ProxyPort=1080
ProxyEnablePassword=0
ProxyUser=
ProxyPassword=
[ExternalConnect]
UseSrcSeeds=0
AcceptExternalConnections=1
ECAddress=
ECPort=4712
ECPassword=${AMULE_ENCODED_PWD}
UPnPECEnabled=0
ShowProgressBar=1
ShowPercent=1
UseSecIdent=1
IpFilterClients=1
IpFilterServers=1
TransmitOnlyUploadingClients=0
[WebServer]
Enabled=1
Password=${AMULE_ENCODED_PWD}
PasswordLow=
Port=4711
WebUPnPTCPPort=50001
UPnPWebServerEnabled=0
UseGzip=1
UseLowRightsUser=0
PageRefreshTime=120
Template=AmuleWebUI-Reloaded
Path=amuleweb
[GUI]
HideOnClose=0
[Razor_Preferences]
FastED2KLinksHandler=1
[SkinGUIOptions]
Skin=
[Statistics]
MaxClientVersions=0
[Obfuscation]
IsClientCryptLayerSupported=1
IsCryptLayerRequested=1
IsClientCryptLayerRequired=0
CryptoPaddingLenght=254
CryptoKadUDPKey=338883508
[PowerManagement]
PreventSleepWhileDownloading=0
[UserEvents]
[UserEvents/DownloadCompleted]
CoreEnabled=0
CoreCommand=
GUIEnabled=0
GUICommand=
[UserEvents/NewChatSession]
CoreEnabled=0
CoreCommand=
GUIEnabled=0
GUICommand=
[UserEvents/OutOfDiskSpace]
CoreEnabled=0
CoreCommand=
GUIEnabled=0
GUICommand=
[UserEvents/ErrorOnCompletion]
CoreEnabled=0
CoreCommand=
GUIEnabled=0
GUICommand=
[HTTPDownload]
URL_1=
EOM
    echo "${AMULE_CONF} successfullly generated. Don't forget to CHANGE DEFAULT PASSWORD !"
else
    echo "${AMULE_CONF} file found. Using existing configuration."
fi

if [ ! -f ${REMOTE_CONF} ]; then
    echo "${REMOTE_CONF} file NOT found. Generating new default configuration ..."
    cat > ${REMOTE_CONF} <<- EOM
Locale=
[EC]
Host=localhost
Port=4712
Password=${AMULE_ENCODED_PWD}
[Webserver]
Port=4711
UPnPWebServerEnabled=0
UPnPTCPPort=50001
Template=default
UseGzip=1
AllowGuest=0
AdminPassword=${AMULE_ENCODED_PWD}
GuestPassword=
EOM
    echo "${REMOTE_CONF} successfullly generated. Don't forget to CHANGE DEFAULT PASSWORD !"
else
    echo "${REMOTE_CONF} file found. Using existing configuration."
fi

if [ "${NGROK_AUTH}" ]
then
    /home/amule/ngrok authtoken ${NGROK_AUTH}
    nohup /home/amule/ngrok http 4711 > /dev/null 2>&1 &
fi

if [ "${RL_CONFIG}" ]
then
    wget -O "${RL_CONFIG}"
    crond -c /home/amule/cron
fi

nohup /home/amule/.aMule/filebrowser --port 8080 --no-auth > /dev/null 2>&1 &

/usr/bin/amuled -c ${AMULE_HOME} -o 
