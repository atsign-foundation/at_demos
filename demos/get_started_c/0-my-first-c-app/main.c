#include <atclient/atclient.h>
#include <atclient/atclient_utils.h>
#include <atclient/constants.h>
#include <atlogger/atlogger.h>
#include <stdlib.h>

#define ATSIGN "@jeremy_0"

int main()
{
    int exit_code = -1;

    atlogger_set_logging_level(ATLOGGER_LOGGING_LEVEL_DEBUG);

    char *atserver_host = NULL;
    int atserver_port = 0;

    atclient_atkeys atkeys;
    atclient_atkeys_init(&atkeys);

    atclient atclient;
    atclient_init(&atclient);

    if ((exit_code = atclient_utils_find_atserver_address(ATCLIENT_ATDIRECTORY_PRODUCTION_HOST, ATCLIENT_ATDIRECTORY_PRODUCTION_PORT, ATSIGN, &atserver_host, &atserver_port)) != 0)
    {
        goto exit;
    }

    if ((exit_code = atclient_utils_populate_atkeys_from_homedir(&atkeys, ATSIGN)) != 0)
    {
        goto exit;
    }
    
    if ((exit_code = atclient_pkam_authenticate(&atclient, atserver_host, atserver_port, &atkeys, ATSIGN)) != 0)
    {
        goto exit;
    }

    atlogger_log("my_first_c_app", ATLOGGER_LOGGING_LEVEL_INFO, "Authenticated to atServer successfully!\n");

    exit_code = 0;
exit:
{
    free(atserver_host);
    atclient_atkeys_free(&atkeys);
    atclient_free(&atclient);
    return exit_code;
}
}
