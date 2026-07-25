#if defined _ER_MYSQL_INCLUDED
    #endinput
#endif
#define _ER_MYSQL_INCLUDED

stock ER_MySQLConnect()
{
    MainPipeline = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB);
    if(mysql_errno(MainPipeline) != 0)
    {
        printf("[ExpressRP MySQL] Connection failed. Error: %d", mysql_errno(MainPipeline));
        SendRconCommand("exit");
        return 0;
    }
    print("[ExpressRP MySQL] Connected successfully.");
    mysql_tquery(MainPipeline, "SET SESSION sql_mode='';");
    return 1;
}

stock ER_MySQLClose()
{
    if(MainPipeline) mysql_close(MainPipeline);
    return 1;
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
    printf("[ExpressRP MySQL Error %d] Callback: %s", errorid, callback);
    printf("[ExpressRP MySQL Error] %s", error);
    printf("[ExpressRP MySQL Query] %s", query);
    return 1;
}
