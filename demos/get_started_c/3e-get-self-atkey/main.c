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

    atclient_atkey my_self_atkey;
    atclient_atkey_init(&my_self_atkey);

    /*
     * Let's declare a null pointer which will later be allocated by our `atclient_get_public_key` function. It is our responsibility to free it once we are
     * done with it.
     */
    char *value = NULL;

    if ((exit_code = atclient_utils_find_atserver_address(ATSERVER_HOST, ATSERVER_PORT, ATSIGN, &atserver_host, &atserver_port)) != 0)
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
    const char *atkey_namespace = "c_demos";

    if ((exit_code = atclient_atkey_create_self_key(&my_self_atkey, atkey_key, atkey_shared_by, atkey_namespace)) != 0)
    {
        goto exit;
    }

    /*
     * `atclient_get_self_key` will allocate memory for the `value` pointer. It is our responsibility to free it once we are done with it.
     * We will pass `NULL` into the request_options argument for now and just use the default request options.
     */
    if ((exit_code = atclient_get_self_key(&atclient, &my_self_atkey, &value, NULL)) != 0)
    {
        goto exit;
    }

    atlogger_log("3E-get-self-atkey", ATLOGGER_LOGGING_LEVEL_INFO, "value: \"%s\"\n", value);

    exit_code = 0;
exit:
{
    free(atserver_host);
    atclient_atkeys_free(&atkeys);
    atclient_free(&atclient);
    atclient_atkey_free(&my_self_atkey);
    free(value);
    return exit_code;
}
}
