local addon_name = "Flandre Stanby Screen"

-- Background color
local red, green, blue = string.match( CreateConVar( "cl_flandre_bgcolor", "33 33 33", FCVAR_ARCHIVE, "Background color of flandre standby screen." ):GetString(), "([%d.]+)%s*([%d.]*)%s*([%d.]*)" )
red, green, blue = math.Clamp( tonumber( red, 10 ) or 0, 0, 255 ), math.Clamp( tonumber( green, 10 ) or 0, 0, 255 ), math.Clamp( tonumber( blue, 10 ) or 0, 0, 255 )

cvars.AddChangeCallback( "cl_flandre_bgcolor", function( _, __, value )
	red, green, blue = string.match( value, "([%d.]+)%s*([%d.]*)%s*([%d.]*)" )
	red, green, blue = math.Clamp( tonumber( red, 10 ) or 0, 0, 255 ), math.Clamp( tonumber( green, 10 ) or 0, 0, 255 ), math.Clamp( tonumber( blue, 10 ) or 0, 0, 255 )
end, addon_name )

local percentage = CreateConVar( "cl_flandre_size", "25", FCVAR_ARCHIVE, "Size of flandre standby screen icon.", 0, 100 ):GetFloat()

cvars.AddChangeCallback( "cl_flandre_size", function( _, __, value )
	percentage = math.Clamp( tonumber( value, 10 ) or 0, 0, 100 )
end, addon_name )

-- Size and position
local screen_width, screen_height = ScrW(), ScrH()
local vmin = math.min( screen_width, screen_height ) * 0.01

hook.Add( "OnScreenSizeChanged", addon_name, function( _, __, width, height )
	screen_width, screen_height = width, height
	vmin = math.min( width, height ) * 0.01
end )

local math_abs, math_sin, math_ceil = math.abs, math.sin, math.ceil
local HasFocus = system.HasFocus
local RealTime = RealTime

local x, y, size, shadow1, shadow2 = 0, 0, 0, 0, 0

-- I hope it's faster that way...
local isInFocus = false

hook.Add( "Think", addon_name, function()
	isInFocus = HasFocus()

	-- Don't calculate if not in focus
	if isInFocus then return end

	-- Position and size
	size = math_ceil( vmin * percentage )
	x, y = ( screen_width - size ) * 0.5, ( screen_height - size ) * 0.5

	-- Shadow calculation
	local mult = 0.25 + math_abs( math_sin( RealTime() ) ) * 0.25
	shadow1 = size * 0.1 * mult
	shadow2 = size * 0.2 * mult
end )

local surface_DrawRect, surface_DrawTexturedRect, surface_SetMaterial, surface_SetDrawColor = surface.DrawRect, surface.DrawTexturedRect, surface.SetMaterial, surface.SetDrawColor
local cam_Start2D, cam_End2D = cam.Start2D, cam.End2D

local material = Material( "flan/flanderka" )

-- Render
hook.Add( "PreRender", addon_name, function()
	if isInFocus then return end

	cam_Start2D()

	surface_SetDrawColor( red, green, blue )
	surface_DrawRect( 0, 0, screen_width, screen_height )

	surface_SetMaterial( material )

	surface_SetDrawColor( 0, 0, 0, 60 )
	surface_DrawTexturedRect( x - shadow1, y - shadow1, size, size )

	surface_SetDrawColor( 0, 0, 0, 120 )
	surface_DrawTexturedRect( x + shadow2, y + shadow2, size, size )

	surface_SetDrawColor( 255, 255, 255 )
	surface_DrawTexturedRect( x, y, size, size )

	cam_End2D()

	return true
end )
