## Flash/Scaleform is deprecated in Dota2Reborn. No further support for this module.

# PipNumbers

Shows numbers instead of the normal ability level indicators (pips)

[Preview](http://puu.sh/gb6ND/750caed197.jpg)

###### Usage

* Put the files in their correct folders
* In Lua, use FireGameEvent( 'send_hero_ent', { player_ID = pID, _ent = PlayerResource:GetSelectedHeroEntity(pID):GetEntityIndex() } )

###### custom_events.txt

```
"CustomEvents"
{
	
	"send_hero_ent"
	{
		"player_ID"		"short"
		"_ent"		"short"
	}
	
}
```
