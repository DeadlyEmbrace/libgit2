module deimos.git2.remote;

import deimos.git2.common;
import deimos.git2.indexer;
import deimos.git2.net;
import deimos.git2.oid;
import deimos.git2.proxy;
import deimos.git2.refspec;
import deimos.git2.repository;
import deimos.git2.strarray;
import deimos.git2.util;
import deimos.git2.transport;
import deimos.git2.types;

extern (C):

alias git_remote_rename_problem_cb = int function(const(char)* problematic_refspec, void *payload);

int git_remote_create(
		git_remote **out_,
		git_repository *repo,
		const(char)* name,
		const(char)* url);
int git_remote_create_with_fetchspec(
		git_remote **out_,
		git_repository *repo,
		const(char)* name,
		const(char)* url,
		const(char)* fetch);
int git_remote_create_inmemory(
		git_remote **out_,
		git_repository *repo,
		const(char)* fetch,
		const(char)* url);
int git_remote_load(git_remote **out_, git_repository *repo, const(char)* name);
int git_remote_save(const(git_remote)* remote);
git_repository* git_remote_owner(const(git_remote)* remote);
const(char)*  git_remote_name(const(git_remote)* remote);
const(char)*  git_remote_url(const(git_remote)* remote);
const(char)*  git_remote_pushurl(const(git_remote)* remote);
int git_remote_set_url(git_remote *remote, const(char)* url);
int git_remote_set_pushurl(git_remote *remote, const(char)* url);
int git_remote_add_fetch(git_remote *remote, const(char)* refspec);
int git_remote_get_fetch_refspecs(git_strarray *array, git_remote *remote);
int git_remote_set_fetch_refspecs(git_remote *remote, git_strarray *array);
int git_remote_add_push(git_remote *remote, const(char)* refspec);
int git_remote_get_push_refspecs(git_strarray *array, git_remote *remote);
int git_remote_set_push_refspecs(git_remote *remote, git_strarray *array);
void git_remote_clear_refspecs(git_remote *remote);
size_t git_remote_refspec_count(git_remote *remote);
const(git_refspec)* git_remote_get_refspec(git_remote *remote, size_t n);
int git_remote_connect(git_remote *remote, git_direction direction);
int git_remote_ls(const(git_remote_head)*** out_,  size_t *size, git_remote *remote);
int git_remote_download(git_remote *remote);
int git_remote_connected(git_remote *remote);
void git_remote_stop(git_remote *remote);
void git_remote_disconnect(git_remote *remote);
void git_remote_free(git_remote *remote);
int git_remote_update_tips(git_remote *remote);
int git_remote_fetch(git_remote *remote);
int git_remote_valid_url(const(char)* url);
int git_remote_supported_url(const(char)* url);
int git_remote_list(git_strarray *out_, git_repository *repo);
void git_remote_check_cert(git_remote *remote, int check);
int git_remote_set_transport(
	git_remote *remote,
	git_transport *transport);

enum git_remote_completion_type {
	GIT_REMOTE_COMPLETION_DOWNLOAD,
	GIT_REMOTE_COMPLETION_INDEXING,
	GIT_REMOTE_COMPLETION_ERROR,
}
mixin _ExportEnumMembers!git_remote_completion_type;

struct git_remote_callbacks {
	uint version_ = GIT_REMOTE_CALLBACKS_VERSION;
	int function(const(char)* str, int len, void *data) progress;
	int function(git_remote_completion_type type, void *data) completion;
	int function(git_cred **cred, const(char)* url, const(char)* username_from_url, uint allowed_types, void *data) credentials;
	int function(const(git_transfer_progress)* stats, void *data) transfer_progress;
	int function(const(char)* refname, const(git_oid)* a, const(git_oid)* b, void *data) update_tips;
	void *payload;
}

enum GIT_REMOTE_CALLBACKS_VERSION = 1;
enum git_remote_callbacks GIT_REMOTE_CALLBACKS_INIT = { GIT_REMOTE_CALLBACKS_VERSION };

enum git_fetch_prune_t
{
	GIT_FETCH_PRUNE_UNSPECIFIED,
	GIT_FETCH_PRUNE,
	GIT_FETCH_NO_PRUNE
}

int git_remote_set_callbacks(git_remote *remote, git_remote_callbacks *callbacks);
const(git_transfer_progress)*  git_remote_stats(git_remote *remote);

enum git_remote_autotag_option_t {
	GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED = 0,
	GIT_REMOTE_DOWNLOAD_TAGS_AUTO = 1,
	GIT_REMOTE_DOWNLOAD_TAGS_NONE = 2,
	GIT_REMOTE_DOWNLOAD_TAGS_ALL = 3
}
mixin _ExportEnumMembers!git_remote_autotag_option_t;

struct git_fetch_options
{
	int version_ = GIT_FETCH_OPTIONS_VERSION;
	git_remote_callbacks callbacks;
	git_fetch_prune_t prune;
	int update_fetchhead;
	git_remote_autotag_option_t download_tags;
	git_proxy_options proxy_opts;
	git_strarray custom_headers;
}

enum GIT_FETCH_OPTIONS_VERSION = 1;
enum git_fetch_options GIT_FETCH_OPTIONS_INIT = { GIT_FETCH_OPTIONS_VERSION, GIT_REMOTE_CALLBACKS_INIT, git_fetch_prune_t.GIT_FETCH_PRUNE_UNSPECIFIED, 1,
				 git_remote_autotag_option_t.GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED, GIT_PROXY_OPTIONS_INIT };

git_remote_autotag_option_t git_remote_autotag(git_remote *remote);
void git_remote_set_autotag(
	git_remote *remote,
	git_remote_autotag_option_t value);
int git_remote_rename(
	git_remote *remote,
	const(char)* new_name,
	git_remote_rename_problem_cb callback,
	void *payload);
int git_remote_update_fetchhead(git_remote *remote);
void git_remote_set_update_fetchhead(git_remote *remote, int value);
int git_remote_is_valid_name(const(char)* remote_name);
