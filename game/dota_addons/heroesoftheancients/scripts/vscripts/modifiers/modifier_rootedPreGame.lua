modifier_rootedPreGame = class({})

function modifier_rootedPreGame:CheckState()
  local state = {
    [MODIFIER_STATE_ROOTED] = true,
  }

  return state
end

function modifier_rootedPreGame:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end