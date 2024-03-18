type Signal<T, U...> = { f: (T, U...) -> (), data: T }
local function call<T, U...>(s: Signal<T, U...>, ...: U...)
    s.f(s.data, ...)
end

local signal: Signal<string, (number, number, boolean)> = --

call(signal, 1, 2, false)
