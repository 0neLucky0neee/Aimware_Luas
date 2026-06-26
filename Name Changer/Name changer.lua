ffi.cdef[[
	void* GetModuleHandleA(const char* lpModuleName);
]]

local NULL = 0x0

local ENGINE2_DLL_NAME = "engine2.dll"

-- 0x180685698 - 0x180000000 					= 0x685698
local cVTable_Address_VEngineCvar007_offset 	= NULL

-- 0x1803FC080 - 0x180000000 					= 0x3FC080
local cResolveConVar_offset 					= NULL

-- rcx_2 + 0x58 ->				0x58 / 0x8 		= 0xB
local cVTable_FindConVar_offset 				= 0xB

-- var_b0 + 0x30
local cConVarFlags 								= 0x30

local FCVAR_DEVELOPMENTONLY						= 0x2
local FCVAR_USERINFO							= 0x200

local function getOffsetFromPattern(cDllName, cPattern, cPatternOffset, cInstrSize)
	local cPatternLocation = mem.FindPattern(cDllName, cPattern)
	local cRelativeAddress = ffi.cast("int32_t*", cPatternLocation + cPatternOffset)[0x0]
	return tonumber(cPatternLocation + cRelativeAddress + cInstrSize) - tonumber(ffi.cast("uintptr_t", ffi.C.GetModuleHandleA(cDllName)))
end

-- I hope those patterns won't break
cVTable_Address_VEngineCvar007_offset 	= getOffsetFromPattern(ENGINE2_DLL_NAME, "48 8B 0D ?? ?? ?? ?? 48 8B 16 48 89 7C 24 ?? 4C 89 4C 24 ??", 3, 7)
cResolveConVar_offset					= getOffsetFromPattern(ENGINE2_DLL_NAME, "48 8B D3 E8 ?? ?? ?? ?? 48 8B 44 24", 4, 8)

-- print("VEngineCvar007: " .. string.format("0x%X", cVTable_Address_VEngineCvar007_offset))
-- print("ResolveConVarFunction: " .. string.format("0x%X", cResolveConVar_offset))

local function patchConVar(cConVarName)
	local engine2_base_address = tonumber(ffi.cast("uintptr_t", ffi.C.GetModuleHandleA(ENGINE2_DLL_NAME)))

	if engine2_base_address == nil or engine2_base_address == NULL then
		print("[patchConVar] Error, module aren't loaded")
		return
	end

	local vTable_engine_address = tonumber(ffi.cast("uintptr_t*", engine2_base_address + cVTable_Address_VEngineCvar007_offset)[0x0])
	local vTable_engine_table = tonumber(ffi.cast("uintptr_t*", vTable_engine_address)[0x0])

	local pFindConVarFunction_address = ffi.cast("uintptr_t*", vTable_engine_table)[cVTable_FindConVar_offset]
	local pFindConVarFunction = ffi.cast("void* (*)(void*, void*, const char*, int)", pFindConVarFunction_address)

	local pFindConVarOutput = ffi.new("void*[1]")
	local pFindConVarName = ffi.new("char[?]", cConVarName:len() + 0x1, cConVarName)

	-- (*(uint64_t*)rcx_2 + 0x58))(rcx_2, &arg_8, rdi_2, 0)
	local pFindConVarHandle_address = pFindConVarFunction(ffi.cast("void*", vTable_engine_address), pFindConVarOutput, pFindConVarName, 0x0)
	local pFindConVarHandle = ffi.cast("void*", pFindConVarHandle_address)

	-- int64_t* sub_1803fc080(int64_t* arg1, int32_t arg2, int16_t arg3)
	local pResolveConVarFunction = ffi.cast("void* (*)(int64_t*, int32_t, int16_t)", tonumber(ffi.cast("uintptr_t", engine2_base_address + cResolveConVar_offset)))
	local pResolveConVarOutput = ffi.new("int64_t[0x2]")

	-- sub_1803fc080(&var_28, pFindConVarOutput, 0xffff);
	-- It says 0xffff but we gonna use zero
	local pResolveConVarResult = pResolveConVarFunction(pResolveConVarOutput, ffi.cast("int32_t", pFindConVarOutput[0x0]), 0x0)
	
	-- print(tonumber(pResolveConVarOutput[0x0])) -> another value?
	-- print(tonumber(pResolveConVarOutput[0x1])) -> pointer

	-- var_b0 + 0x30
	local pCurrentConVarStruct_address = tonumber(pResolveConVarOutput[0x1])
	local pCurrentConVarFlags = ffi.cast("uintptr_t*", pCurrentConVarStruct_address + cConVarFlags)

	pCurrentConVarFlags[0x0] = bit.band(pCurrentConVarFlags[0x0], bit.bnot(FCVAR_DEVELOPMENTONLY))
	pCurrentConVarFlags[0x0] = bit.bor(pCurrentConVarFlags[0x0], FCVAR_USERINFO)
end

-------------------/\-------------------
local Aimware_Misc_Features_ref = gui.Reference("Miscellaneous", "Features")
local NameChanger_Combobox_ref = gui.Combobox(Aimware_Misc_Features_ref, "var_NameChanger_Listbox", "Clan-tag/Name-tag", "Disabled", "Fake name", "Static", "Static | Radar", "Minecraft enchantment | Radar", "Radar Exploit")

local NameChanger_Clantag_Editbox_ref = gui.Editbox(Aimware_Misc_Features_ref, "var_NameChanger_Clantag_Editbox", "")
-------------------\/-------------------

local function GetMagicSymbols(iCount)
	local magicSymbols = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
	local result = ""

	for i = 1, iCount do
		local magicIndex = math.random(1, magicSymbols:len() - 1)
		result = result .. magicSymbols:sub(magicIndex, magicIndex)
	end

	return result
end

local cOldRealName = " "
local function SaveRealPlayerName(cRealPlayerName)
	cOldRealName = cRealPlayerName
end

local function GetRealPlayerName()
	return cOldRealName
end

local function SetUserNameAndClantag(cClantagWithName)
	client.Command("name " .. cClantagWithName, true)
	client.Command("setinfo name " .. '"' .. cClantagWithName .. '"', true)
end

local function DisabledClantagHendler()
	SetUserNameAndClantag(cOldRealName)
end

local function StaticClantagHendler()
	SetUserNameAndClantag(NameChanger_Clantag_Editbox_ref:GetString() .. " " .. cOldRealName)
end

local function FakeNameHendler()
	SetUserNameAndClantag(NameChanger_Clantag_Editbox_ref:GetString())
end

local fakeChanged = false
local function StaticRadarClantagHendler()
	if fakeChanged then
		SetUserNameAndClantag(NameChanger_Clantag_Editbox_ref:GetString() .. " " .. cOldRealName)
		fakeChanged = false
	else
		SetUserNameAndClantag(NameChanger_Clantag_Editbox_ref:GetString() .. " " .. cOldRealName.. "⠀")
		fakeChanged = true
	end
end

local function MinecraftEnchantmentClantagHendler()
	SetUserNameAndClantag(GetMagicSymbols(math.random(10, 16)))
end

-- local fakeChanged = false
local function RadarExploitClantagHendler()
	if fakeChanged then
		SetUserNameAndClantag(cOldRealName)
		fakeChanged = false
	else
		SetUserNameAndClantag(cOldRealName .. "⠀")
		fakeChanged = true
	end
end

local cInitTime = globals.CurTime()

local bForceExit = false

local bNameWasSaved = false
local bNameWasChanged = false
local cLastTimeChanged_logic = -1
local function NameChangerLogicHandler()
	if bForceExit then
		return
	end

	if globals.CurTime() < cLastTimeChanged_logic then
		cLastTimeChanged_logic = globals.CurTime()
	end

	if engine.GetServerIP() == nil then
		cInitTime = globals.CurTime()
		bNameWasSaved = false
		return
	end

	if engine.GetMapName() == nil or engine.GetMapName() == "" then
		cInitTime = globals.CurTime()
		bNameWasSaved = false
		return
	end

	local pLocalPLayerEnt = entities.GetLocalPlayer()

	if pLocalPLayerEnt == nil then
		cInitTime = globals.CurTime()
		bNameWasSaved = false
		return
	end

	if (globals.CurTime() - cInitTime) < 0.3 then
		bNameWasSaved = false
		return
	end
	
	if bNameWasSaved == false then
		if pLocalPLayerEnt:IsPlayer() == false then
			return
		end

		print("[+] Name changer should work correctly")
		
		SaveRealPlayerName(pLocalPLayerEnt:GetName())
		bNameWasSaved = true
		patchConVar("name")
	end

	if (globals.CurTime() - cLastTimeChanged_logic) > 0.01 then
		cLastTimeChanged_logic = globals.CurTime()
		local ComboboxValue = NameChanger_Combobox_ref:GetValue()
		-- Lmao, switch case doesn't exists in lua

		-- Disabled
		if ComboboxValue == 0 and bNameWasChanged == true then
			DisabledClantagHendler()
			bNameWasChanged = false
		end
	
		-- Fake name
		if ComboboxValue == 1 then
			FakeNameHendler()
			bNameWasChanged = true
		end

		-- Static
		if ComboboxValue == 2 then
			StaticClantagHendler()
			bNameWasChanged = true
		end

		-- Static | Radar
		if ComboboxValue == 3 then
			StaticRadarClantagHendler()
			bNameWasChanged = true
		end

		-- Minecraft enchantment | Radar
		if ComboboxValue == 4 then
			MinecraftEnchantmentClantagHendler()
			bNameWasChanged = true
		end

		-- Radar Exploit
		if ComboboxValue == 5 then
			RadarExploitClantagHendler()
			bNameWasChanged = true
		end
	end
end

local cLastTimeChanged_menu = -1
local function NameChangerMenuHandler()
	if bForceExit then
		return
	end

	if globals.CurTime() < cLastTimeChanged_menu then
		cLastTimeChanged_menu = globals.CurTime()
	end

	if (globals.CurTime() - cLastTimeChanged_menu) > 0.01 then
		cLastTimeChanged_menu = globals.CurTime()
		local ComboboxValue = NameChanger_Combobox_ref:GetValue()
		-- Lmao, switch case doesn't exists in lua

		-- Disabled
		if ComboboxValue == 0 then
			NameChanger_Clantag_Editbox_ref:SetInvisible(true)
		end
	
		-- Fake name
		if ComboboxValue == 1 then
			NameChanger_Clantag_Editbox_ref:SetInvisible(false)
		end

		-- Static
		if ComboboxValue == 2 then
			NameChanger_Clantag_Editbox_ref:SetInvisible(false)
		end

		-- Static | Radar
		if ComboboxValue == 3 then
			NameChanger_Clantag_Editbox_ref:SetInvisible(false)
		end

		-- Minecraft enchantment | Radar
		if ComboboxValue == 4 then
			NameChanger_Clantag_Editbox_ref:SetInvisible(true)
		end

		-- Radar Exploit
		if ComboboxValue == 5 then
			NameChanger_Clantag_Editbox_ref:SetInvisible(true)
		end
	end
end

local cCurrentVersion = "v1.3.7"
local function CheckForUpdates()
	http.Get("https://raw.githubusercontent.com/0neLucky0neee/Aimware_Luas/refs/heads/main/Name%20Changer/Assets/version.txt", function(cExpectedVesion)
		print("[Name Changer] Your lua version is: " .. cCurrentVersion)

		if cExpectedVesion == nil then
			print("[Name Changer] Unable to receive the latest version")
			return
		end
	
		if string.find(cExpectedVesion, cCurrentVersion) == nil then
			print("[Name Changer] New version is out, get it on github.com/0neLucky0neee/Aimware_Luas")
		end
	end
	)
end

-------------------/\-------------------

CheckForUpdates()

-------------------/\-------------------

callbacks.Register("Draw", NameChangerLogicHandler)
callbacks.Register("Draw", NameChangerMenuHandler)
callbacks.Register("Unload", function()
	bForceExit = true

	if bNameWasSaved and NameChanger_Combobox_ref:GetValue() ~= 0 then
		local pLocalPLayerEnt = entities.GetLocalPlayer()

		if pLocalPLayerEnt == nil then
			return
		end

		DisabledClantagHendler()
	end
end)
