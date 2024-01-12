local addonName = "Flandre Stanby Screen"
local abs, sin, min, ceil
do
	local _obj_0 = math
	abs, sin, min, ceil = _obj_0.abs, _obj_0.sin, _obj_0.min, _obj_0.ceil
end
local ScrW, ScrH = ScrW, ScrH
local RealTime = RealTime
local HasFocus = system.HasFocus
local Add = hook.Add
local cl_flandre_color = CreateClientConVar("cl_flandre_color", "0.15 0.15 0.15", true, false, "Background color of standby screen.")
local cl_flandre_size = CreateClientConVar("cl_flandre_size", "25", true, false, "Size of standby screen icon.", 1, 100)
local width, height = ScrW(), ScrH()
local vmin = min(width, height) / 100
Add("OnScreenSizeChanged", addonName, function()
	width, height = ScrW(), ScrW()
	vmin = min(width, height) / 100
end)
local backgroundColor = Vector(cl_flandre_color:GetString()):ToColor()
cvars.AddChangeCallback(cl_flandre_color:GetName(), function(_, __, value)
	backgroundColor = Vector(value):ToColor()
end, addonName)
do
	local DrawRect, DrawTexturedRect, SetMaterial, SetDrawColor
	do
		local _obj_0 = surface
		DrawRect, DrawTexturedRect, SetMaterial, SetDrawColor = _obj_0.DrawRect, _obj_0.DrawTexturedRect, _obj_0.SetMaterial, _obj_0.SetDrawColor
	end
	local material = Material("flan/flanderka", "mips")
	Add("DrawOverlay", addonName, function()
		if HasFocus() then
			return
		end
		SetDrawColor(backgroundColor.r, backgroundColor.g, backgroundColor.b)
		DrawRect(0, 0, width, height)
		SetMaterial(material)
		local size = ceil(vmin * cl_flandre_size:GetInt())
		local x, y = (width - size) / 2, (height - size) / 2
		local mult = 0.25 + abs(sin(RealTime())) * 0.25
		local shadow1 = size * 0.1
		SetDrawColor(0, 0, 0, 60)
		DrawTexturedRect(x - shadow1 * mult, y - shadow1 * mult, size, size)
		local shadow2 = size * 0.2
		SetDrawColor(0, 0, 0, 120)
		DrawTexturedRect(x + shadow2 * mult, y + shadow2 * mult, size, size)
		SetDrawColor(255, 255, 255)
		return DrawTexturedRect(x, y, size, size)
	end)
end
return Add("RenderScene", addonName, function()
	if not HasFocus() then
		return true
	end
end)
