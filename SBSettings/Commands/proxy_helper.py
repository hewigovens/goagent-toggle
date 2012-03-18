import plistlib
import os

#keys
NETWORK_KEY       = 'NetworkServices'
PROXY_KEY         = 'Proxies'
PAC_ENABLE_KEY    = 'ProxyAutoConfigEnable'
PAC_STRING_KEY    = 'ProxyAutoConfigURLString'
PAC_STRING_VALUE  = 'http://127.0.0.1:8089/goagent.pac'
HTTP_ENABLE_KEY   = 'HTTPEnable'
HTTPS_ENABLE_KEY  = 'HTTPSEnable'
HTTP_PORT_KEY     = 'HTTPPort'
HTTP_PROXY_KEY    = 'HTTPProxy'
HTTP_PORT_VALUE   = 8087
HTTP_PROXY_VALUE  = '127.0.0.1' 
HTTPS_PORT_KEY    = 'HTTPSPort'
HTTPS_PROXY_KEY   = 'HTTPSProxy'
HTTPS_PORT_VALUE  = 8087
HTTPS_PROXY_VALUE = '127.0.0.1' 
PROXY_TYPE_KEY    = 'HTTPProxyType'
FTP_PASSIVE_KEY   = 'FTPPassive'

BACKUP_PATH       = '/var/mobile/goagent-local/backup'
PREFERENCES_PLIST = '/Library/Preferences/SystemConfiguration/preferences.plist'

def change(plistFile):
    '''auto change pac settings'''
    os.system('mkdir -pv %s' % BACKUP_PATH)
    os.system('cp %s %s/preferences.plist.original' % (PREFERENCES_PLIST,BACKUP_PATH))

    os.system('plutil -convert xml1 %s' % plistFile)
    root=plistlib.readPlist(plistFile)

    try:
        for interface in root[NETWORK_KEY]:
            if FTP_PASSIVE_KEY not in root[NETWORK_KEY][interface][PROXY_KEY].keys():
                root[NETWORK_KEY][interface][PROXY_KEY][HTTP_ENABLE_KEY] = 0
                root[NETWORK_KEY][interface][PROXY_KEY][HTTP_PORT_KEY] = HTTP_PORT_VALUE
                root[NETWORK_KEY][interface][PROXY_KEY][HTTP_PROXY_KEY] = HTTP_PROXY_VALUE
                root[NETWORK_KEY][interface][PROXY_KEY][PROXY_TYPE_KEY] = 2
                root[NETWORK_KEY][interface][PROXY_KEY][HTTPS_ENABLE_KEY] = 0
                root[NETWORK_KEY][interface][PROXY_KEY][HTTPS_PORT_KEY] = HTTPS_PORT_VALUE
                root[NETWORK_KEY][interface][PROXY_KEY][HTTPS_PROXY_KEY] = HTTPS_PROXY_VALUE
                root[NETWORK_KEY][interface][PROXY_KEY][PAC_ENABLE_KEY] = 1
                root[NETWORK_KEY][interface][PROXY_KEY][PAC_STRING_KEY] = PAC_STRING_VALUE
    except Exception,e:
        print e

    plistlib.writePlist(root,plistFile)
    os.system('plutil -convert binary1 %s' % plistFile)

if __name__ == '__main__':
    change(PREFERENCES_PLIST)

