[h1]WotC Jedi Class Mod [BETA][/h1]

[i]"For over a thousand generations, the Jedi were the guardians of peace and justice in the Old Republic — before the dark times. Before the Empire."[/i]

Jedi can use either dual lightsabers or primary lightsaber and a holocron.

Till you build you first lightsaber they also resort to mundane melee weapons.

Jedi can't be trained in the Guerilla Training School and they are rare to get on rookie promotion.

[h1]Force Powers[/h1]

[i]"The Force is what gives a Jedi his power. It's an energy field created by all living things. It surrounds us and penetrates us. It binds the galaxy together." [/i]

A preview of the force powers can be seen here https://youtu.be/TXoFliFNDNM

The full list of the perks with description can be found here [url=https://steamcommunity.com/workshop/filedetails/discussion/1546501455/1736594593592400200/]Force Powers[/url]

[i]"Don't be too proud of this technological terror you've constructed. The ability to destroy a planet is insignificant next to the power of the Force."[/i]

[h1]Force Pool[/h1]

In an effort to differentiate from the standard cooldown-based gameplay of other classes, Jedi have been given a Force Pool. This Force Pool acts similarly to mana pools from other games: you can cast abilities as long as you have the Force Points to do so. All Force abilities have a single turn cooldown, but a Jedi's Force Pool is very limited - by default, a Jedi receives 1 Force Point per rank as their maximum Force Pool. Three times per mission, a Jedi can use the Meditate ability to regenerate half of their maximum Force Points. Of course, this means that, while Jedi abilities are very powerful, Jedi are also very limited in their uses. The most powerful Force abilities require large amounts of Force Points to use, and will drain all Force Points when used. For example, Force Chain Lightning requires 5 Force Points, but even if you have 7 Force Points, you will end up with 0 Force Points remaining after you use it.

You can increase the number of Force Points available to a Jedi by equipping them with a Holocron in their secondary slot. This allows them to use more Force abilities in a mission, but it lowers the damage they deal in melee combat, because they've given up their second lightsaber.

[h1]Modular Saber System[/h1]

The modular lightsaber system is what I like to think of as the logical conclusion to the vanilla modular weapon system: every part of a saber's abilities is determined by the upgrades placed on it. When you create a lightsaber - and you create them one at a time - it automatically has four upgrades attached to it. You can build new upgrades and trade out the existing upgrades for these new upgrades, but you cannot remove them or replace them with non-lightsaber upgrades. (NOTE: Other mods may provide ways for you to unequip upgrades or equip incorrect upgrades. I highly suggest you not do this, as it will break how the sabers function)

As mentioned, all of a lightsaber's stats and abilities - from the aim bonuses to the damage to the armor shred - come from the upgrades. But it's not only the stats that are customized by the upgrade: the visual appearance of the saber also changes based upon which upgrades you equip to it. This means you have a tremendous amount of freedom to create the lightsaber you want your soldier to wield.

There are four upgrade categories: crystal, lens, emitter, and cell. There are 13 lenses, 13 emitters, 13 cells, and 28 crystals. Lenses, emitters, and cells can be built in engineering once you have researched the proper techs, but crystals must be looted from aliens. After all, they're glorified rocks. You can't exactly build them from metal.
In addition to the in-game customizability for sabers, every value on the saber upgrades that you might want to modify (and I mean every single one) has been pushed to an ini file for you to play with. You want to change the aim bonus of a certain upgrade? Go ahead. Want to change how much damage it deals? There you go. Want to make it give you new abilities? You got it. Want to change its visual model, or what the icon looks like in the menus? You can do that too. You want to add completely new lightsaber crystals or parts? Have fun. You have the power to do just about whatever you want to do, right there in the ini file. There is an extensive list of instructions there to guide you through each part of the process, and there are 67 existing upgrades to use as a guide.

[url=https://docs.google.com/spreadsheets/d/10dBL4yeVK4Dk8z9FLWuNVEtq6D9V8uGXSqtS9r6Gmos/edit#gid=0] All upgrades in detail [/url]

[h1]Force Alignment[/h1]

[i]"Strike me down with all your hatred and your journey towards the dark side will be complete"[/i]

Following the path of the dark side will quickly make you stronger. If you are following your negative emotions and use dark force powers on civilian or squad mates you gain [b]Dark Side Points[/b].
Each Dark Side Points increases your hit chances with Dark Side Powers.
If you instead follow the path of the Light Side your are gaining [b]Light Side Points[/b]. This increases your hit chances with lightsaber related force powers and Jedi Mind Tricks but it will make it harder to use Dark Side Force Powers.
Healing squad mates with the force, finishing missions without killing anybody or carrying home wounded squad mates are consideres good deeds.
[i]
Luke: Vader... Is the dark side stronger?
Yoda: No, no, no. Quicker, easier, more seductive.
[/i]

[h1]FAQ[/h1]

[b]I don't see the dark side perk column / I have only two perk choice per rank[/b]
Subscribe to [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1124609091&searchtext=promotion+screen][WOTC] New Promotion Screen by Default[/url]

[b]My Lightsabers doesn't glow[/b]
Possible problem #1: your graphical settings are too low
Solution: Try to turn on FXAA, Bloom, and Medium Textures

Possible problem #2: you are missing the shader cache file.
Solution: Try to unsub, start the game once, exit the game and resub again.

[b]How can i use "Commanders Choice" or train Jedi in the GTS?[/b]
In {DriveLetter}:\Program Files (x86)\Steam\SteamApps\workshop\content\268500\1546501455\config\XComClassData.ini change NumInForcedDeck to
[code]
+NumInForcedDeck=1
[/code]
[b]How can i have a regular rookie distribution for the Jedi?[/b]
In XComClassData.ini change NumInDeck to
[code]
+NumInDeck=4
[/code]

[h1]Mod Compatility[/h1]
This mod is not compatible with the current version of Grimy’s Loot Mod.
Other incombatibilities are not known yet.

[h1]Credits[/h1]

[i]"You do have your moments. Not many, but you have them."[/i]

[list]
	[*]Ginger - A special thanks to Ginger who made this Wotc conversion happen, but did not stopped at that and added the Force Pool System and Modular Lightsaber System
	[*]HulkCX - Substance painter textures and maya modelling of the modular lightsaber system
	[*]Zyxpsilon - Class Icon, Perk Icons and Rank Icons. Incredible work buddy!
	[*]vhs - Workshop Image
	[*]ObelixDK - Force Jump Animation, Lightsaber blender magic and being the good soul of creative xenos
	[*]xylthixlm - Force Sense Code, Custom Perk advisor, Ability Modding Authority
	[*]Shadow79 & Darrick - Beta testing sith lords
	[*]SirSunkruhm, SophiaOr & Dev - WotC Beta testing councellars
	[*]robojumper - Code consultant, chain lightning visualisation, constant support when i was stuck again
	[*]LeaderEnemyBoss - Ragdoll Expert and Force Push Code Guide
[/list]

[h1]Note that this mod is in BETA and you may encouter bugs and glitches[/h1]