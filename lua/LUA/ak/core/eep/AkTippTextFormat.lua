print("Lade ak.core.eep.AkTippTextFormat ...")

local AkTippTextFormat = {
    -- <br> neue Zeile
    -- <b> & </b> Fettschrift an/aus
    -- <i> & </i> Kursivschrift an/aus
    -- <j> Blocksatz aus (= linksbündig)
    -- <c> zentriert
    -- <r> rechtsbündig
    -- <fgrgb=0,0,0> Schriftfarbe in 8 Bit RGB Werten
    -- <bgrgb=0,0,0> Hintergrundfarbe in 8 Bit RGB Werten (diese Hintergrundfarbe betrifft nur die Schrift)
    fett = function(text)
        return "<b>" .. text .. "</b>"
    end,
    grau = function(text)
        return "<bgrgb=201,201,201><fgrgb=0,0,0>" .. text .. "<bgrgb=255,255,255><fgrgb=0,0,0>"
    end,
    gruen = function(text)
        return "<bgrgb=0,128,0><fgrgb=255,255,255>" .. text .. "<bgrgb=255,255,255><fgrgb=0,0,0>"
    end,
    hintergrund_gruen = function(text)
        return "<bgrgb=0,192,0>" .. text .. "<bgrgb=255,255,255>"
    end,
    hintergrund_blau = function(text)
        return "<bgrgb=128,128,255>" .. text .. "<bgrgb=255,255,255>"
    end,
    hintergrund_gelb = function(text)
        return "<bgrgb=224,224,0>" .. text .. "<bgrgb=255,255,255>"
    end,
    hintergrund_grau = function(text)
        return "<bgrgb=196,196,196>" .. text .. "<bgrgb=255,255,255>"
    end,
    hintergrund_rot = function(text)
        return "<bgrgb=255,96,96>" .. text .. "<bgrgb=255,255,255>"
    end,
    hellgrau = function(text)
        return "<bgrgb=230,230,230><fgrgb=66,66,66>" .. text .. "<bgrgb=255,255,255><fgrgb=0,0,0>"
    end,
    kursiv = function(text)
        return "<i>" .. text .. "</i>"
    end,
    rot = function(text)
        return "<bgrgb=155,0,0><fgrgb=255,255,255>" .. text .. "<bgrgb=255,255,255><fgrgb=0,0,0>"
    end
}

return AkTippTextFormat
