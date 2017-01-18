module deimos.git2.cherrypick;

import deimos.git2.checkout;
import deimos.git2.common;
import deimos.git2.types;
import deimos.git2.merge;

extern (C):

struct git_cherrypick_options
{
    uint version_ = GIT_CHERRYPICK_OPTIONS_VERSION;
    uint mainline;
    git_merge_opts merge_opts;
    git_checkout_options checkout_opts;
}

enum GIT_CHERRYPICK_OPTIONS_VERSION = 1;
enum git_cherrypick_options GIT_CHERRYPICK_OPTIONS_INIT = {GIT_CHERRYPICK_OPTIONS_VERSION, 0, GIT_MERGE_OPTS_INIT, GIT_CHECKOUT_OPTS_INIT};

int git_cherrypick_init_options(git_cherrypick_options *opts, uint version_);

int git_cherrypick_commit(git_index **out_, git_repository *repo, git_commit *cherrypick_commit, git_commit *our_commit, uint mainline, const(git_merge_opts)* merge_options);
int git_cherrypick(git_repository *repo, git_commit *commit, const(git_cherrypick_options)* cherrypick_options);