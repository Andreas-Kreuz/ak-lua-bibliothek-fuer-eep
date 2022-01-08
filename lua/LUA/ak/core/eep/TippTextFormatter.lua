if AkDebugLoad then print("[#Start] Loading ak.core.eep.TippTextFormatter ...") end

local TippTextFormatter = {
    -- <br> neue Zeile
    -- <b> & </b> Fettschrift an/aus
    -- <i> & </i> Kursivschrift an/aus
    -- <j> Blocksatz aus (= linksbündig)
    -- <c> zentriert
    -- <r> rechtsbündig
    -- <fgrgb=0,0,0> Schriftfarbe in 8 Bit RGB Werten
    -- <bgrgb=0,0,0> Hintergrundfarbe in 8 Bit RGB Werten (diese Hintergrundfarbe betrifft nur die Schrift)
    bold = function(text) return "<b>" .. text .. "</b>" end,
    grey = function(text) return "<bgrgb=201,201,201><fgrgb=0,0,0>" .. text .. "<bgrgb=255,255,255><fgrgb=0,0,0>" end,
    green = function(text)
        return "<bgrgb=0,128,0><fgrgb=255,255,255>" .. text .. "<bgrgb=255,255,255><fgrgb=0,0,0>"
    end,
    bgGreen = function(text) return "<bgrgb=0,192,0>" .. text .. "<bgrgb=255,255,255>" end,
    bgBlue = function(text) return "<bgrgb=128,128,255>" .. text .. "<bgrgb=255,255,255>" end,
    bgYellow = function(text) return "<bgrgb=224,224,0>" .. text .. "<bgrgb=255,255,255>" end,
    bgGray = function(text) return "<bgrgb=196,196,196>" .. text .. "<bgrgb=255,255,255>" end,
    bgRed = function(text) return "<bgrgb=255,96,96>" .. text .. "<bgrgb=255,255,255>" end,
    lightGray = function(text)
        return "<bgrgb=230,230,230><fgrgb=66,66,66>" .. text .. "<bgrgb=255,255,255><fgrgb=0,0,0>"
    end,
    italic = function(text) return "<i>" .. text .. "</i>" end,
    red = function(text) return "<bgrgb=155,0,0><fgrgb=255,255,255>" .. text .. "<bgrgb=255,255,255><fgrgb=0,0,0>" end,
    appendUpTo1023 = function(text, appendix)
        if text:len() + appendix:len() <= 1024 then
            return text .. appendix
        else
            return text
        end
    end
}

return TippTextFormatter
