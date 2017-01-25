module deimos.git2.refspec;

import deimos.git2.buffer;
import deimos.git2.common;
import deimos.git2.net;
import deimos.git2.types;

extern (C):

const(char)*  git_refspec_src(const(git_refspec)* refspec);
const(char)*  git_refspec_dst(const(git_refspec)* refspec);
const(char)*  git_refspec_string(const(git_refspec)* refspec);
int git_refspec_force(const(git_refspec)* refspec);
git_direction git_refspec_direction(const(git_refspec)* spec);
int git_refspec_src_matches(const(git_refspec)* refspec, const(char)* refname);
int git_refspec_dst_matches(const(git_refspec)* refspec, const(char)* refname);
int git_refspec_transform(git_buf *out_, const(git_refspec)* spec, const(char)* name);
int git_refspec_rtransform(git_buf *out_, const(git_refspec)* spec, const(char)* name);
