modifier_behindGate = class({})

function modifier_behindGate:CheckState()
  local state = {
    [MODIFIER_STATE_ATTACK_IMMUNE] = true,
  }

  return state
end

function modifier_behindGate:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end