#include <atclient/atclient.h>
#include <atclient/atclient_utils.h>
#include <atclient/connection_hooks.h>
#include <atclient/constants.h>
#include <atclient/notify.h>
#include <atlogger/atlogger.h>
#include <stdlib.h>

#define TAG "5a-hooks"

#define ATSIGN "@soccer0"

void *pre_write_hook(atclient_connection_hook_params *params)
{
    atlogger_log(TAG, ATLOGGER_LOGGING_LEVEL_INFO, "pre_write_hook called\n");
    return NULL;
}

int setup_hooks(atclient *atclient)
{
    int exit_code;

    if ((exit_code = atclient_connection_hooks_enable(&(atclient->atserver_connection))) != 0)
    {
        return exit_code;
    }

    if ((exit_code = atclient_connection_hooks_set(&(atclient->atserver_connection), ATCLIENT_CONNECTION_HOOK_TYPE_PRE_WRITE, pre_write_hook)) != 0)
    {
        return exit_code;
    }

    exit_code = 0;
    return exit_code;
}

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

    if ((exit_code = atclient_utils_find_atserver_address(ATCLIENT_ATDIRECTORY_PRODUCTION_HOST, ATCLIENT_ATDIRECTORY_PRODUCTION_PORT, ATSIGN, &atserver_host, &atserver_port)) != 0)
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
     * Set up hooks so that we can run code before our connection writes to the atServer.
     */
    if ((exit_code = setup_hooks(&atclient1)) != 0)
    {
        goto exit;
    }
    atlogger_log(TAG, ATLOGGER_LOGGING_LEVEL_INFO, "Hooks set up successfully.\n");

    /*
     * Now at this point, it's business as normal.
     * For the sake of this example, we're going to send a notification.
     * Since we set up a pre write hook, it will log a message before we send any data to the atServer.
     */
    if ((exit_code = atclient_atkey_create_shared_key(&atkey, "phone", ATSIGN, "@soccer99", "c_demos")) != 0)
    {
        goto exit;
    }

    if ((exit_code = atclient_notify_params_set_atkey(&notify_params, &atkey)) != 0)
    {
        goto exit;
    }

    const char *value = "Hello! This is a notification!";
    if ((exit_code = atclient_notify_params_set_value(&notify_params, value)) != 0)
    {
        goto exit;
    }

    if ((exit_code = atclient_notify(&atclient1, &notify_params, NULL)) != 0)
    {
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
