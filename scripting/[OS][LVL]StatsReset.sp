#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name = "[OS] [LVL] Stats Reset",
	author = "KiKiEEKi ( DS: kikieeki | vk.com/kikieeki )",
	version = "( PUBLIC 1.0 )"
};

int g_iHour;
int g_iMinute;
char g_sStats[16];

public void OnPluginStart()
{
	ConVar cvar;
	(cvar = CreateConVar("os_lvl_statsreset_hour", "6", "Час", FCVAR_NOTIFY)).AddChangeHook(ConVarChanged_1);
	ConVarChanged_1(cvar, NULL_STRING, NULL_STRING);
	(cvar = CreateConVar("os_lvl_statsreset_minute", "30", "Минут", FCVAR_NOTIFY)).AddChangeHook(ConVarChanged_2);
	ConVarChanged_2(cvar, NULL_STRING, NULL_STRING);
	(cvar = CreateConVar("os_lvl_statsreset_stats", "stats", "all - сбросит все данные.\nexp - сбросит данные о очках опыта (value, rank).\nstats - сбросит данные о статистике (kills, deaths, shoots, hits, headshots, assists, round_win, round_lose).",
		FCVAR_NOTIFY)).AddChangeHook(ConVarChanged_3);
	ConVarChanged_3(cvar, NULL_STRING, NULL_STRING);
	AutoExecConfig(true, "[OS][LVL]StatsReset");

	char sData[32];
	char sBuffer[4][4];
	FormatTime(sData, sizeof(sData), "%m-%d-%H-%M");
	ExplodeString(sData, "-", sBuffer, sizeof(sBuffer), sizeof(sBuffer[]));

	int iData[4];
	for(int i = 0; i < 4; ++i) iData[i] = StringToInt(sBuffer[i]);
	int iDay = OSGetDay(iData[0]);

	PrintToServer("==============================");
	PrintToServer("[OS] [LVL] Stats Reset");
	PrintToServer("Current date: Month %i Day %i Hour %i Minute %i",
		iData[0], iData[1], iData[2], iData[3]);
	PrintToServer("Reset date: Month %i Day %i Hour %i Minute %i",
		iData[0], iDay, g_iHour, g_iMinute);
	PrintToServer("==============================");

	//Доработать проверку час, дней
	if(iData[1] != iDay) return;
	if(iData[2] != g_iHour) return;
	if(iData[3] <= g_iMinute) return;

	PrintToServer("==============================");
	ServerCommand("sm_lvl_reset %s", g_sStats);
	PrintToServer("[OS] [LVL] Stats Reset ALL !!!");
	PrintToServer("==============================");
}

void ConVarChanged_1(ConVar cvar, const char[] oldValue, const char[] newValue) {
	g_iHour = cvar.IntValue;
}
void ConVarChanged_2(ConVar cvar, const char[] oldValue, const char[] newValue) {
	g_iMinute = cvar.IntValue;
}
void ConVarChanged_3(ConVar cvar, const char[] oldValue, const char[] newValue) {
	cvar.GetString(g_sStats, sizeof(g_sStats));
}

int OSGetDay(int iMonth)
{
	switch(iMonth) {
		case 2: return 28;				//Февраль ебать
		case 4, 6, 9, 11: return 30;	//30 дней в месяце
		default: return 31;				//Остальные
	}
}
