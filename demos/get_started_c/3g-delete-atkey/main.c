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

    atclient_atkey my_shared_atkey;
    atclient_atkey_init(&my_shared_atkey);

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

    const char *atkey_key = "phone";
    const char *atkey_shared_by = ATSIGN;
    const char *atkey_shared_with = "@soccer0";
    const char *atkey_namespace = "c_demos";

    if ((exit_code = atclient_atkey_create_shared_key(&my_shared_atkey, atkey_key, atkey_shared_by, atkey_shared_with, atkey_namespace)) != 0)
    {
        goto exit;
    }

    /*
     * `atclient_delete` will delete this shared atkey from our atServer. It is important to note that only the `shared_by` atSign can delete the shared atKey
     * When deleting, the `shared_by` atSign should always be the authenticated atSign in the `atclient` object.
     * We will pass `NULL` to the request_options and commit_id parameters because we want to use the default request_options and we don't care about the
     * commit_id we get back.
     */
    if ((exit_code = atclient_delete(&atclient, &my_shared_atkey, NULL, NULL) != 0)) {
        goto exit;
    }

    exit_code = 0;
exit:
{
    free(atserver_host);
    atclient_atkeys_free(&atkeys);
    atclient_free(&atclient);
    atclient_atkey_free(&my_shared_atkey);
    return exit_code;
}
}
