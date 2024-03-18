export type pair<pair_type> = {
    [pair_type] :: unknown = {};
    [pair_type] :: unknown = {};
}

local function return_pair(types)
    if typeof(types) == 'table' then
        if #types > 2 then return end
        local type_tbl: pair<types[#types - 1]> = {First = 'Test', Second = 'Test2'}
    else
        return 
    end
end
