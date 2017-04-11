--Localization.enUS.lua

IlarosNaviLocals = {
}

setmetatable(IlarosNaviLocals, {__index=function(t,k) rawset(t, k, k); return k; end})
