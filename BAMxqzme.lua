print("|cff33ffccBAM|cffffffffxqzme - loaded")
local frame = CreateFrame("FRAME");
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

SlashCmdList['BAMXQZME'] = function(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg or 'nil')
end
SLASH_BAMXQZME1 = '/bamxqzme'
SLASH_BAMXQZME2 = '/xq'
SLASH_BAMXQZME3 = '/xq'

SLASH_BAMXQZME1, SLASH_BAMXQZME2, SLASH_BAMXQZME3 = "/bamxqzme", "/xq", "/bam"
SlashCmdList["BAMXQZME"] = function(message)
	local cmd = { }
	for c in string.gmatch(message, "[^ ]+") do
		table.insert(cmd, string.lower(c))
	end

	if cmd[1] == "say" then
    BAMxqzmeSettings = "SAY"
  elseif cmd[1] == "yell" then
    BAMxqzmeSettings = "YELL"
  elseif cmd[1] == "group" then
    BAMxqzmeSettings = "GROUP"
  elseif cmd[1] == "raid" then
    BAMxqzmeSettings = "RAID"
  elseif cmd[1] == "self" then
    BAMxqzmeSettings = "SELF"
	else
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ffccBAM|rxqzme usage:")
    DEFAULT_CHAT_FRAME:AddMessage("/bam [say, yell, group, raid, self]")
  end

  if not BAMxqzmeSettings then 
    BAMxqzmeSettings = "SELF" 
  end
  DEFAULT_CHAT_FRAME:AddMessage("-> you are now spamming your crits in '" .. string.lower(BAMxqzmeSettings) .. "'")
  
end

frame:SetScript("OnEvent", function(self, event)

local CritAmountDmg = 1
local CritAmountHeal = 1
local EveryoneGitInHereDmg = 1
local EveryoneGitInHereHeal = 1


local OutputMessageDmg = "BAM phat crit!"
local OutputMessageHeal = "I healed you big time!"


--function

  local spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, CombatLogGetCurrentEventInfo())
  local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
  local playerGUID = UnitGUID("player")
  if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		-- damage
		if (type == "SPELL_DAMAGE") and critical and (sourceGUID == playerGUID) then
			if amount >= CritAmountDmg then
			if BAMxqzmeSettings == "SELF" then
				DEFAULT_CHAT_FRAME:AddMessage(OutputMessageDmg.." "..spellName.." - "..format_thousand(amount))
				script=PlaySoundFile("Interface\\AddOns\\BAMxqzme\\bam.ogg", "Dialog")
				else
				if EveryoneGitInHereDmg == 1 then
					if BAMxqzmeSettings == "SAY" then
						SendChatMessage(OutputMessageDmg.." "..spellName.." - "..format_thousand(amount), BAMxqzmeSettings ,nil);
					end
				else
					print(OutputMessageDmg.." | "..spellName.." - "..format_thousand(amount))
				end
				script=PlaySoundFile("Interface\\AddOns\\BAMxqzme\\bam.ogg", "Dialog")
			end
		end
		end
		

		-- heal
		critical = select(18,CombatLogGetCurrentEventInfo())
		if (type == "SPELL_HEAL") and critical and (sourceGUID == playerGUID) then
			if amount >= CritAmountHeal then
				if EveryoneGitInHereHeal == 1 then
					if BAMxqzmeSettings ~= "SAY" then
						SendChatMessage(OutputMessageHeal.." "..destName.." - "..spellName.." - "..format_thousand(amount), BAMxqzmeSettings ,nil);
					end
				elseif BAMxqzmeSettings ~= "SELF" then
					print(OutputMessageHeal.." | "..destName.." with "..spellName.." for "..format_thousand(amount))
				end
				script=PlaySoundFile("Interface\\AddOns\\BAMxqzme\\bam.ogg", "Dialog")
			end
		end
  end
end);
--format the numbers
function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
    .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end