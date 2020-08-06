#include <HsFFI.h>
#include "error-conversion.h"

/* ***************************************************************
 * Userdata for Haskell values
 * ***************************************************************/

/*
** Free stable Haskell pointer in userdata.
**
** The userdata whose contents is garbage collected must be on
** stack index 1 (i.e., the first argument).
*/
int hslua_userdata_gc(lua_State *L);

/* Create new metatable for a Haskell-value userdata object. */
int hslua_newudmetatable(lua_State *L, const char *tname);

/* Create new Haskell-value userdata object. */
int hslua_newuserdata(lua_State *L,
                      HsStablePtr data,
                      const char *tname);
