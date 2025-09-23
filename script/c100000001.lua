--The Changer
--Link-4 monster with attribute changing and monster switching effects
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,2,4,s.linkfilter)
	
	--Effect 1: Change attributes when Link Summoned
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id+100)
	e1:SetCondition(s.attrcon)
	e1:SetTarget(s.attrtg)
	e1:SetOperation(s.attrop)
	c:RegisterEffect(e1)
	
	--Effect 2: Switch monster control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.swapcon)
	e2:SetTarget(s.swaptg)
	e2:SetOperation(s.swapop)
	c:RegisterEffect(e2)
end

--Link Material filter: Link monsters only
function s.matfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_LINK,lc,sumtype,tp)
end

function s.linkfilter(g,lc,sumtype,tp)
	return g:IsExists(Card.IsType,1,nil,TYPE_LINK,lc,sumtype,tp)
end

--Effect 1: Attribute change when Link Summoned
function s.attrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function s.attrfilter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE))
end

function s.attrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.attrfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.attrfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.attrfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,#g,0,0)
end

function s.attrop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g==0 then return end
	
	local attributes={ATTRIBUTE_DARK,ATTRIBUTE_LIGHT,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_WIND,ATTRIBUTE_DIVINE}
	local attr_names={"Dark","Light","Water","Fire","Earth","Wind","Divine"}
	
	for tc in aux.Next(g) do
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			--Let player choose new attribute
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
			local sel=Duel.AnnounceAttribute(tp,1,0xff)
			
			--Apply attribute change
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(sel)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

--Effect 2: Monster control switch
function s.swapcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,c)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
end

function s.swapfilter(c,tp)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end

function s.swaptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then 
		return Duel.IsExistingTarget(s.swapfilter,tp,LOCATION_MZONE,0,1,c)
			and Duel.IsExistingTarget(s.swapfilter,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,s.swapfilter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,s.swapfilter,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end

function s.swapop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g~=2 then return end
	
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	
	if tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) then
		Duel.SwapControl(tc1,tc2)
	end
end