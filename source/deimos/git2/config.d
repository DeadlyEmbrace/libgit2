module deimos.git2.config;

import deimos.git2.buffer;
import deimos.git2.common;
import deimos.git2.types;
import deimos.git2.util;
import deimos.git2.proxy;
import deimos.git2.sys.config;

extern (C):

enum git_config_level_t {
	GIT_CONFIG_LEVEL_PROGRAMDATA = 1,
	GIT_CONFIG_LEVEL_SYSTEM = 2,
	GIT_CONFIG_LEVEL_XDG = 3,
	GIT_CONFIG_LEVEL_GLOBAL = 4,
	GIT_CONFIG_LEVEL_LOCAL = 5,
	GIT_CONFIG_LEVEL_APP = 6,
	GIT_CONFIG_HIGHEST_LEVEL = -1,
}
mixin _ExportEnumMembers!git_config_level_t;

struct git_config_entry 
{
	const(char)* name;
	const(char)* value;
	git_config_level_t level;
	void *free(git_config_entry *entry);
	void *payload;
}

void git_config_entry_free(git_config_entry *);


alias git_config_foreach_cb = int function(const(git_config_entry)*, void *);
struct git_config_iterator {
	@disable this();
	@disable this(this);
}

enum git_cvar_t {
	GIT_CVAR_FALSE = 0,
	GIT_CVAR_TRUE = 1,
	GIT_CVAR_INT32,
	GIT_CVAR_STRING
}
mixin _ExportEnumMembers!git_cvar_t;

struct git_cvar_map {
	git_cvar_t cvar_type;
	const(char)* str_match;
	int map_value;
}

int git_config_find_global(git_buf *out_);
int git_config_find_xdg(git_buf *out_);
int git_config_find_system(git_buf *out_);
int git_config_find_programdata(git_buf *out_);

int git_config_open_default(git_config **out_);
int git_config_new(git_config **out_);
int git_config_add_file_ondisk(
	git_config *cfg,
	const(char)* path,
	git_config_level_t level,
	int force);
int git_config_open_ondisk(git_config **out_, const(char)* path);
int git_config_open_level(
	git_config **out_,
	const(git_config)* parent,
	git_config_level_t level);
int git_config_open_global(git_config **out_, git_config *config);
int git_config_snapshot(git_config **out_, git_config *config);
void git_config_free(git_config *cfg);
int git_config_get_entry(
	git_config_entry** out_,
	const(git_config)* cfg,
	const(char)* name);
int git_config_get_int32(int32_t *out_, const(git_config)* cfg, const(char)* name);
int git_config_get_int64(int64_t *out_, const(git_config)* cfg, const(char)* name);
int git_config_get_bool(int *out_, const(git_config)* cfg, const(char)* name);
int git_config_get_path(git_buf *out_, const(git_config)* cfg, const(char)* name);
int git_config_get_string(const(char)** out_, const(git_config)* cfg, const(char)* name);

int git_config_get_multivar_foreach(const(git_config)* cfg, const(char)* name, const(char)* regexp, git_config_foreach_cb callback, void *payload);
int git_config_multivar_iterator_new(git_config_iterator** out_, const(git_config)* cfg, const(char)* name, const(char)* regexp);
int git_config_next(git_config_entry **entry, git_config_iterator *iter);
void git_config_iterator_free(git_config_iterator *iter);
int git_config_set_int32(git_config *cfg, const(char)* name, int32_t value);
int git_config_set_int64(git_config *cfg, const(char)* name, int64_t value);
int git_config_set_bool(git_config *cfg, const(char)* name, int value);
int git_config_set_string(git_config *cfg, const(char)* name, const(char)* value);
int git_config_set_multivar(git_config *cfg, const(char)* name, const(char)* regexp, const(char)* value);
int git_config_delete_entry(git_config *cfg, const(char)* name);
int git_config_delete_multivar(git_config *cfg, const(char)* name, const(char)* regexp);
int git_config_foreach(
	const(git_config)* cfg,
	git_config_foreach_cb callback,
	void *payload);
int git_config_iterator_new(git_config_iterator **out_, const(git_config)* cfg);
int git_config_iterator_glob_new(git_config_iterator **out_, const(git_config)* cfg, const(char)* regexp);
int git_config_foreach_match(
	const(git_config)* cfg,
	const(char)* regexp,
	git_config_foreach_cb callback,
	void *payload);
int git_config_get_mapped(
	int *out_,
	const(git_config)* cfg,
	const(char)* name,
	const(git_cvar_map)* maps,
	size_t map_n);
int git_config_lookup_map_value(
	int *out_,
	const(git_cvar_map)* maps,
	size_t map_n,
	const(char)* value);
int git_config_parse_bool(int *out_, const(char)* value);
int git_config_parse_int32(int32_t *out_, const(char)* value);
int git_config_parse_int64(int64_t *out_, const(char)* value);
int git_config_parse_path(git_buf *out_m, const(char)* value);
int git_config_backend_foreach_match(
	git_config_backend *backend,
	const(char)* regexp,
	git_config_foreach_cb callback,
	void *payload);
int git_config_lock(git_transaction **tx, git_config *cfg);
