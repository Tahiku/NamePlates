
local activePlates = {}
local max, strformat = math.max, string.format
local ipairs, strfind = ipairs, string.find

-- Red name text
local RedName = {
    ["Viper"] = true,
    ["Venomous Snake"] = true,
}

-- Name/GUID = scale
local ShrinkPlates = {
    -- Water
    ["Healing Stream Totem IX"] = 0.6,
    ["Mana Spring Totem VIII"] = 0.6,
    ["Fire Resistance Totem VI"] = 0.6,
    -- Earth
    ["Stoneskin Totem X"] = 0.6,
    ["Strength of Earth Totem VIII"] = 0.6,
    ["Earth Elemental Totem"] = 0.6,
    -- Air
    ["Windfury Totem"] = 0.6,
    ["Wrath of Air Totem"] = 0.6,
    ["Nature Resistance Totem VI"] = 0.6,
    ["Sentry Totem"] = 0.5,
    -- Fire
    ["Totem of Wrath IV"] = 0.6,
    ["Flametongue Totem VIII"] = 0.6,
    ["Frost Resistance Totem VI"] = 0.6,
    ["Fire Elemental Totem"] = 0.6,

    -- Misc
    ["Viper"] = 0.5,
    ["Venomous Snake"] = 0.5,
    ["Bloodworm"] = 0.6, -- 28017 testing
    ["Ghoul"] = 0.8,
    ["Gargoyle"] = 0.8,
    ["Army of the Dead Ghoul"] = 0.6, -- testing
    ["Treant"] = 0.7, 
    ["Spirit Wolf"] = 0.7,
    ["Shadowfiend"] = 0.8,
    ["Water Elemental"] = 0.8,
}

-- Invisible
local HideNameplateUnits = {
    ["Vern"] = true,
    ["Underbelly Croc"] = true,
    ["31216"] = true -- Mirror image
}

local ghoulPets = {
    "Stone", "Eye", "Dirt", "Blight", "Bat", "Rat", "Corpse", "Grave", "Carrion",
    "Skull", "Bone", "Crypt", "Rib", "Brain", "Tomb", "Rot", "Gravel", "Plague",
    "Casket", "Limb", "Worm", "Earth", "Spine", "Pebble", "Root", "Marrow", "Hammer"
}

local cIcon = {
    ["ROGUE"] = "Interface\\Icons\\inv_throwingknife_04",
    ["PRIEST"] = "Interface\\Icons\\inv_staff_30",
    ["WARRIOR"] = "Interface\\Icons\\INV_Sword_27",
    ["PALADIN"] = "Interface\\Icons\\INV_hammer_100", -- inv_hammer_01
    ["HUNTER"] = "Interface\\Icons\\inv_weapon_bow_07",
    ["DRUID"] = "Interface\\Icons\\ClassIcon_Druid.blp", -- ability_druid_maul
    ["MAGE"] = "Interface\\Icons\\inv_staff_13",
    ["SHAMAN"] = "Interface\\Icons\\Spell_Nature_BloodLust",
    ["WARLOCK"] = "Interface\\Icons\\spell_nature_drowsy",
    ["DEATHKNIGHT"] = "Interface\\Icons\\Spell_Deathknight_ClassIcon",
}

-- Special casts
local spellColors = {
    ["Polymorph"] = { r = 1, g = 1, b = 1 }, -- white
    ["Cyclone"] = { r = .4, g = .4, b = .4 }, -- dark
    ["Fear"] = { r = .5, g = .2, b = .8 }, -- purple
    ["Howl of Terror"] = { r = .5, g = .2, b = .8 }, -- purple

    ["Hex"] = { r = .97, g = .97, b = .97 },
    ["Attack"] = { r = .97, g = .97, b = .97 }, -- Searing Totem
    ["Steady Shot"] = { r = .97, g = .97, b = .97 },
    ["Shattering Throw"] = { r = .97, g = .97, b = .97 },
    ["War Stomp"] = { r = .97, g = .97, b = .97 },
    ["Hearthstone"] = { r = .97, g = .97, b = .97 },

    -- Poisons
    ["Instant Poison IX"] = { r = .97, g = .97, b = .97 },
    ["Deadly Poison IX"] = { r = .97, g = .97, b = .97 },
    ["Wound Poison VII"] = { r = .97, g = .97, b = .97 },
    ["Crippling Poison"] = { r = .97, g = .97, b = .97 },
    ["Anesthetic Poison II"] = { r = .97, g = .97, b = .97 },
    ["Mind Numbing Poison"] = { r = .97, g = .97, b = .97 }, -- might bug

    -- Misc
    ["Felsteed"] = { r = .97, g = .97, b = .97 },
    ["Dreadsteed"] = { r = .97, g = .97, b = .97 },
    ["Warhorse"] = { r = .97, g = .97, b = .97 }, -- lvl 20
    ["Charger"] = { r = .97, g = .97, b = .97 }, -- lvl 40
    ["Argent Charger"] = { r = .97, g = .97, b = .97 }, -- ToC
    ["Argent Warhorse"] = { r = .97, g = .97, b = .97 }, -- ToC, Flag
    ["Crimson Deathcharger"] = { r = .97, g = .97, b = .97 },
    ["Acherus Deathcharger"] = { r = .97, g = .97, b = .97 },
    ["Ritual of Summoning"] = { r = .97, g = .97, b = .97 },
    ["Soulwell"] = { r = .97, g = .97, b = .97 },
    ["Conjure Mana Biscuit"] = { r = .97, g = .97, b = .97 },
    ["Explode"] = { r = .97, g = .97, b = .97 }, -- 47481, Corpse Explosion
    ["Pin"] = { r = .97, g = .97, b = .97 },
    ["Huddle"] = { r = .97, g = .97, b = .97 },
    ["Explode"] = { r = .97, g = .97, b = .97 }, -- Corpse Explosion
    ["Gargoyle Strike"] = { r = .35, g = .45, b = .55 }, -- testing
    -- ["Seduction"] = { r = .97, g = .97, b = .97 },
    ["Consume Shadows"] = { r = .97, g = .97, b = .97 },
    -- ["XXXX"] = { r = .97, g = .97, b = .97 },
}

-- Ghoul function
local function isGhoul(name)
    if name then
        for _, v in ipairs(ghoulPets) do
            if strfind(name, "^" .. v) then
                return true
            end
        end
    end
    return false
end


-- color spells function
local function getSpellColor(spellName)
    local color = spellName and spellColors[spellName]

    if color then
        return color.r, color.g, color.b
    else
        return 1.0, 0.7, 0.0 -- Orange castbar color
    end
end


-- class icon function
local function PlayerClassIcons(nameplate, unit)
    if not unit or not UnitIsPlayer(unit) then
        if nameplate.classTexture then
            nameplate.classTexture:Hide()
        end
        return
    end

    local _, unitClass = UnitClass(unit)
    local tex = cIcon and unitClass and cIcon[unitClass]

    if not nameplate.classTexture then -- texture didnt exist, apply it
        nameplate.classTexture = nameplate:CreateTexture(nil, "OVERLAY")
        nameplate.classTexture:SetSize(22.4, 22.4)
        nameplate.classTexture:SetTexCoord(.06, .94, .06, .94)
        nameplate.classTexture:SetPoint("RIGHT", nameplate, "RIGHT", 9, -6.2)
        nameplate.classTexture:Hide()
    end

    if tex then -- texture existed already
        nameplate.classTexture:SetTexture(tex)
        nameplate.classTexture:Show()
    else
        nameplate.classTexture:Hide()
    end
end


-- color & renaming function
local function RenameOrColorPlates(nameplate, unit, HealthBar, name)
    local zoo = UnitCreatureFamily

    if name and RedName[name] and nameplate.newName then
        nameplate.newName:SetTextColor(1, 0, 0)
    elseif name and nameplate.newName then
        nameplate.newName:SetTextColor(1, 1, 1)
    end


    if UnitCreatureType(unit) == "Totem" and nameplate.newName and name then
        -- Water
        if name == "Cleansing Totem" then
            nameplate.newName:SetText("Cleansing")
            HealthBar:SetStatusBarColor(0, 1, 0.596)
        elseif name == "Mana Tide Totem" then
            nameplate.newName:SetText("Mana Tide")
            HealthBar:SetStatusBarColor(.1, .75, .65)
        elseif name == "Healing Stream Totem IX" then
            nameplate.newName:SetText("Healing")
        elseif name == "Mana Spring Totem VIII" then
            nameplate.newName:SetText("MP5")
        elseif name == "Fire Resistance Totem VI" then
            nameplate.newName:SetText("Fire Resist")
        -- Earth
        elseif name == "Tremor Totem" then
            nameplate.newName:SetText("Tremor")
            if UnitCanAttack("player", unit) then
                HealthBar:SetStatusBarColor(.65, .35, 1)
            else
                HealthBar:SetStatusBarColor(1, 1, 0)
            end
        elseif name == "Earthbind Totem" then
            nameplate.newName:SetText("Earthbind")
        elseif name == "Stoneclaw Totem" then
            nameplate.newName:SetText("Stoneclaw")
        elseif name == "Stoneskin Totem X" then
            nameplate.newName:SetText("Stoneskin")
        elseif name == "Strength of Earth Totem VIII" then
            nameplate.newName:SetText("Strenght")
        elseif name == "Earth Elemental Totem" then
            nameplate.newName:SetText("Ele")
        -- Air
        elseif name == "Grounding Totem" then
            nameplate.newName:SetText("Grounding")
        elseif name == "Windfury Totem" then
            nameplate.newName:SetText("Windfury")
        elseif name == "Wrath of Air Totem" then
            nameplate.newName:SetText("Haste")
        elseif name == "Nature Resistance Totem VI" then
            nameplate.newName:SetText("Nature")
        elseif name == "Sentry Totem" then
            nameplate.newName:SetText("Sentry")
        -- Fire
        elseif name == "Magma Totem VII" then
            nameplate.newName:SetText("Magma")
        elseif name == "Totem of Wrath IV" then
            nameplate.newName:SetText("Wrath")
        elseif name == "Searing Totem X" then
            nameplate.newName:SetText("Searing")
        elseif name == "Flametongue Totem VIII" then
            nameplate.newName:SetText("Flametongue")
        elseif name == "Frost Resistance Totem VI" then
            nameplate.newName:SetText("Frost Resist")
        elseif name == "Fire Elemental Totem" then
            nameplate.newName:SetText("Ele")
        end

    elseif UnitCreatureType(unit) == "Elemental" and name == "Water Elemental" and nameplate.newName then
        nameplate.newName:SetText("wele")
    elseif zoo(unit) == "Abberation" and name == "Shadowfiend" and nameplate.newName then
        nameplate.newName:SetText("Fiend")
    elseif zoo(unit) == "Spirit Wolf" and name == "Spirit Wolf" and nameplate.newName then
        nameplate.newName:SetText(" ")
    elseif UnitCreatureType(unit) == "Undead" and name == "Ebon Gargoyle" and nameplate.newName then
        nameplate.newName:SetText("Gargoyle")
    elseif UnitCreatureType(unit) == "Undead" and nameplate.newName and isGhoul(name) then
        nameplate.newName:SetText("Ghoul")
    elseif name and RedName[name] and nameplate.newName then
        -- nameplate.newName:SetTextColor(1, 0, 0)

    -- Warlock pets
    elseif zoo(unit) == "Succubus" and nameplate.newName then
        nameplate.newName:SetText("Succubus")
    elseif zoo(unit) == "Felhunter" and nameplate.newName then
        nameplate.newName:SetText("Felhunter")
    elseif zoo(unit) == "Voidwalker" and nameplate.newName then
        nameplate.newName:SetText("Voidwalker")
    elseif zoo(unit) == "Felguard" and nameplate.newName then
        nameplate.newName:SetText("Felguard")
    elseif zoo(unit) == "Imp" and nameplate.newName then
        nameplate.newName:SetText("Imp")
    end
end

-- show or scale plates function
local function PlateShowOrSize(nameplate, unit, name)
    local gd = UnitGUID(unit)
    local guid = gd and tonumber((gd):sub(-10, -7), 16)

    if (name and (HideNameplateUnits[name])) or (guid and HideNameplateUnits[guid]) then
        nameplate:Hide()
    else
        nameplate:Show()
    end

    if nameplate:IsShown() then
        local scale = 1.2 -- default scale, 1.2

        if name and ShrinkPlates[name] then
            scale = ShrinkPlates[name]
        elseif guid and ShrinkPlates[guid] then
            scale = ShrinkPlates[guid]
        end

        nameplate:SetScale(scale)
    end
end

-- 
local function InitNamePlate(plate)
    if plate.UnitFrame then
        return
    end

    local baseHealthBar, baseCastBar = plate:GetChildren()
    local threat, hpborder, cbborder, cbshield, cbicon, overlay, oldname, level, bossicon, raidicon, elite = plate:GetRegions()

    -- UnitFrame container like Classic
    local UnitFrame = CreateFrame("Frame", nil, plate)
    UnitFrame:SetAllPoints(plate)
    UnitFrame:EnableMouse(false)
    plate.UnitFrame = UnitFrame

    -- Healthbar
    local healthBar = baseHealthBar
    healthBar:SetParent(UnitFrame)
    healthBar:SetFrameLevel(UnitFrame:GetFrameLevel() + 1)
    UnitFrame.healthBar = healthBar

    -- CastBar, part1
    UnitFrame.castBar = baseCastBar
    cbborder:SetTexture("Interface\\AddOns\\NamePlates\\textures\\nameplate-border-castbar")
    cbshield:SetTexture("Interface\\AddOns\\NamePlates\\textures\\nameplate-castbar-shield")

    UnitFrame.castBarBorder = cbborder
    UnitFrame.cbicon = cbicon
    UnitFrame.cbshield = cbshield
    cbicon:SetSize(19, 19)

    -- Border
    local origBorder = hpborder
    origBorder:Hide()
    origBorder:SetTexture(.3, .3, .3)

    local border = CreateFrame("Frame", nil, healthBar)
    border:SetSize(128, 16)
    border:SetPoint("LEFT", healthBar, "LEFT", -4, 0)
    border:SetFrameLevel(healthBar:GetFrameLevel() + 1)

    local borderTex = border:CreateTexture(nil, "ARTWORK")
    borderTex:SetTexture("Interface\\AddOns\\NamePlates\\textures\\Nameplate-Border")
    borderTex:SetTexCoord(0, 1, .5, 1)
    borderTex:SetAllPoints()
    UnitFrame.border = border

    -- re-parent castbar icon
    cbicon:SetParent(border)

    -- Selection Highlight
    local origOverlay = overlay
    origOverlay:SetTexture(1, 1, 1, 0) -- change 0 to unhide it, because this is alpha
    UnitFrame.origOverlay = origOverlay

    -- Name
    local origName = oldname
    local name = UnitFrame:CreateFontString(nil, "ARTWORK")
        name:SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", 16, "OUTLINE") -- adjust later
        name:SetWidth(150)
        name:SetHeight(9)
    name:SetPoint("BOTTOM", border, "TOP", -7, 3)
    name:SetJustifyH("CENTER")
    name:SetTextColor(1, 1, 1)
    name:SetText(origName:GetText())
    origName:Hide()
    UnitFrame.newName = name
    UnitFrame.origName = origName

    -- Level
    level:SetAlpha(0)
    UnitFrame.origLevel = level

    -- Hide elite stuff
    elite:SetAlpha(0)
    elite:Hide()

    -- CastBar, part2
    local CastBar = plate.UnitFrame.castBar
    if not CastBar then
        return
    end

    -- spell name text
    if not plate.castText then
        plate.castText = plate:CreateFontString(nil, "ARTWORK", "SystemFont_Outline") -- GameFontHighlight -- GameFontWhite -- SystemFont_Shadow_Small
        plate.castText:SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", 16, "OUTLINE")
        plate.castText:SetSize(120, 16) -- maybe lesser healing wave doesnt go out of frame?
        plate.castText:SetPoint("CENTER", CastBar, "CENTER", 0, 0)
    end

    -- timer text
    if not plate.timer then
        plate.timer = plate:CreateFontString(nil, "ARTWORK", "SystemFont_Outline")
        plate.timer:SetFont("Interface\\AddOns\\NamePlates\\Prototype.ttf", 16, "OUTLINE")
        plate.timer:SetSize(150, 16)
        plate.timer:SetPoint("RIGHT", CastBar, "RIGHT", 92, 0)
    end

    -- Spark
    if not plate.barSpark then
        plate.barSpark = plate:CreateTexture(nil, "OVERLAY")
        plate.barSpark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
        plate.barSpark:SetSize(32, 32)
        -- nameplate.barSpark:SetVertexColor(0, 0, 1)
        plate.barSpark:SetPoint("CENTER", CastBar, 0, 0)
        plate.barSpark:SetBlendMode("ADD")
    end
end


-- Hook function
local function TimerHook(self, elapsed, value, maxValue, casting)
    if not self.timer then
        return
    end
    self.update = (self.update or 0) - elapsed
    if self.update <= 0 then
        local remainingTime = 0
        if casting then
            remainingTime = max(maxValue - value, 0)
        elseif not casting then
            remainingTime = max(value, 0)
        end
        if remainingTime <= 0 then
            self.timer:SetAlpha(0)
        else
            self.timer:SetText(strformat("%.1f", remainingTime))
            self.timer:SetAlpha(1)
        end

        self.update = 0.1
    end
end

-- re position castbar
local function CastBarPosition(frame, point, relativeTo, relativePoint, xOfs, yOfs)
    local p, relTo, relPoint, x, y = frame:GetPoint()

    if p ~= point or relTo ~= relativeTo or relPoint ~= relativePoint or x ~= xOfs or y ~= yOfs then
        frame:ClearAllPoints()
        frame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
end

-- nameplate shown function
local function NamePlate_OnShow(plate, unit)
    local uf = plate.UnitFrame
    if not uf or not unit then
        return
    end

    -- Set Unit
    uf.unit = unit

    -- Set Name
    if uf.newName and uf.origName then
        uf.newName:SetText(uf.origName:GetText())

        -- Arena numbers
        local _, type = IsInInstance()
        if type == "arena" then
            for i = 1, 5 do
                if UnitIsUnit(unit, "arena" .. i) then
                    uf.newName:SetText(i)
                    break
                end
            end
        end

        -- Dead Text
        if UnitIsGhost(unit) then
            uf.newName:SetText("Dead & Useless")
        end
    end

    -- Hide Level text
    if uf.origLevel then
        uf.origLevel:SetAlpha(0)
        uf.origLevel:Hide()
    end

    -- Needed to fix healthbar
    uf.healthBar:ClearAllPoints()
    uf.healthBar:SetPoint("BOTTOM", uf, "BOTTOM", 0, 4)
    uf.healthBar:SetSize(103, 10)

    -- Annoying overlay ( enable when changing alpha from 0 )
    --uf.origOverlay:SetAllPoints(uf.healthBar)

    local name = UnitName(unit)

    -- Calls Custom plate names & colors
    RenameOrColorPlates(uf, unit, uf.healthBar, name)

    -- Calls Hide or re-scale plates
    PlateShowOrSize(uf, unit, name)
end


local f = CreateFrame("Frame")
f:RegisterEvent("NAME_PLATE_UNIT_ADDED")
f:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_ENTERING_WORLD" then
        wipe(activePlates)
        return
    end

    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate then
        return
    end

    if event == "NAME_PLATE_UNIT_ADDED" then
        activePlates[plate] = true
        InitNamePlate(plate)
        NamePlate_OnShow(plate, unit)
        PlayerClassIcons(plate, unit)
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        activePlates[plate] = nil
    end
end)

f:SetScript("OnUpdate", function(self, elapsed)
    for nameplate in pairs(activePlates) do
        if not nameplate:IsShown() then
            return
        end

        nameplate:SetAlpha(1)

        local uf = nameplate.UnitFrame
        if not uf then return end

        local cb = uf.castBar
        if not cb then return end

        local value = cb:GetValue()
        local _, maxValue = cb:GetMinMaxValues()

        if cb:IsShown() then
            local name, _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(uf.unit)
            local casting = true

            if not name then
                name, _, _, _, _, _, _, _, notInterruptible = UnitChannelInfo(uf.unit)
                casting = false
            end

            if name then
                -- RIP
                CastBarPosition(uf.castBar, "BOTTOMRIGHT", uf.healthBar, "BOTTOMRIGHT", 26, -16)
                CastBarPosition(uf.castBarBorder, "CENTER", nameplate, "CENTER", 35, -15.581398151124)
                CastBarPosition(uf.cbicon, "CENTER", uf.castBarBorder, "BOTTOMLEFT", -7, 8)
                CastBarPosition(uf.cbshield, "CENTER", uf, "CENTER", 13, -26.581398151124)

                -- Castbar color
                local r, g, b = getSpellColor(name, notInterruptible)
                cb:SetStatusBarColor(r, g, b)

                if nameplate.castText then
                    if not nameplate.castText:IsShown() then
                        nameplate.castText:Show()
                    end
                    nameplate.castText:SetText(name)
                end

                -- Calls Timer update
                TimerHook(nameplate, elapsed, value, maxValue, casting)

                -- Spark
                if casting and nameplate.barSpark and value and maxValue then
                    value = value + elapsed
                    if value >= maxValue then
                        nameplate.barSpark:Hide()
                    else
                        local sparkPosition = (value / maxValue) * cb:GetWidth()
                        nameplate.barSpark:SetPoint("CENTER", cb, "LEFT", sparkPosition, -1)
                        if not nameplate.barSpark:IsShown() then
                            nameplate.barSpark:Show()
                        end
                    end
                end
            else
                if nameplate.castText:IsShown() then
                    nameplate.castText:Hide()
                end
                if nameplate.timer and nameplate.timer:GetAlpha() > 0 then
                    nameplate.timer:SetAlpha(0)
                end
                nameplate.castText:SetText("")
            end
        else
            cb:SetStatusBarColor(1.0, 0.7, 0.0)
            if nameplate.castText:IsShown() then
                nameplate.castText:Hide()
            end
            nameplate.castText:SetText("")
            if nameplate.barSpark and nameplate.barSpark:IsShown() then
                nameplate.barSpark:Hide()
            end
            if nameplate.timer and nameplate.timer:GetAlpha() > 0 then
                nameplate.timer:SetAlpha(0)
            end
        end
    end
end)