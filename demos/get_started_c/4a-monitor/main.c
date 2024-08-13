#include <atclient/atclient.h>
#include <atclient/monitor.h>
#include <atclient/atclient_utils.h>
#include <atlogger/atlogger.h>
#include <stdlib.h>

#define TAG "4a-monitor"

#define ATSIGN "@soccer99"

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

    atclient monitor_client;
    atclient_init(&monitor_client);

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
     * Our monitor connection is just an ordinary atclient context, but we will use a completely separate atclient context to manage it.
     * And instead of calling the atclient functions on our atclient monitor context, we will use monitor functions on it instead.
     * In this case, we are using `atclient_monitor_pkam_authenticate` instead of `atclient_pkam_authenticate` even though it's essentially the same function
     * signature (aside from the function name)
     */
    if ((exit_code = atclient_monitor_pkam_authenticate(&monitor_client, atserver_host, atserver_port, &atkeys, ATSIGN)) != 0)
    {
        goto exit;
    }

    if((exit_code = atclient_monitor_start(&monitor_client, ".*")) != 0) {
        goto exit;
    }

    while (true)
    {
        atclient_monitor_response response;
        atclient_monitor_response_init(&response);

        exit_code = atclient_monitor_read(&monitor_client, &atclient1, &response, NULL);

        if (exit_code != 0)
        {
            if (response.type == ATCLIENT_MONITOR_ERROR_READ)
            {
                atlogger_log(TAG, ATLOGGER_LOGGING_LEVEL_ERROR, "Error reading from monitor: %d\n", response.error_read.error_code);
            }
            else if (response.type == ATCLIENT_MONITOR_ERROR_PARSE_NOTIFICATION)
            {
                atlogger_log(TAG, ATLOGGER_LOGGING_LEVEL_ERROR, "Parse notification from monitor: %d\n", exit_code);
            }
            else if (response.type == ATCLIENT_MONITOR_ERROR_DECRYPT_NOTIFICATION)
            {
                atlogger_log(TAG, ATLOGGER_LOGGING_LEVEL_ERROR, "Error response from monitor: %d\n", exit_code);
            } else {
                atlogger_log(TAG, ATLOGGER_LOGGING_LEVEL_ERROR, "Unknown error: %d\n", exit_code);
            }
        }
        else
        {

            if (response.type == ATCLIENT_MONITOR_MESSAGE_TYPE_NOTIFICATION)
            {
                if (atclient_atnotification_is_decrypted_value_initialized(&response.notification))
                {
                    atlogger_log(TAG, ATLOGGER_LOGGING_LEVEL_INFO, "Received notification: %s\n", response.notification.decrypted_value);
                }
            }
            else if (response.type == ATCLIENT_MONITOR_MESSAGE_TYPE_DATA_RESPONSE)
            {
                atlogger_log(TAG, ATLOGGER_LOGGING_LEVEL_INFO, "Received data: %s\n", response.data_response);
            }
            else if (response.type == ATCLIENT_MONITOR_MESSAGE_TYPE_ERROR_RESPONSE)
            {
                atlogger_log(TAG, ATLOGGER_LOGGING_LEVEL_ERROR, "Received error: %s\n", response.error_response);
            }
            else if (response.type == ATCLIENT_MONITOR_MESSAGE_TYPE_NONE)
            {
                atlogger_log(TAG, ATLOGGER_LOGGING_LEVEL_INFO, "No message received\n");
            } else {
                atlogger_log(TAG, ATLOGGER_LOGGING_LEVEL_ERROR, "Unknown message type: %d\n", response.type);
            }
        }

        atclient_monitor_response_free(&response);
    }

    exit_code = 0;
exit:
{
    free(atserver_host);
    atclient_atkeys_free(&atkeys);
    atclient_free(&atclient1);
    atclient_free(&monitor_client);
    return exit_code;
}
}
