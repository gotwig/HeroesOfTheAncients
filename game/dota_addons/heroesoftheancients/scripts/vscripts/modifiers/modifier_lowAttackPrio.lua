modifier_lowAttackPrio = class({})

function modifier_lowAttackPrio:CheckState()
  local state = {
    [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
  }

  return state
end

function modifier_lowAttackPrio:IsHidden()
    return true
end

function modifier_lowAttackPrio:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end