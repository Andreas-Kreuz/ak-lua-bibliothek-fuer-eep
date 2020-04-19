print("Lade ak.eep.DefaultPublishers ...")
local AkStatistik = require("ak.io.AkStatistik")
local DefaultPublishers = {}

function DefaultPublishers.addDefaultPublishers()
    AkStatistik.addPublisher(require("ak.data.DataSlotsPublisher"))
    AkStatistik.addPublisher(require("ak.data.SignalPublisher"))
    AkStatistik.addPublisher(require("ak.data.SwitchPublisher"))
    AkStatistik.addPublisher(require("ak.data.StructurePublisher"))
    AkStatistik.addPublisher(require("ak.data.TimePublisher"))
    AkStatistik.addPublisher(require("ak.data.TrainsAndTracksPublisher"))
    AkStatistik.addPublisher(require("ak.data.VersionPublisher"))
end

return DefaultPublishers
