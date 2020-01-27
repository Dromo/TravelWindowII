import "Turbine";
import "Turbine.Debug";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "DhorPlugins.Extensions";
import "DhorPlugins.Utils.BitOps";

RhovanionMapWindow = class(Turbine.UI.Lotro.Window);

function RhovanionMapWindow:Constructor(parent, class, race, shortcuts)
    Turbine.UI.Lotro.Window.Constructor(self);

    --  add a check to see if we load completely
    self.loaded = false;

    -- set size of window
    self.width = 1044;
    self.height = 817;
    self.windowWidth, self.windowHeight = Turbine.UI.Display:GetSize();

    self.mainWindow = parent;
    self.playerClass = class;
    self.playerRace = race;
    self.shortcuts = shortcuts;

    -- table of shortcuts
    self.quickslots = {};

    -- set the default window settings
    self:SetPosition(self.windowWidth / 2 - self.width / 2, self.windowHeight / 2 - self.height / 2);
    self:SetSize(self.width, self.height);
    self:SetBlendMode(Turbine.UI.BlendMode.Undefined);
    self:SetBackColor(Turbine.UI.Color(0.0, 0, 0, 0));
    self:SetText(rhovanionMapTitleString);
    self:SetOpacity(1);

    mapLabel = Turbine.UI.Label();
    mapLabel:SetPosition(10, 40);
    mapLabel:SetSize(1024, 768);

    mapLabel:SetBackground(0x411C2DE4);
    mapLabel:SetParent(self);
    mapLabel:SetVisible(true);

    self.mapLocations = {
        -- Hunter skills
        { -1, -1 }, -- Camp
        { -1, -1 }, -- Bree
        { -1, -1 }, -- Thorin's Hall
        { -1, -1 }, -- Michel Delving
        { -1, -1 }, -- Esteldin
        { -1, -1 }, -- Evendim
        { -1, -1 }, -- Ost Guruth
        { -1, -1 }, -- Rivendell
        { -1, -1 }, -- Suri-Kyla
        { -1, -1 }, -- West Angmar
        { -1, -1 }, -- East Angmar
        { -1, -1 }, -- Echad Dunann
        { 265, 315 }, -- 21st Hall
        { 435, 360 }, -- Mirkwood
        { -1, -1 }, -- Enedwaith Harndirion
        { -1, -1 }, -- Galtrev
        { 387, 419 }, -- Stangard
        { 363, 358 }, -- Caras Galadhon
        { -1, -1 }, -- Misty Mountains
        { 391, 654 }, -- Snowbourn
        { 370, 460 }, -- Forlaw
        { 359, 716 }, -- Aldburg
        { 225, 690 }, -- Helm's Deep
        { -1, -1 }, -- Dol Amroth
        { -1, -1 }, -- Arnach
        { -1, -1 }, -- Minas Tirith
        { -1, -1 }, -- War-stead
        { -1, -1 }, -- After-Battle Minas Tirith
        { -1, -1 }, -- Osgiliath
        { -1, -1 }, -- Henneth Annûn
        { -1, -1 }, -- Camp of the Host
        { -1, -1 }, -- Haerondir
        { 736, 726 }, -- Udûn Foothold
        { 621, 128 }, -- Dale
        { 715, 85 }, -- Jarnfast
        { 555, 70 }, -- Skarhald
        { 451, 133 }, -- Beorningerhus
        { 431, 233 }, -- Hultvis

        -- Muster skills
        { -1, -1 }, -- Ost Guruth
        { -1, -1 }, -- Esteldin
        { -1, -1 }, -- Evendim
        { -1, -1 }, -- Rivendell
        { -1, -1 }, -- Suri-Kyla
        { 265, 315 }, -- 21st Hall
        { 510, 330 }, -- Mirkwood
        { -1, -1 }, -- Enedwaith Harndirion
        { -1, -1 }, -- Galtrev
        { 387, 419 }, -- Stangard
        { 363, 358 }, -- Caras Galadhon
        { -1, -1 }, -- Misty Mountains
        { 391, 654 }, -- Snowbourn
        { 370, 460 }, -- Forlaw
        { 359, 716 }, -- Aldburg
        { 225, 690 }, -- Helm's Deep
        { -1, -1 }, -- Dol Amroth
        { -1, -1 }, -- Arnach
        { -1, -1 }, -- Minas Tirith
        { -1, -1 }, -- War-stead
        { -1, -1 }, -- After-Battle Minas Tirith
        { -1, -1 }, -- Osgiliath
        { -1, -1 }, -- Henneth Annûn
        { -1, -1 }, -- Camp of the Host
        { -1, -1 }, -- Haerondir
        { 736, 726 }, -- Udûn Foothold
        { 621, 128 }, -- Dale
        { 715, 85 }, -- Jarnfast
        { 555, 70 }, -- Skarhald
        { 451, 133 }, -- Beorningerhus
        { 431, 233 }, -- Hultvis

        -- Reputation skills
        { -1, -1 }, -- Thorin's Hall
        { -1, -1 }, -- Bree
        { -1, -1 }, -- Lalia's Market
        { -1, -1 }, -- Michel Delving
        { -1, -1 }, -- Rivendell
        { -1, -1 }, -- Ost Guruth
        { 540, 330 }, -- Mirkwood
        { -1, -1 }, -- Enedwaith Lhanuch
        { -1, -1 }, -- Galtrev
        { 402, 419 }, -- Stangard
        { 411, 654 }, -- Snowbourn
        { 390, 460 }, -- Forlaw
        { 374, 716 }, -- Aldburg
        { 302, 543 }, -- Derndingle
        { 240, 690 }, -- Helm's Deep
        { -1, -1 }, -- Dol Amroth
        { -1, -1 }, -- Arnach
        { -1, -1 }, -- Minas Tirith
        { -1, -1 }, -- War-Stead
        { -1, -1 }, -- After-Battle Minas Tirith
        { -1, -1 }, -- Henneth Annûn
        { -1, -1 }, -- Osgiliath
        { -1, -1 }, -- Camp of the Host
        { -1, -1 }, -- Haerondir
        { 756, 726 }, -- Udûn Foothold
        { -1, -1 }, -- Court of Lothlórien
        { -1, -1 }, -- Hall of the King
        { 650, 85 }, -- Hall Under the Mountain
        { -1, -1 }, -- Bâr Thorenion
        { 641, 128 }, -- Dale
        { 735, 85 }, -- Jarnfast
        { 575, 70 }, -- Skarhald
        { 471, 133 }, -- Beorningerhus
        { 451, 233 }, -- Hultvis
        
        -- Racial skills
        { -1, -1 }, -- Bree
        { -1, -1 }, -- Michel Delving
        { -1, -1 }, -- Thorin's Hall
        { -1, -1 }, -- Rivendell
        { 490, 100 }, -- Grimbeorn's House
        { 378, 358 }, -- Caras Galadhon
    };
    self:AddShortcuts();

    self:SetVisible(true);

    -- have the main window close the options
    self.VisibleChanged = function(sender, args)
        if (self:IsVisible() == false) then
            if (parent ~= nil) then
                parent:CloseEriadorMap();
            end
        end
    end

    self.loaded = true;
end

function RhovanionMapWindow:AddShortcuts()

    local counter = 1;

    -- hunter locations
    for i = 1, travelCount[1], 1 do

        -- add hunter locations if they should be on this map
        if (self.mapLocations[counter][1] > 0 and self.playerClass == Turbine.Gameplay.Class.Hunter and self:IsShortcutEnabled(hunterLocations:KeyAtIndex(i)) == 1) then
            self:AddSingleShortcut(counter, Turbine.UI.Lotro.Shortcut(6.0, hunterLocations:DataAtIndex(i)));
        end

        counter = counter + 1;
    end

    -- warden locations
    for i = 1, travelCount[2], 1 do

        -- add warden locations if they should be on this map
        if (self.mapLocations[counter][1] > 0 and self.playerClass == 194 and self:IsShortcutEnabled(wardenLocations:KeyAtIndex(i)) == 1) then
            self:AddSingleShortcut(counter, Turbine.UI.Lotro.Shortcut(6.0, wardenLocations:DataAtIndex(i)));
        end
        counter = counter + 1;
    end

    -- reputation locations
    for i = 1, travelCount[4], 1 do

        -- add rep locations if they should be on this map
        if (self.mapLocations[counter][1] > 0 and self:IsShortcutEnabled(repLocations:KeyAtIndex(i)) == 1) then
            self:AddSingleShortcut(counter, Turbine.UI.Lotro.Shortcut(6.0, repLocations:DataAtIndex(i)));
        end

        counter = counter + 1;
    end

    -- racial locations
    for i = 1, travelCount[5], 1 do

        if (self.mapLocations[counter][1] > 0 and self:IsShortcutEnabled(racialLocations:KeyAtIndex(i)) == 1) then
            if (i == self.playerRace) then
                self:AddSingleShortcut(counter, Turbine.UI.Lotro.Shortcut(6.0, racialLocations:DataAtIndex(i)));
            end
        end

        counter = counter + 1;
    end
end

function RhovanionMapWindow:AddSingleShortcut(index, shortcut)

    self.quickslots[index] = Turbine.UI.Lotro.Quickslot();

    self.quickslots[index]:SetShortcut(shortcut);

    self.quickslots[index]:SetOpacity(1);
    self.quickslots[index]:SetParent(mapLabel);
    self.quickslots[index]:SetAllowDrop(false);
    self.quickslots[index]:SetMouseVisible(true);
    self.quickslots[index]:SetUseOnRightClick(false);
    self.quickslots[index]:SetAllowDrop(false);

    self.quickslots[index]:SetStretchMode(1);
    self.quickslots[index]:SetSize(22, 22);
    self.quickslots[index]:SetPosition(self.mapLocations[index][1], self.mapLocations[index][2]);
    self.quickslots[index]:SetZOrder(98);
    self.quickslots[index]:SetVisible(true);

    self.quickslots[index].MouseClick = function(sender, args)
        self:SetVisible(false);
    end
end

function RhovanionMapWindow:IsShortcutEnabled(name)

    -- loop through all the shortcuts and add those that are enabled
    for i = 1, table.getn(self.shortcuts), 1 do
        if (self.shortcuts[i]:GetName() == name) then
            if (self.shortcuts[i]:IsEnabled()) then
                return 1;
            end
        end
    end

    return 0;
end