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

    atclient_atkey my_shared_key;
    atclient_atkey_init(&my_shared_key);

    const char *atkey_key = "phone";
    const char *atkey_sharedby = ATSIGN;
    const char *atkey_sharedwith = "@soccer99";
    const char *atkey_namespace = "wavi";

    if ((exit_code = atclient_atkey_create_shared_key(&my_shared_key, atkey_key, atkey_sharedby, atkey_sharedwith, atkey_namespace)) != 0)
    {
        goto exit;
    }

    /*
     * Now that the AtKey is properly set up, we can set the metadata of that AtKey like this.
     * Since we called the `atclient_atkey_init` function earlier, we can feel safe knowing that the metadata is also already initialized.
     */
    atclient_atkey_metadata *metadata = &(my_shared_key.metadata);

    /*
     * Set the ttl (time to live) of the AtKey. Once this AtKey is put into the atServer, it will only live for 1000 milliseconds.
     */
    if ((exit_code = atclient_atkey_metadata_set_ttl(metadata, 1 * 1000)) != 0)
    {
        goto exit;
    }

    /*
     * Set the ttr (time to refresh) of the AtKey. Once this AtKey is put into the atServer, the recipient of the AtKey will have it refreshed every 1000
     * milliseconds, in case there are any value changes.
     */
    if ((exit_code = atclient_atkey_metadata_set_ttr(metadata, 1 * 1000)) != 0)
    {
        goto exit;
    }

    exit_code = 0;
exit:
{
    atclient_atkey_free(&my_shared_key);
    return exit_code;
}
}