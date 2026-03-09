---@meta

---@class SpecAssertAre
---@field same fun(expected: any, actual: any, message?: string):nil
---@field equals fun(expected: any, actual: any, message?: string):nil

---@class SpecAssert
---@field are SpecAssertAre
---@field same fun(expected: any, actual: any, message?: string):nil
---@field equals fun(expected: any, actual: any, message?: string):nil
---@field is_true fun(value: boolean, message?: string):nil
---@field is_false fun(value: boolean, message?: string):nil
---@field is_nil fun(value: any, message?: string):nil
---@field is_not_nil fun(value: any, message?: string):nil
---@field is_truthy fun(value: any, message?: string):nil
---@field is_falsy fun(value: any, message?: string):nil
---@overload fun(value: any, message?: string): any
assert = {}
