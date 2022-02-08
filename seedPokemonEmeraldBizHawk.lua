
--Original Code from Admiral-Fish's 3rd gen rng bot.lua
--Modified to display RNG Seed / Distance by NPO-197

--Color is in AARRGGBB format
ColorRed = 0xffa00000

rshift = bit.rshift
lshift = bit.lshift
band = bit.band

--Formula for LCRNG(R)
function back(s)
	local a = 0xEEB9 * band(s, 0xffff) + rshift(s, 16) * 0xEB65
	local b = 0xEB65 * band(s, 0xffff) + band(a, 0xffff) * 0x10000 + 0xA3561A1
  if b>0xffffffff then b = b - 0x100000000 end
  return b
end

--Reverses base seed until it encounters first 16bit seed
function validationSeed(s)
	while s > 0xffff do
		s = back(s)
	end
	return s
end

function Distance(s)
  local i = 0
  while s> 0xffff do
    i = i+1
    s = back(s)
  end
  return i
end

while true do
	seed = memory.read_u32_le(0x03005D80);
	gui.drawText( 0, 116, "RNG: "..string.format("%08X", seed), ColorRed)
	gui.drawText( 0, 132, "Seed:"..string.format("%08X", validationSeed(seed)), ColorRed)
	gui.drawText( 0, 148, "Dist:"..Distance(seed),ColorRed)
	emu.frameadvance();
end
