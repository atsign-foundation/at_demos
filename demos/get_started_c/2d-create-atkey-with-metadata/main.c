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

    atclient_atkey my_shared_atkey;
    atclient_atkey_init(&my_shared_atkey);

    const char *atkey_key = "phone";
    const char *atkey_shared_by = ATSIGN;
    const char *atkey_shared_with = "@soccer99";
    const char *atkey_namespace = "wavi";

    if ((exit_code = atclient_atkey_create_shared_key(&my_shared_atkey, atkey_key, atkey_shared_by, atkey_shared_with, atkey_namespace)) != 0)
    {
        goto exit;
    }

    /*
     * Now that the AtKey is properly set up, we can set the metadata of that AtKey like this.
     * Since we called the `atclient_atkey_init` function earlier, we can feel safe knowing that the metadata is also already initialized.
     */
    atclient_atkey_metadata *metadata = &(my_shared_atkey.metadata);

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

    if(atclient_atkey_metadata_is_ttl_initialized(metadata)) {
        // metadata->ttl is safe to read and we know it is populated.
        atlogger_log("main", ATLOGGER_LOGGING_LEVEL_DEBUG, "metadata->ttl: %d\n", metadata->ttl); // [DEBG] 2024-08-15 01:52:09.596055 | main | metadata->ttl: 1000
    }

    exit_code = 0;
exit:
{
    atclient_atkey_free(&my_shared_atkey); // this _free command will automatically free the metadata as well
    return exit_code;
}
}