Player = class({
    id = 0,
    hero = nil,
    player = nil,
    score = 0,
    team = 0,
    selectionLocked = false,
    selectedHero = nil
})

function Player:SetPlayerID(id)
    self.id = id
end

function Player:SetTeam(i)
    self.team = i

    if i ~= nil then
        local color = GameRules.GameMode.TeamColors[i]
        PlayerResource:SetCustomTeamAssignment(self.id, i)
        PlayerResource:SetCustomPlayerColor(self.id, color[1], color[2], color[3])
    end
end

function Player:IsConnected()
    return PlayerResource:GetConnectionState(self.id) == DOTA_CONNECTION_STATE_CONNECTED or IsInToolsMode()
end