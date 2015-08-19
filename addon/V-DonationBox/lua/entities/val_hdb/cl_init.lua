include('shared.lua')

function ENT:Draw()
    self:DrawModel()
	
	local Ang = (self:GetAngles() + Angle(0, 90, 0))
	local Pos = ((self:GetPos() + -Ang:Forward() * 12.5) + Ang:Up() * 10)

	surface.SetFont("DermaLarge")
	local text = DarkRP.formatMoney(self:GetDTInt(0))
	local TextWidth = surface.GetTextSize(text)
	
	cam.Start3D2D(Pos + -Ang:Right() * 5, Ang, 0.1)
		draw.WordBox(2, -TextWidth * 0.5, -10, ("Donation Box"), "DermaLarge", Color(140, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
	
	cam.Start3D2D(Pos, Ang, 0.1)
		draw.WordBox(2, -TextWidth * 0.5, -10, ("Owned By ".. (self:GetDTString(0).. ": ".. text)), "DermaLarge", Color(140, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
end
