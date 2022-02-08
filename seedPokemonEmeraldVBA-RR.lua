--Original Code from Admiral-Fish's 3rd gen rng bot.lua
--Modified to display RNG Seed / Distance by NPO-197

--color is in RRGGBBAA format, default is blue
TextColor = 0x0000a0ff

rshift = bit.rshift
lshift = bit.lshift
band = bit.band

--Formula for LCRNG(R)
function back(s)
	local a = 0xEEB9 * band(s, 0xffff) + rshift(s, 16) * 0xEB65
	local b = 0xEB65 * band(s, 0xffff) + band(a, 0xffff) * 0x10000 + 0xA3561A1
	return b
end

--Reverses base seed until it encounters first 16bit seed
function validationSeed(s)
	local useed = s
	while useed > 0xffff do
		s = back(s)
		useed = s
		if s>0xffffffff then useed = s-0x100000000 end
	end
	return s
end

function Distance(s)
  local i = 0
	local useed = s
  while useed> 0xffff do
    i = i+1
    s = back(s)
		useed = s
		if s>0xffffffff then useed = s-0x100000000 end
  end
  return i
end

while true do
	seed = memory.readlong(0x03005D80);
	gui.text( 0, 116, "RNG: "..string.format("%08X", seed),TextColor)
  gui.text( 0, 132, "Seed:"..string.format("%08X", validationSeed(seed)),TextColor)
	gui.text( 0, 148, "Dist:"..Distance(seed),TextColor)
	vba.frameadvance();
end
