modifier_bush_hiding_lua = class({})

function modifier_bush_hiding:OnDestroy()
  local caster = self:GetParent() 

  if caster.isInBushes then
    caster:AddNewModifier(caster, nil, "modifier_invisible", {})
  end
end

function modifier_bush_hiding_lua:OnIntervalThink()
  local caster = self:GetParent() 
  if not caster:HasModifier("modifier_invisible") and caster.isInBushes then
    ApplyModifier(caster, caster, "modifier_bush_hiding", {duration=caster.bushHideTime})
  end
end