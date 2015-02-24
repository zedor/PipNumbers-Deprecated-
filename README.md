# PipNumbers

Shows numbers instead of the normal ability level indicators (pips)

[Preview](http://puu.sh/b799h/e7c98bf9e0.jpg)

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
