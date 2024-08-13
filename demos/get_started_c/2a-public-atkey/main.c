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

    atclient_atkey my_public_key;
    atclient_atkey_init(&my_public_key);

    const char *atkey_key = "phone";
    const char *atkey_sharedby = ATSIGN;
    const char *atkey_namespace = "wavi"; 

    if((exit_code = atclient_atkey_create_public_key(&my_public_key, atkey_key, atkey_sharedby, atkey_namespace)) != 0) {
        goto exit;
    }

    exit_code = 0;
exit:
{
    atclient_atkey_free(&my_public_key);
    return exit_code;
}
}