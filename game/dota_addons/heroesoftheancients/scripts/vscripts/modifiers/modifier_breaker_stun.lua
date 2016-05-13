modifier_breaker_stun = class({})

function modifier_breaker_stun:CheckState()
  local state = {
    [MODIFIER_STATE_STUNNED] = true,
  }

  return state
end

function modifier_breaker_stun:IsHidden()
    return false
end

function modifier_breaker_stun:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end