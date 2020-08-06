#define HSLUA_HS_FUN_NAME "HsLuaFunction"
#define HSLUA_ERR "HSLUA_ERR"

#include "lua.h"

/*
** Pushes a metatable for Haskell function wrapping userdata to
** the stack.
*/
void hslua_newhsfunmetatable(lua_State *L);

int hslua_call_wrapped_hs_fun(lua_State *L);
