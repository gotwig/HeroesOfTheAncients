HeroSelection = HeroSelection or class({})

function HeroSelection:constructor(players, availableHeroes, teamColors, chat)
    self.SelectionTimer = 0
	--self.SelectionTimerTime = 55
    self.SelectionTimerTime = 55
    self.PreGameTimer = 0
    self.PreGameTimerTime = 3
    self.Players = players
    self.TeamColors = teamColors
    self.AvailableHeroes = availableHeroes
    self.HardHeroesLocked = true
    self.PreviousRandomed = {}
	
	self.Chat = chat
	
end

function HeroSelection:UpdateSelectedHeroes()
    local selected = {}

    for _, player in pairs(self.Players) do
        if player:IsConnected() then
            selected[player.id] = player.selectedHero or "null"
        end
    end

    CustomNetTables:SetTableValue("main", "selectedHeroes", selected)
end

function HeroSelection:CanBeSelected(hero)
    local entry = self.AvailableHeroes[hero]

    if entry and entry.disabled then
        return false
    end

    for _, player in pairs(self.Players) do
        if player.selectedHero == hero then
            return false
        end
    end

    return true
end

function HeroSelection:OnRandom(args)
    local player = self.Players[args.PlayerID]

    if player:IsConnected() and not player.selectionLocked then
        self:AssignRandomHero(player)
        self:UpdateSelectionState()
        self:UpdateSelectedHeroes()
    end
end



function HeroSelection:OnConfirm(args)
	

    local table = {}
    local player = self.Players[args.PlayerID]
    local hero = args.hero
	
	player.selectionLocked = true;
    self:UpdateSelectionState()	
	self:UpdateSelectedHeroes()
	self:Update()
	
    if not player:IsConnected() then
        return
    end
	
    if self.AvailableHeroes[hero] == nil and hero ~= "null" then
        return
    end

    if player.selectionLocked then
        return
    end

	--EmitAnnouncerSound("announcer_announcer_choose_hero")
	
end


function HeroSelection:OnClick(args)
    local table = {}
    local player = self.Players[args.PlayerID]
    local hero = args.hero
	
	print("CLICK")
	
    if not player:IsConnected() then
        return
    end

    if self.AvailableHeroes[hero] == nil and hero ~= "null" then
        return
    end

    if player.selectionLocked then
        return
    end

    if not self:CanBeSelected(hero) then
        return
    end	
	
	player.selectedHero = hero
	self:UpdateSelectionState()
end

function HeroSelection:UpdateSelectionState()
    local allLocked = true
    for _, playerClass in pairs(self.Players) do
        if playerClass:IsConnected() and not playerClass.selectionLocked then
            allLocked = false
        end
    end

    if allLocked and self.SelectionTimer > 3 then
        self.SelectionTimer = 3
        self:SendTimeToPlayers()
    end
	
	if (allLocked) then
		--GameMode:OnHeroSelectionEnd()
	end
end

function HeroSelection:AssignRandomHero(player)
    local table = {}
    local index = 0

    for i, _ in pairs(self.AvailableHeroes) do
        if self:CanBeSelected(i) and self.PreviousRandomed[player.id] ~= i then
            table[index] = i
            index = index + 1
        end
    end

    player.selectionLocked = true
    player.selectedHero = table[RandomInt(0, index - 1)]

    self.PreviousRandomed[player.id] = player.selectedHero
end

function HeroSelection:AssignRandomHeroes()
    for i, player in pairs(self.Players) do
        if player:IsConnected() then
            if not player.selectionLocked then
                self:AssignRandomHero(player)
            end
        end
    end

    self:UpdateSelectedHeroes()
end

function HeroSelection:SendTimeToPlayers()
    CustomGameEventManager:Send_ServerToAllClients("timer_tick", { time = self.SelectionTimer })
end

function HeroSelection:Start()
    print("Starting hero selection")

    self.Callback = callback
    self.SelectionTimer = self.SelectionTimerTime
    self.PreGameTimer = self.PreGameTimerTime
    self:SendTimeToPlayers()

    for _, player in pairs(self.Players) do
        player.selectedHero = nil
        player.selectionLocked = false
    end

    self:UpdateSelectedHeroes()

    EmitAnnouncerSound("announcer_announcer_choose_hero")

	self.ConfirmListener = CustomGameEventManager:RegisterListener("selection_hero_confirm", function(id, ...) Dynamic_Wrap(self, "OnConfirm")(self, ...) end)
    self.ClickListener = CustomGameEventManager:RegisterListener("selection_hero_click", function(id, ...) Dynamic_Wrap(self, "OnClick")(self, ...) end)
    self.RandomListener = CustomGameEventManager:RegisterListener("selection_random", function(id, ...) Dynamic_Wrap(self, "OnRandom")(self, ...) end)
end

function HeroSelection:Update()
    self.SelectionTimer = math.max(self.SelectionTimer - 1, -1)
    self:SendTimeToPlayers()

    if self.SelectionTimer == 0 then
        self:AssignRandomHeroes()
    end

    if self.SelectionTimer == -1 then
        if self.PreGameTimer == self.PreGameTimerTime then
            --EmitAnnouncerSound("announcer_announcer_battle_prepare_01")
        end

        self.PreGameTimer = self.PreGameTimer - 1

        if self.PreGameTimer == 0 then
            GameMode:OnHeroSelectionEnd()
        end
    end
end