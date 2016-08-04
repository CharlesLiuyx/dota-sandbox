modifier_target = class({})

function modifier_target:OnCreated(params)   
    if not IsServer() then
        return
    end
    self._particles = {}
    self:StartIntervalThink (.01)
end

function modifier_target:UpdateParticleForPlayer(i)
    local player = PlayerResource:GetPlayer(i)
    if player ~= nil then
        if GameRules.herodemo.overlays[i]["CreepAggroRangeButtonPressed"] == true then
            if self._particles[i] == nil then
                self._particles[i] = CreateParticleTarget(self:GetParent(), player)
            end
        elseif self._particles[i] ~= nil then
            ParticleManager:DestroyParticle(self._particles[i], true)
            self._particles[i] = nil
        end
    elseif self._particles[i] ~= nil then
        ParticleManager:DestroyParticle(self._particles[i], true)
        self._particles[i] = nil
    end
end

function modifier_target:OnIntervalThink()
    if not IsServer() then
        return
    end
    if self:GetCaster():IsHero() then
        self:UpdateParticleForPlayer(self:GetCaster():GetPlayerID())
    end
end

function modifier_target:OnDestroy(params)
    if not IsServer() then
        return
    end
    for _, particle in pairs(self._particles) do
        ParticleManager:DestroyParticle(particle, true)
    end
    self._particles = {}
end

function modifier_target:RemoveOnDeath()
    return true
end

--effect attached position the Buff effect attachment position
function modifier_target:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
function modifier_target:IsHidden()
    return false
end