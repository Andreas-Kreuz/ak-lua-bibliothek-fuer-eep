---@meta

---@class TrainDto
---@field id string
---@field route string
---@field rollingStockCount number
---@field length number
---@field line string|nil
---@field destination string|nil
---@field direction string|nil
---@field trackType string|nil
---@field movesForward boolean
---@field speed number
---@field occupiedTacks table

---@class TrainDtoFactory
---@field createTrainDto fun(train: Train|table):string,string,string|number,TrainDto
---@field createTrainDtoList fun(trains: table):string,string,table
---@field createTrainReferenceDto fun(trainId: string):string,string,string|number,TrainDto
