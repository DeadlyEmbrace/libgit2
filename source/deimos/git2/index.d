module deimos.git2.index;

import deimos.git2.common;
import deimos.git2.indexer;
import deimos.git2.oid;
import deimos.git2.strarray;
import deimos.git2.util;
import deimos.git2.types;

extern (C):

struct git_index_time {
	int32_t seconds;
	uint32_t nanoseconds;
}

struct git_index_entry {
	git_index_time ctime;
	git_index_time mtime;

	uint32_t dev;
	uint32_t ino;
	uint32_t mode;
	uint32_t uid;
	uint32_t gid;
	uint32_t file_size;

	git_oid oid;

	uint16_t flags;
	uint16_t flags_extended;

	const(char)* path;
}

enum GIT_IDXENTRY_NAMEMASK   = (0x0fff);
enum GIT_IDXENTRY_STAGEMASK  = (0x3000);
enum GIT_IDXENTRY_STAGESHIFT = 12;

enum git_indexentry_flag_t
{
	GIT_IDXENTRY_EXTENDED   = (0x4000),
	GIT_IDXENTRY_VALID      = (0x8000),
}

auto GIT_IDXENTRY_STAGE(T)(T E) { return (((E).flags & GIT_IDXENTRY_STAGEMASK) >> GIT_IDXENTRY_STAGESHIFT); }
auto GIT_IDXENTRY_STAGE_SET(T, I)(T E, I S) { 
	do 
	{
		return (E).flags & ~GIT_IDXENTRY_STAGEMASK | ((S) & 0x03) << GIT_IDXENTRY_STAGESHIFT; 
	}
	while(0);
}

enum git_idxentry_extended_flag_t
{
	GIT_IDXENTRY_INTENT_TO_ADD     = (1 << 13),
	GIT_IDXENTRY_SKIP_WORKTREE     = (1 << 14),
	GIT_IDXENTRY_EXTENDED2         = (1 << 15),
	GIT_IDXENTRY_EXTENDED_FLAGS = (GIT_IDXENTRY_INTENT_TO_ADD | GIT_IDXENTRY_SKIP_WORKTREE),

	GIT_IDXENTRY_UPDATE            = (1 << 0),
	GIT_IDXENTRY_REMOVE            = (1 << 1),
	GIT_IDXENTRY_UPTODATE          = (1 << 2),
	GIT_IDXENTRY_ADDED             = (1 << 3),

	GIT_IDXENTRY_HASHED            = (1 << 4),
	GIT_IDXENTRY_UNHASHED          = (1 << 5),
	GIT_IDXENTRY_WT_REMOVE         = (1 << 6),
	GIT_IDXENTRY_CONFLICTED        = (1 << 7),

	GIT_IDXENTRY_UNPACKED          = (1 << 8),
	GIT_IDXENTRY_NEW_SKIP_WORKTREE = (1 << 9),
}

enum git_indexcap_t {
	GIT_INDEXCAP_IGNORE_CASE = 1,
	GIT_INDEXCAP_NO_FILEMODE = 2,
	GIT_INDEXCAP_NO_SYMLINKS = 4,
	GIT_INDEXCAP_FROM_OWNER  = -1,
}
mixin _ExportEnumMembers!git_indexcap_t;

alias git_index_matched_path_cb = int function(
	const(char)* path, const(char)* matched_pathspec, void *payload);

enum git_index_add_option_t {
	GIT_INDEX_ADD_DEFAULT = 0,
	GIT_INDEX_ADD_FORCE = (1u << 0),
	GIT_INDEX_ADD_DISABLE_PATHSPEC_MATCH = (1u << 1),
	GIT_INDEX_ADD_CHECK_PATHSPEC = (1u << 2),
}
mixin _ExportEnumMembers!git_index_add_option_t;

enum git_index_stage_t
{
	GIT_INDEX_STAGE_ANY = -1,
	GIT_INDEX_STAGE_NORMAL = 0,
	GIT_INDEX_STAGE_ANCESTOR = 1,
	GIT_INDEX_STAGE_OURS = 2,
	GIT_INDEX_STAGE_THEIRS = 3,
}

int git_index_open(git_index **out_, const(char)* index_path);
int git_index_new(git_index **out_);
void git_index_free(git_index *index);
git_repository * git_index_owner(const(git_index)* index);
uint git_index_caps(const(git_index)* index);
int git_index_set_caps(git_index *index, uint caps);

uint git_index_version(git_index *index);
int git_index_set_version(git_index *index, uint version_);

int git_index_read(git_index *index, int force);
int git_index_write(git_index *index);
const(char)* git_index_path(git_index *index);

const(git_oid)* git_index_checksum(git_index *index);

int git_index_read_tree(git_index *index, const(git_tree)* tree);
int git_index_write_tree(git_oid *out_, git_index *index);
int git_index_write_tree_to(git_oid *out_, git_index *index, git_repository *repo);
size_t git_index_entrycount(const(git_index)* index);
void git_index_clear(git_index *index);
const(git_index_entry)*  git_index_get_byindex(
	git_index *index, size_t n);
const(git_index_entry)*  git_index_get_bypath(
	git_index *index, const(char)* path, int stage);
int git_index_remove(git_index *index, const(char)* path, int stage);
int git_index_remove_directory(
	git_index *index, const(char)* dir, int stage);
int git_index_add(git_index *index, const(git_index_entry)* source_entry);
int git_index_entry_stage(const(git_index_entry)* entry);
int git_index_entry_is_conflict(const(git_index_entry)* entry);
int git_index_add_bypath(git_index *index, const(char)* path);
int git_index_add_frombuffer(git_index *index, const(git_index_entry)* entry, const(void)* buffer, size_t len);
int git_index_remove_bypath(git_index *index, const(char)* path);
int git_index_add_all(
	git_index *index,
	const(git_strarray)* pathspec,
	uint flags,
	git_index_matched_path_cb callback,
	void *payload);
int git_index_remove_all(
	git_index *index,
	const(git_strarray)* pathspec,
	git_index_matched_path_cb callback,
	void *payload);
int git_index_update_all(
	git_index *index,
	const(git_strarray)* pathspec,
	git_index_matched_path_cb callback,
	void *payload);
int git_index_find(size_t *at_pos, git_index *index, const(char)* path);
int git_index_find_prefix(size_t *at_post, git_index *index, const(char)* prefix);
int git_index_conflict_add(
	git_index *index,
	const(git_index_entry)* ancestor_entry,
	const(git_index_entry)* our_entry,
	const(git_index_entry)* their_entry);
int git_index_conflict_get(
	const(git_index_entry)** ancestor_out,
	const(git_index_entry)** our_out,
	const(git_index_entry)** their_out,
	git_index *index,
	const(char)* path);
int git_index_conflict_remove(git_index *index, const(char)* path);
void git_index_conflict_cleanup(git_index *index);
int git_index_has_conflicts(const(git_index)* index);
int git_index_conflict_iterator_new(
	git_index_conflict_iterator **iterator_out,
	git_index *index);
int git_index_conflict_next(
	const(git_index_entry)** ancestor_out,
	const(git_index_entry)** our_out,
	const(git_index_entry)** their_out,
	git_index_conflict_iterator *iterator);
void git_index_conflict_iterator_free(
	git_index_conflict_iterator *iterator);