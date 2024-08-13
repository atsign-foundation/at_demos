#include <atclient/atclient.h>
#include <atclient/notify.h>
#include <atclient/atclient_utils.h>
#include <atlogger/atlogger.h>
#include <stdlib.h>

#define ATSIGN "@soccer0"

#define ATSERVER_HOST "root.atsign.org"
#define ATSERVER_PORT 64

int main()
{
    int exit_code = -1;

    atlogger_set_logging_level(ATLOGGER_LOGGING_LEVEL_DEBUG);

    char *atserver_host = NULL;
    int atserver_port = 0;

    atclient_atkeys atkeys;
    atclient_atkeys_init(&atkeys);

    atclient atclient1;
    atclient_init(&atclient1);

    atclient_atkey atkey;
    atclient_atkey_init(&atkey);

    atclient_notify_params notify_params;
    atclient_notify_params_init(&notify_params);

    if ((exit_code = atclient_utils_find_atserver_address(ATSERVER_HOST, ATSERVER_PORT, ATSIGN, &atserver_host, &atserver_port)) != 0)
    {
        goto exit;
    }

    if ((exit_code = atclient_utils_populate_atkeys_from_homedir(&atkeys, ATSIGN)) != 0)
    {
        goto exit;
    }

    if ((exit_code = atclient_pkam_authenticate(&atclient1, atserver_host, atserver_port, &atkeys, ATSIGN)) != 0)
    {
        goto exit;
    }

    /*
     * 1a. Set up atkey in our notify_params struct
     */
    if((exit_code = atclient_atkey_create_shared_key(&atkey, "phone", ATSIGN, "@soccer99", "c_demos")) != 0) {
        goto exit;
    }

    if((exit_code = atclient_notify_params_set_atkey(&notify_params, &atkey)) != 0) {
        goto exit;
    }

    /*
     * 1b. Set up value in our notify_params struct
     */
    const char *value = "Hello! This is a notification!";
    if((exit_code = atclient_notify_params_set_value(&notify_params, value)) != 0) {
        goto exit;
    }

    /*
     * 2. Send the notification
     * We will pass `NULL` for the commit id.
     */
    if((exit_code = atclient_notify(&atclient1, &notify_params, NULL)) != 0) {
        goto exit;
    }

    exit_code = 0;
exit:
{
    free(atserver_host);
    atclient_atkeys_free(&atkeys);
    atclient_free(&atclient1);
    atclient_atkey_free(&atkey);
    atclient_notify_params_free(&notify_params);
    return exit_code;
}
}
