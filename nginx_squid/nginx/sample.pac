function FindProxyForURL(url, host)
{
    if (!isInNet(myIpAddress(), "192.168.4.0", "255.255.255.0"))
    {
        return "DIRECT";
    }
    else if (shExpMatch(host, "*.google.com"))
    {
        return "PROXY 192.168.4.15:13128";
    }
    else
    {
        return "DIRECT";
    }
}