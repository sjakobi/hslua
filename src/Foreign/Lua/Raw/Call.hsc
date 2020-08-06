{-# LANGUAGE CPP #-}
{-|
Module      : Foreign.Lua.Raw.Call
Copyright   : © 2007–2012 Gracjan Polak,
                2012–2016 Ömer Sinan Ağacan,
                2017-2020 Albert Krewinkel
License     : MIT
Maintainer  : Albert Krewinkel <tarleb+hslua@zeitkraut.de>
Stability   : beta
Portability : non-portable (depends on GHC)

Raw bindings to function call helpers.
-}
module Foreign.Lua.Raw.Call
  ( PreCFunction
  , hslua_call_hs_ptr
  , hslua_call_wrapped_hs_fun_ptr
  , hslua_newhaskellfunction
  ) where

import Foreign.C (CInt (CInt))
import Foreign.Ptr (Ptr, castPtr, nullPtr)
import Foreign.StablePtr (StablePtr, deRefStablePtr)
import Foreign.Storable (peek)
import Foreign.Lua.Raw.Types
  ( CFunction
  , NumResults (NumResults)
  , State (State)
  )

-- | Type of raw Haskell functions that can be made into
-- 'CFunction's.
type PreCFunction = State -> IO NumResults

-- | Convert callable userdata at top of stack into a CFunction,
-- translating errors to Lua errors. Use with @'pushcclosure'@.
foreign import ccall safe "error-conversion.h &hslua_call_hs"
  hslua_call_hs_ptr :: CFunction

-- | Retrieve the pointer to a Haskell function from the wrapping
-- userdata object.
foreign import ccall "error-conversion.h hslua_hs_fun_ptr"
  hslua_hs_fun_ptr :: State -> IO (Ptr ())

foreign import ccall "hslua_newhaskellfunction"
  hslua_newhaskellfunction :: State -> StablePtr a -> IO ()

-- | Call the Haskell function stored in the userdata. This
-- function is exported as a C function and then re-imported in
-- order to get a C function pointer.
hslua_call_wrapped_hs_fun :: State -> IO NumResults
hslua_call_wrapped_hs_fun l = do
  udPtr <- hslua_hs_fun_ptr l
  if udPtr == nullPtr
    then error "Cannot call function; corrupted Lua object!"
    else do
      fn <- peek (castPtr udPtr) >>= deRefStablePtr
      fn l

foreign export ccall hslua_call_wrapped_hs_fun :: PreCFunction
foreign import ccall safe "&hslua_call_wrapped_hs_fun"
  hslua_call_wrapped_hs_fun_ptr :: CFunction
