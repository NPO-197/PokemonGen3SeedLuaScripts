--Original Code from Admiral-Fish's 3rd gen rng bot.lua
--Modified to display RNG Seed / Distance by NPO-197

--color is in RRGGBBAA format, default is blue
TextColor = 0x0000a0ff


--Depending on the Version the RNG is stored in a different location,
--Set the variable Version based on this list...
-- Game							Region	Seed address
--1	Ruby/Sapphire			USA			0x03004818
--2 Ruby/Sapphire			PAL			0x03004828
--3 Ruby/Sapphire			JPN			0x03004748
--4 FireRed/LeafGreen	USA			0x03005000
--5 FireRed/LeafGreen	PAL			0x03004F50
--6 FireRed/LeafGreen	JPN			0x03005040
--7 Emerald						USA			0x03005D80
--8 Emerald						PAL			0x03005D80
--9 Emerald						JPN			0x03005AE0

Version = 1

GameVersionList={"Ruby/Sapphire USA",
								"Ruby/Sapphire PAL",
								"Ruby/Sapphire JPN",
								"FireRed/LeafGreen USA",
								"FireRed/LeafGreen PAL",
								"FireRed/LeafGreen JPN",
								"Emerald USA",
								"Emerald PAL",
								"Emerald JPN"}
SeedAddressList={0x03004818,
						0x03004828,
						0x03004748,
						0x03005000,
						0x03004F50,
						0x03005040,
						0x03005D80,
						0x03005D80,
						0x03005D80,
						0x03005AE0}

SeedAddress = SeedAddressList[Version]
VersionString = GameVersionList[Version]
print("Version Set as:"..VersionString)
print("Reading from address: "..string.format("%08X",SeedAddress))
print("If this is the wrong version you must edit the .lua file to specify the correct version.")

--Only edit below this line if you know what you are doing.

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
	seed = memory.readlong(SeedAddress);
	gui.text( 0, 116, "RNG: "..string.format("%08X", seed),TextColor)
  gui.text( 0, 132, "Seed:"..string.format("%08X", validationSeed(seed)),TextColor)
	gui.text( 0, 148, "Dist:"..Distance(seed),TextColor)
	vba.frameadvance();
end
