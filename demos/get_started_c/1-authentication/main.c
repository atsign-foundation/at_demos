#include <atclient/atclient.h>
#include <atclient/atclient_utils.h>
#include <atlogger/atlogger.h>
#include <stdlib.h>

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

    atclient atclient;
    atclient_init(&atclient);

    /*
     * this function will find the atServer's address from the atDirectory
     * and populate the `atserver_host` and `atserver_port` variables
     * with the atServer's address and port.
     * Don't forget to free the `atserver_host` variable after use, when using this function.
     */
    if (atclient_utils_find_atserver_address(ATSERVER_HOST, ATSERVER_PORT, ATSIGN, &atserver_host, &atserver_port) != 0)
    {
        exit_code = -1;
        goto exit;
    }

    /*
     * my keys are assumed to be set up in ~/.atsign/keys/@soccer99_key.atKeys
     * this function will read the keys from the file and populate the `atkeys` variable
     */
    if (atclient_utils_populate_atkeys_from_homedir(&atkeys, ATSIGN) != 0)
    {
        exit_code = -1;
        goto exit;
    }

    /*
     * this function will connect to the atServer, if it is not already connected,
     * then authenticate to the atServer and establish an authenticated connection
     * using the populated `atkeys` variable.
     */
    if (atclient_pkam_authenticate(&atclient, atserver_host, atserver_port, &atkeys, ATSIGN) != 0)
    {
        exit_code = -1;
        goto exit;
    }

    exit_code = 0;
exit:
{
    free(atserver_host);
    atclient_atkeys_free(&atkeys);
    atclient_free(&atclient);
    return exit_code;
}
}
