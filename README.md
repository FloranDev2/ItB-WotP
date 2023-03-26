# Weapons of the Past (v2.0.2)

IMPORTANT NOTE: this squad is now compatible with the Advanced Edition! :)

"A squad of almost relic-worthy mechs, consisting of Old-Earth World War 2 technology. Even though their old age, they still pack quite a punch."

Truelch and tob260 are proud to present the Weapons of the Past squad and hope you enjoy it!

Original idea: tob260
Creation: Truelch
Design: tob260 & Truelch
Descriptions: tob260
Art: Truelch with help and suggestions from tob260



## Credits:
Thanks a lot for the Discord community that helps a lot with feedback!

Special thanks to:
Lemonymous for the huge amount of help, knowledge, debug, the documentation you provided in addition to the various libraries that I stol... I mean took from you ;)
tosx for your help and mod expertise
narD also for sharing your code and show casing the mod :)
ALPHA (and Lemonymous) for helping me to set up FMW.
NamesAreHard (and Lemonymous again!) for helping me on the non massive warning script and the shop.
Protostar909, ,̶'̶,̶|̶'̶,̶'̶_̶  (loss), Machin and R30hedron for your feedbacks on the balance and design.
R30hedron (again!) and Djinn for your feedback on the KV-2 sprite.
Thx for JamesTripleQ for suggestions for the achievements.

and of course kartoFlane for the modloader!!!

(I hope I forgot nobody!)



## Description:

### Howitzer Mech (KV-2 'AT-ST')

The KV-2 Mech, official designation “AT-ST”, probably designed by a crazy Old-earth designer named Sergei, is very straight forward when it comes to destroying its foes.
It wields a 152 mm howitzer, originally designed to bust through bunkers.
Nowadays it's used to bust through the toughest vek the hive can spawn, dealing massive damage in the process, especially to larger Vek.
Even with its high age, its armor can withstand heavy beating, allowing it to hold its position.
However, its age doesn’t only come with advantages.
Due to it being a very old prototype, with, at the time, even less developed type of movement system, the mech suffers from very low movement capabilities.
Position it well, so that you can use its massive armament to obliterate any enemy, that dares to cross your path.


### Heavy Bomber Mech (Pe-8)

The Pe-8 heavy bomber can wreck havoc among the enemy with explosions & fire (not the Youtube channel).
It carries big payload of 500 kilogram bombs, which deal considerable amount of damage, and which can be upgraded to be filled with additional napalm, setting struck tiles ablaze. It also carries one FAB-5000 5 ton bomb, which can vaporize anything in its splash zone, however must be used with care, otherwise it might cause unwanted collateral damage. Sadly, the Archive engineers haven’t found a way to reduce its destructive capabilities on allied machinery… yet.


### Support Mech (M22 Locust)

M22 is a great utility mech, it can zip around the battlefield while supporting its team by using its very outdated, yet useful cannon able of shooting canister rounds, which can push the enemy, and smoke rounds, which can smoke up enemies to mess up their plans.
Both of the shells can be upgraded to deal damage, while retaining their properties.
Due to its small size, it can maneuver through smoke, but is prone to drowning. Use this mech wisely and with care, and it will serve you well.


## TODO
- Improve FAB-5000:
  - Item to pick up to reload the FAB-5000 instead of waiting a mission
  - Change the hacky logic with the memedit function: (https://discord.com/channels/417639520507527189/418142041189646336/1089284037950058576)
      Pawn:GetWeaponLimitedRemaining(weaponIndex)
      Pawn:GetWeaponLimitedUses(weaponIndex)
      Pawn:SetWeaponLimitedRemaining(weaponIndex, remaining)
      Pawn:SetWeaponLimitedUses(weaponIndex, uses)
  - Also, check how Conservative interacts with the FAB-5000
- Add tutorials:
  - How the howitzer works
  - How the FAB-5000 reload works
  - How the M6 Gun works (especially if FMW works again)
- Add options:
  - White screen explosion effect for the FAB-5000 (disabled by default?)
- Add train and armored train to the list of missions for "That belongs in a museum!"?

## Versions:

### v2.0.X - pre-release (current)

#### 2:
- Squad and global achievements now work again
- "Tank You!" achievements has new eligible mechs:
  - Magnum Mech (Vek Stompers)
  - Spark Mech (Fire Storm)
  - Catapult Mech (Magnetic Golems)
  - Overload Mech (Nuclear Nightmare)
- "That belongs in a museum!" has a new eligible mission: tosx' Battleship mission
  - Also, this achievement has been slightly changed:
    from: "Finish the 3 missions (air strike, tanks and artillery) without ally losses."
    to: "Finish 2 of the missions (air strike, tanks, artillery, battleship) without ally losses." (I'm also considering adding both train missions)
- Unlockable custom background now work again!

#### 1:
- Fixed mod and squad icons
- FAB-5000 cooldown is working again, but mght fail with Conservative skill

#### 0:
Pre-release version
Done:
- Updated libraries
- Changed weapon's reactor cost to fit with AE's balance changes:
  - M10T Howitzer reactor cost reduced from 2 to 1
  - FAB-500 reactor cost reduced from 1 to 0
  - FAB-5000 reactor cost reduced from 1 to 0
  - M6 Gun stays the same at 0 reactor cost!


### v1.1.X

#### 2:
- Imported Lemonymous' modified FMW lib

#### 1:
- Little fix in the FAB-5000 description.

#### 0: Big Update!
Balance changes:
- Pe-8:
  - FAB-500 first upgrade cost increased from 1 to 2
  - FAB-5000 is disabled if it has been used during the previous mission
Misc:
- Added an alternative menu background (disabled by default)
- Improved KV-2's sprite
- Improved Pe-8's sprite
- Changed FAB-500 icon


### v1.0.X

#### 2:
Updated to FMW v8.2

#### 1:
Some cleaning: removed unused files.

#### 0:
Release version!
I (think I) fixed an issue caused when trying to access a table before it was initialized.
It happened when Vek died before the first turn started. (on mines for example)


### v0.5.X

#### 5:
Added global achievements.
Fixed M22's A.C.I.D. effect (and other effects I guess) on the Board. (thx rumiaiscute that found this bug!)

#### 4:
Updated artilleryArc.lua
Fixed some stuff related to artillery arc. (I mean, Lemonymous did it ^^)
Added custom projectile effects for the KV-2's and M22's weapons.

#### 3:
Now the KV-2 has a lower artillery arc. (WIP)
Achievements':
- Added progression for all squad achievements
- Global achievements WIP
- Fixed values initialization
- Removed the event of the second stage start as it wasn't needed.

#### 2:
Achievements' fixes: (thx Lemonymous that found these bugs!)
- "World War Vek" should work properly now
- "Iron Harvest" data is initialized properly

#### 1:
Achievements' fixes:
- "Iron Harvest" reset the counter at the beginning of the turn (so it's really 6 kills during a single turn and not during the mission)
- "Who's a good boiii?" no longer counts enemies killed outside the player's turn

#### 0:
Added achievements:
- World War Vek: Complete the game without losing grid
- Iron Harvest: Kill 6 enemies in a single turn
- Who's a good boiii?: Complete a game where the M22 gets more kills than the KV-2

Minor adjustments proposed by Lemonymous:
- palette replaced by modApi
- shop replaced by modApi

Added mod icon (in addition to the existing squad icon)


### v0.4.X

#### 3:
Code/Libs:
- Upgraded to FMW v8.1 (from 8.0). (it fixes shell selection sub menu)
- Replaced the old non massive warning deployment with the new Lemonymous script that prevents the player to deploy non-massive units in water.
Visuals:
- Added M22 sprites. (finally!)
- Added broken anim for KV-2.
- Changed the Red Alert palette to a more desatured one. (it took it from Machin experimentation)
- Added shadows to weapons' icons.
- Created original sprites for push and smoke shells.
- Changed the color of the icon, using the "Soviet Green" palette.
- Fixed sprites' offsets issues.

#### 2:
Palette:
- Added two palettes: "Red Alert" and "Soviet Green".
Shop:
- Weapons have a custom rarity. They SHOULD appear in the shop. (I hope so...)
- Imported shop.lua (I took it from Frost Throne) (thx NamesAreHard for the help!)
Misc:
- Added a proper description. (finally!)
Fixes:
- ResourcePath fixed for Pe-8 and M22.

#### 1:
Now, the M22 has a FMW weapon. (M6 Gun)

#### 0:
Imported and integrated FMW. (thx Lemonymous and ATLAS for helping me setting it up!)
Added icons.


### v0.3.X

#### 1:
Fixed FAB-500 pull that made the first and second tile bump each other.
Fixed FAB-500 upgrade range.
Fixed FAB-500 and FAB-5000 first upgrade description.
Improved some text. (mentioned the pull effect for FAB-500, and added a \n for the second part of the M22 weapon description)
Cleaned some code / removed unused stuff.
(Finally thought about changing the version number in the init.lua...)

#### 0:
Imported Lemonymous non massive deploy warning.


### v0.2.X

#### 2:
Added a pull to the FAB-500 attack.

#### 1:
Changed FAB-5000 damage from Kill to 3.
Added an upgrade that increases damage by 2 for 2 cores.

#### 0:
Added KV-2 and Pe-8 sprites.
Added some polish on the M22 sprite. (that's baed on Archive's Light Tanks)
Polished the FAB-5000 effect. (synchronized explosion effects, slight delay before they are spawned)
Updated descriptions.


### v0.1.1

Removed the Cores' chest. (you can add them in the code if you want to test upgrades though)

KV-2
- Push is now enabled at start.

Pe-8
- Added the FAB-5000 as a single-use secondary weapon (is similar to archive bombers' attack)
- Added fire damage to FAB-500 when it got both upgrades (forgot about that, oopsie!)
- Fixed tip image description for when the weapons has both upgrades (now there's 3 enemies in a line, as expected)

Known bugs:
- Using the M22 weapon on self would end the turn for this unit without doing anything.


### v0.1.0

Improved version from all feedbacks.
Added tob260 Mechs' descriptions (see above).

Created this ReadMe file!

KV-2 'AT-ST'
- Changed its attack type from projectile to artillery (source changed from tank to rocket)
- Added bonus damage against armored (to emulate armor penetration)
- Added an upgrade that adds a push effect to the target

Pe-8
- The primary weapon is now named "FAB-500"
- TODO: add a secondary weapon, that can be used once: the "FAB-5000"

M22 Locust
- is no longer massive
- IgnoreSmoke (I hope it works!)
- Removed its neutralizing weapons, instead has a versatile weapon that can either push or smoke the target.


### v0.0.1

Demo version.
Has a working squad with placeholder sprites.
KV-2 has a weapon that deals damage equals to half enemy target health.
PE-8 has a bombing attack similar to JetMech's, but deals 1 additionnal damage and doesn't smoke the tile.
M22 has an attack that cancels the enemy attack.