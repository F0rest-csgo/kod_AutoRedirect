#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "F0rest"
#define PLUGIN_VERSION "beta"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <server_redirect>
#include "kodinc.sp"
//#include <sdkhooks>

#pragma newdecls required
char g_ServerIP[24];
int maxplayer;
char smaxplayer[20];
ConVar redirectip;
ConVar maxplayercv;
EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Auto Redirect",
	author = PLUGIN_AUTHOR,
	description = "Auto Redirect Players if Server is Already Full",
	version = PLUGIN_VERSION,
	url = "https://kodplay.com"
};

public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	redirectip = CreateConVar("sm_redirectip", "***");
	maxplayercv = CreateConVar("sm_server_maxplayer", "50");
}

public void OnClientPutInServer(int client)
{
	CreateTimer(5.0, CheckPlayerCount,client);
	
}

public Action CheckPlayerCount(Handle timer,int client)
{
	bool playerflag[AdminFlags_TOTAL];
	playerflag = GetAccess(client);
	if(playerflag[OP] || playerflag[Root])
	{
		return;
	}
	maxplayercv.GetString(smaxplayer,sizeof(smaxplayer));
	maxplayer = StringToInt(smaxplayer);
	if(GetClientCount() > maxplayer)
	{
		redirectip.GetString(g_ServerIP, sizeof(g_ServerIP));
		RedirectClient(client, g_ServerIP);
	}
}
