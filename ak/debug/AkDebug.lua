AkDebug = {}
AkDebug.__index = AkDebug
AkDebug.outputPath = ""

dbg = {
    anforderung = true,
    bahnhof = false,
    error = true,
    fs_pruefung = true,
    fs_schaltung = true,
    signal_aenderung = false,
    weiche_aenderung = false,
    ampel = false,
    types = false,
}

function pdbg(level, msg)
    if (level) then print(msg) end
end
