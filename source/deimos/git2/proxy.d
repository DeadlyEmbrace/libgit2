module deimos.git2.proxy;

import deimos.git2.common;
import deimos.git2.transport;
import deimos.git2.types;

extern (C):

enum git_proxy_t
{
    GIT_PROXY_NONE,
    GIT_PROXY_AUTO,
    GIT_PROXY_SPECIFIED
}

struct git_proxy_options
{
    uint version_ = GIT_PROXY_OPTIONS_VERSION;

    git_proxy_t type;
    const(char)* url;
    git_cred_acquire_cb credentials;
    git_transport_certificate_check_cb certificate_check;
    void *payload;
}

enum GIT_PROXY_OPTIONS_VERSION = 1;
enum git_proxy_options GIT_PROXY_OPTIONS_INIT = { GIT_PROXY_OPTIONS_VERSION };

int git_proxy_init_options(git_proxy_options *opts, uint version_);