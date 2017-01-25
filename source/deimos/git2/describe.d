module deimos.git2.describe;

import deimos.git2.common;
import deimos.git2.types;
import deimos.git2.buffer;

enum git_describe_strategy_t
{
    GIT_DESCRIBE_DEFAULT,
    GIT_DESCRIBE_TAGS,
    GIT_DESCRIBE_ALL
}

struct git_describe_options
{
    uint version_;
    uint max_candidates_tags;
    const(char)* pattern;
    int only_follow_first_parent;
    int show_commit_oid_as_fallback; 
}

enum GIT_DESCRIBE_DEFAULT_MAX_CANDIDATES_TAGS = 10;
enum GIT_DESCRIBE_DEFAULT_ABBREVIATED_SIZE = 7;
enum GIT_DESCRIBE_OPTIONS_VERSION = 1;
enum git_describe_options GIT_DESCRIBE_OPTIONS_INIT = {
    GIT_DESCRIBE_OPTIONS_VERSION,
    GIT_DESCRIBE_DEFAULT_MAX_CANDIDATES_TAGS
};

int git_describe_init_options(git_describe_options *opts, uint version_);

struct git_describe_format_options
{
    uint version_;
    uint _abbreviated_size;
    int always_use_long_format;
    const(char)* dirty_suffix;
}

enum GIT_DESCRIBE_FORMAT_OPTIONS_VERSION = 1;
enum git_describe_format_options GIT_DESCRIBE_FORMAT_OPTIONS_INIT = {
    GIT_DESCRIBE_FORMAT_OPTIONS_VERSION,
    GIT_DESCRIBE_DEFAULT_ABBREVIATED_SIZE
};

int git_describe_init_format_options(git_describe_format_options *opts, uint version_);

struct git_describe_result
{
    @disable this();
    @disable this(this);
}

int git_describe_commit(git_describe_result **result,
    git_object *commitish,
    git_describe_options *opts);

int git_describe_workdir(git_describe_result **out_,
    git_repository *repo,
    git_describe_options *opts);

void git_describe_result_free(git_describe_result *result);