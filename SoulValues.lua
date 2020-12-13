local name, addon = ...;



addon.descriptions = {
	["Broker's Purse"] = {["id"] = 305308, ["description"] = "Acquire 400 Phantasma."},
	["Mawrat Harness"] = {["id"] = 304918, ["description"] = "Obtain a Mawrat Harness, an item that allows you to transform into a Maw Rat while in Torghast."},
	["Pocketed Soulcage"] = {["id"] = 305269, ["description"] = "Opening the cage will reward 10-20 Soul Remnants."},
	["Shackle Keys"] = {["id"] = 297413, ["description"] = "Shackle effects no longer damage or snare you."},
	["Maw Seeker Harness"] = {["id"] = 304918, ["description"] = "Obtain a Maw Seeker Harness, an item that allows you to transform into a Maw Seeker while in Torghast."},
	["Warden's Authority"] = {["id"] = 305266, ["description"] = "Automatically open all Soul Cages within 30 yards."},
	["Marrow Scooper"] = {["id"] = 305287, ["description"] = "Skeletons in the Jailer's Tower drop 10 times as much Phantasma."},
	["Skeletal Ward"] = {["id"] = 305288, ["description"] = "A skeleton will serve as your ward, assisting you in combat."},
	["Flamestarved Cinders"] = {["id"] = 305277, ["description"] = "Absorbs all nearby heat, reducing Fire damage taken by 65%."},
	["Dark Armaments"] = {["id"] = 305274, ["description"] = "Killing a creature grants 5% Haste for 10 sec. This effect can stack 10 times."},
	["Deadsoul Hound Harness"] = {["id"] = 304917, ["description"] = "Obtain a Deadsoul Hound Harness, an item that allows you to transform into a Deadsoul Hound while in Torghast."},
	["Purifier's Flame"] = {["id"] = 295754, ["description"] = "Deadsoul Death Pools no longer damage you, and instead you absorb them, healing yourself for (50% of Spell power) every 1 sec."},
	["Glasswing Charm"] = {["id"] = 305282, ["description"] = "Become a cloud of insects when out of combat, increasing movement speed by 80%."},
	["Prisoner's Concord"] = {["id"] = 305293, ["description"] = "Freeing a Soul Remnant from Torghast grants you 100% Critical Strike for 10 sec."},
}


addon.values = {
	["Mawrat"] = {["id"] = 151353, ["effect"] = addon.descriptions["Mawrat Harness"]},
	["Oddly Large Mawrat"] = {["id"] = 154030, ["effect"] = addon.descriptions["Mawrat Harness"]},
	["Broker Ve'ken"] = {["id"] = 152594, ["effect"] = addon.descriptions["Broker's Purse"]},
	["Broker Ve'nott"] = {["id"] = 170257, ["name"] = addon.descriptions["Broker's Purse"]},
	
	["Mawsworn Seeker"] = {["id"] = 152708, ["effect"] = addon.descriptions["Maw Seeker Harness"]},
	["Mawsworn Archer"] = {["id"] = 153878, ["effect"] = addon.descriptions["Pocketed Soulcage"]},
	["Mawsworn Interceptor"] = {["id"] = 150959, ["effect"] = addon.descriptions["Pocketed Soulcage"]},
	["Mawsworn Guard"] = {["id"] = 150958, ["effect"] = addon.descriptions["Warden's Authority"]},
	["Mawsworn Sentry"] = {["id"] = 153874, ["effect"] = addon.descriptions["Warden's Authority"]},
	["Mawsworn Firecaller"] = {["id"] = 157572, ["effect"] = addon.descriptions["Flamestarved Cinders"]},
	["Mawsworn Flametender"] = {["id"] = 157571, ["effect"] = addon.descriptions["Flamestarved Cinders"]},	
	["Mawsworn Acolyte"] = {["id"] = 155790, ["effect"] = addon.descriptions["Marrow Scooper"]},
	["Mawsworn Disciple"] = {["id"] = 155830, ["effect"] = addon.descriptions["Marrow Scooper"]},
	["Mawsworn Endbringer"] = {["id"] = 157810, ["effect"] = addon.descriptions["Marrow Scooper"]},
	["Mawsworn Soulbinder"] = {["id"] = 155949, ["effect"] = addon.descriptions["Marrow Scooper"]},
	["Mawsworn Shadestalker"] = {["id"] = 157819, ["effect"] = addon.descriptions["Warden's Authority"]},
	["Mawsworn Shackler"] = {["id"] = 155798, ["effect"] = addon.descriptions["Shackle Keys"]},
	
	["Lumbering Creation"] = {["id"] = 155824, ["effect"] = addon.descriptions["Marrow Scooper"]},
	["Skeletal Remains"] = {["id"] = 155793, ["effect"] = addon.descriptions["Skeletal Ward"]},	
	["Flameforge Master"] = {["id"] = 157584, ["effect"] = addon.descriptions["Flamestarved Cinders"]},
	["Forge Keeper"] = {["id"] = 157583, ["effect"] = addon.descriptions["Flamestarved Cinders"]},
	["Flameforge Enforcer"] = {["id"] = 157634, ["effect"] = addon.descriptions["Warden's Authority"]},
	
	["Coldheart Agent"] = {["id"] = 156212, ["effect"] = addon.descriptions["Dark Armaments"]},
	["Coldheart Ambusher"] = {["id"] = 170800, ["effect"] = addon.descriptions["Dark Armaments"]},
	["Coldheart Ascendant"] = {["id"] = 156157, ["effect"] = addon.descriptions["Dark Armaments"]},
	["Coldheart Binder"] = {["id"] = 156226, ["effect"] = addon.descriptions["Dark Armaments"]},
	["Coldheart Guardian"] = {["id"] = 156213, ["effect"] = addon.descriptions["Dark Armaments"]},
	["Coldheart Javelineer"] = {["id"] = 156159, ["effect"] = addon.descriptions["Dark Armaments"]},
	["Coldheart Scout"] = {["id"] = 156219, ["effect"] = addon.descriptions["Dark Armaments"]},
	
	["Deadsoul Scavenger"] = {["id"] = 151816, ["effect"] = addon.descriptions["Deadsoul Hound Harness"]},
	["Deadsoul Drifter"] = {["id"] = 152644, ["effect"] = addon.descriptions["Purifier's Flame"]},
	["Deadsoul Echo"] = {["id"] = 151815, ["effect"] = addon.descriptions["Purifier's Flame"]},
	["Deadsoul Scavenger"] = {["id"] = 151816, ["effect"] = addon.descriptions["Purifier's Flame"]},
	["Deadsoul Shade"] = {["id"] = 151814, ["effect"] = addon.descriptions["Purifier's Flame"]},
    ["Deadsoul Shadow"] = {["id"] = 153879, ["effect"] = addon.descriptions["Purifier's Flame"]},
    ["Deadsoul Shambler"] = {["id"] = 153885, ["effect"] = addon.descriptions["Purifier's Flame"]},
    ["Deadsoul Spirit"] = {["id"] = 153882, ["effect"] = addon.descriptions["Purifier's Flame"]},
    ["Weeping Wraith"] = {["id"] = 153552, ["effect"] = addon.descriptions["Purifier's Flame"]},
	
	["Blazing Elemental"] = {["id"] = 154128, ["effect"] = addon.descriptions["Flamestarved Cinders"]},
	["Burning Emberguard"] = {["id"] = 154129, ["effect"] = addon.descriptions["Flamestarved Cinders"]},
	
	
	["Faeleaf Grovesinger"] = {["id"] = 155225, ["effect"] = addon.descriptions["Glasswing Charm"]},
	["Faeleaf Tender"] = {["id"] = 155221, ["effect"] = addon.descriptions["Glasswing Charm"]},
	["Faeleaf Warden"] = {["id"] = 155216, ["effect"] = addon.descriptions["Glasswing Charm"]},
	["Verdant Keeper"] = {["id"] = 155226, ["effect"] = addon.descriptions["Glasswing Charm"]},
	["Faeleaf Lasher"] = {["id"] = 155215, ["effect"] = addon.descriptions["Glasswing Charm"]},
	["Gormling Pest"] = {["id"] = 155211, ["effect"] = addon.descriptions["Glasswing Charm"]},
	["Gormling Spitter"] = {["id"] = 155219, ["effect"] = addon.descriptions["Glasswing Charm"]},
	
	["Armed Prisoner"] = {["id"] = 154011, ["effect"] = addon.descriptions["Prisoner's Concord"]},
	["Escaped Ritualist"] = {["id"] = 154015, ["effect"] = addon.descriptions["Prisoner's Concord"]},
	["Imprisoned Cabalist"] = {["id"] = 154014, ["effect"] = addon.descriptions["Prisoner's Concord"]},
	["Prisonbreak Cursewalker"] = {["id"] = 154020, ["effect"] = addon.descriptions["Prisoner's Concord"]},
	["Prisonbreak Mauler"] = {["id"] = 154018, ["effect"] = addon.descriptions["Prisoner's Concord"]},
	["Prisonbreak Soulmender"] = {["id"] = 154016, ["effect"] = addon.descriptions["Prisoner's Concord"]},	
	
}

-- [""] = {["id"] = , ["effect"] = addon.descriptions[""]},
-- [""] = {["id"] = , ["description"] = ""},