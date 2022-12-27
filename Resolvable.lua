Resolvable = Resolvable or {}
local addOnName, AddOn = ...
local _ = {}

--- @class Resolvable.Resolvable
Resolvable.Resolvable = {}

function Resolvable.Resolvable:new()
  --- @class Resolvable.Resolvable
  local resolvable = {
    _afterResolve = Hook.Hook:new(),
    _valuesResolvedWith = nil
  }
  resolvable._afterResolve.runCallbacks = Function.once(resolvable._afterResolve.runCallbacks)
  setmetatable(resolvable, { __index = Resolvable.Resolvable })
  local resolvableInternal = _.ResolvableInternal:new(resolvable)
  return resolvable, resolvableInternal
end

function Resolvable.Resolvable:afterResolve(callback)
  local resolvable, resolvableInternal = Resolvable.Resolvable:new()
  if self._valuesResolvedWith then
    local _self = self
    RunNextFrame(function()
      resolvableInternal:resolve(callback(unpack(_self._valuesResolvedWith)))
    end)
  else
    self._afterResolve:registerCallback(function(...)
      resolvableInternal:resolve(callback(...))
    end)
  end
  return resolvable
end

Resolvable.Resolvable.after = Resolvable.Resolvable.afterResolve

function Resolvable.await(value)
  if type(value) == 'table' and value.afterResolve then
    local thread = coroutine.running()
    value:afterResolve(function(...)
      Coroutine.resumeWithShowingError(thread, ...)
    end)
    return coroutine.yield()
  else
    return value
  end
end

function Resolvable.all(resolvables)
  local resolvable, resolvableInternal = Resolvable.Resolvable:new()
  local result = {}
  local numberOfOpenResolvables = Array.length(resolvables)
  Array.forEach(resolvables, function(resolvable, index)
    resolvable:after(function(...)
      result[index] = { ... }
      numberOfOpenResolvables = numberOfOpenResolvables - 1
      if numberOfOpenResolvables == 0 then
        resolvableInternal:resolve(result)
      end
    end)
  end)
  return resolvable
end

await = Resolvable.await

_.ResolvableInternal = {}

function _.ResolvableInternal:new(resolvable)
  local resolvableInternal = {
    _resolvable = resolvable
  }
  setmetatable(resolvableInternal, { __index = _.ResolvableInternal })
  resolvableInternal.resolve = Function.once(resolvableInternal.resolve)
  return resolvableInternal
end

-- TODO: Rename "resolve" to "resolveWith".
function _.ResolvableInternal:resolve(...)
  self._resolvable._valuesResolvedWith = { ... }
  self._resolvable._afterResolve:runCallbacks(...)
end
