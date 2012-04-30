;;;;;;;Autochange script.

/if ({cweap}=~'') /set cweap=1%;/endif
/if ({pweap}=~'') /set pweap=1%;/endif

/def w = \
  /if (leading=1) \
    gt use &+R%*%;\
  /endif%;\
  /weapon %*


/def -mregexp -p9999 -F -t'([A-z]+) tells the group, \'(H|h)(ORGAR|orgar)\'' cweaphorgar = \
  /if ({horgarslay} !~ '') \
    /weapon horgar%;\
  /else \
    /weapon fire%;\
  /endif


/def -mregexp -p9999 -F -t'([A-z]+) tells the group, \'(USE|use) ([A-Za-z/\ ]*)\'' leadercweap = \
  /if ({P1}=/{tank}) \
    /let _newdam=$[replace('/',' ', {P3})]%;\
    /let _newdam=$[replace('or',' ', {_newdam})]%;\
    /let _newdam=$[replace('slay ','slay', {_newdam})]%;\
    /let _newdam=$[replace('  ',' ', {_newdam})]%;\
    /let _newdam=$[replace('  ',' ', {_newdam})]%;\
    /if (_newdam =/ 'iron') \
      /d %_newdam%;\
      /weapon %_newdam%;\
    /elseif (_newdam =/ 'unlife') \
      /d %_newdam magic dark%;\
      /weapon unlife magic dark%;\
    /elseif (_newdam =/ 'pure*') \
      /d %_newdam%;\
      /weapon %_newdam slaydemon%;\
    /else \
      /d %_newdam%;\
      /weapon %_newdam%;\
    /endif%;\
  /endif

;;;;;;;;;;;;;;;;;;
;PathWeaver
;;;;;;;;;;;;;;;;;;
/def weaver = \
  /if ({1}=/'fire'|{1}=/'slayorc') \
    /if ({pweavertype}!/'death') \
      /ecko %htxt(%htxt2\CWEAP%htxt) %ntxt\Weapon Slay%ntxt2: %htxt%1 %htxt(%htxt2%weapon%htxt)%;\
      say baru goth deathflame%;wield pathweaver%;/set pweavertype=death%;\
    /endif%;\
  /elseif ({1}=/'ice'|{1}=/'slayde') \
    /if ({pweavertype}!/'hail') \
      /ecko %htxt(%htxt2\CWEAP%htxt) %ntxt\Weapon Slay%ntxt2: %htxt%1 %htxt(%htxt2%weapon%htxt)%;\
      say bwaihna cur hailstrike%;wield pathweaver%;/set pweavertype=hail%;\
    /endif%;\
  /else \
    /if ({pweavertype}!/'normal') \
      /ecko %htxt(%htxt2\CWEAP%htxt) %ntxt\Weapon Slay%ntxt2: %htxt%1 %htxt(%htxt2%weapon%htxt)%;\
      say cuntoh magu%;wield pathweaver%;/set pweavertype=normal%;\
    /endif%;\
  /endif%;\



;;;;;;;;;;;;;;;;;
;WEAPON SWITCHER;
;;;;;;;;;;;;;;;;;
/def cweap = \
  /if ({1} =/ 'on') \
    /set cweap=1%;\
    /ecko Will now autochange Weapon.%;\
  /elseif ({1} =/ 'off') \
    /set cweap=0%;\
    /ecko Won't autochange Weapon.%;\
  /else \
    /if (rogue>0 & quickdraw=1 & fighting=1) \
      /let _wieldcmd=quickdraw%;\
    /else \
      /let _wieldcmd=wield%;\
    /endif%;\
    /if ({2}!~('')|(' ')|('0')) \
      /if (({2}!/weapon)|({2}=/'pathweaver')) \
        /if (lead=1) \
          gtell use %1%;\
        /endif%;\
        /if ({2}=/'pathweaver') \
        /else \
          /ecko %htxt(%htxt2\CWEAP%htxt) %ntxt\Weapon Slay%ntxt2: %htxt%1 %htxt(%htxt2%2%htxt)%;\
        /endif%;\
        /if ({2}=/'mord*') \
          mord%;\
        /elseif ({2}=/'pathweaver') \
          /if ({weapon}!/'pathweaver') \
            /if (pweap=1) \
              gc %{2} weapon!%;\
              /if (quickdraw=1 & fighting=1) \
                quickdraw %2%;\
              /else \
                remove %weapon%;\
	      /endif%;\
	      wield %2%;\
              /repeat -0:00:01 1 pc %{weapon} weapon!%;\
            /else \
              /if (quickdraw=1 & fighting=1) \
                quickdraw %2%;\
              /else \
                remove %weapon%;\
              /endif%;\
              wield %2%;\
            /endif%;\
          /endif%;\
          /weaver %1%;\
        /else \
          /if (pweap=1) \
            gc %{2} weapon!%;\
            /if (quickdraw=1 & fighting=1) \
              quickdraw %2%;\
            /else \
              remove %weapon%;\
            /endif%;\
            wield %2%;\
            /repeat -0:00:01 1 pc %{weapon} weapon!%;\
          /else \
            /if (quickdraw=1 & fighting=1) \
              quickdraw %2%;\
            /else \
              remove %weapon%;\
            /endif%;\
            wield %2%;\
          /endif%;\
        /endif%;\
        /set weapon=%{2}%;\
      /endif%;\
    /else \
      /if (slayalt1!~''|slayalt1!~' '|slayalt1!~'0') \
        /weapon %slayalt1 %slayalt2%;\
      /elseif (normslay!~('')|(' ')|('0')) /weapon%;\
      /endif%;\
    /endif%;\
  /endif

/def weapon = \
/if (cweap=1) \
  /set slayalt1=0%;/set slayalt2=0%;\
  /set slayalt1=%{2}%;\
  /set slayalt2=%{3}%;\
  /if ({1} =/ 'acid') \
    /cweap Acid %acidslay%;\
  /elseif ({1} =/ 'air') \
    /cweap Air %airslay%;\
  /elseif ({1} =/ 'bleed') \
    /cweap Bleed %bleedslay%;\
  /elseif ({1} =/ 'dark') \
    /cweap Dark %darkslay%;\
  /elseif ({1} =/ 'earth') \
    /cweap Earth %earthslay%;\
  /elseif ({1} =/ 'electricity') \
    /cweap Electricity %electricityslay%;\
  /elseif ({1} =/ 'energy') \
    /cweap Energy %energyslay%;\
  /elseif ({1} =/ 'fire') \
    /cweap Fire %fireslay%;\
  /elseif ({1} =/ 'horgar') \
    /cweap HorgarWeapon %horgarslay%;\
  /elseif ({1} =/ 'gas') \
    /cweap Gas %gasslay%;\
  /elseif ({1} =/ 'ice') \
    /cweap Ice %iceslay%;\
  /elseif ({1} =/ 'iron') \
    /cweap Iron %ironslay%;\
  /elseif ({1} =/ 'light') \
    /cweap Light %lightslay%;\
  /elseif ({1} =/ 'normal') \
    /cweap Normal %normalslay%;\
  /elseif ({1} =/ 'magic') \
    /cweap Magic %magicslay%;\
  /elseif ({1} =/ 'mental') \
    /cweap Mental %mentalslay%;\
  /elseif ({1} =/ 'poison') \
    /cweap Poison %poisonslay%;\
  /elseif ({1} =/ 'pure') \
    /cweap Pure %pureslay%;\
  /elseif ({1} =/ 'silver') \
    /cweap Silver %silverslay%;\
  /elseif ({1} =/ 'stun') \
    /cweap Stun %stunslay%;\
  /elseif ({1} =/ 'superlarge') \
    /cweap Superlarge %superlargeslay%;\
  /elseif ({1} =/ 'unlife') \
    /cweap Unlife %unlifeslay%;\
  /elseif ({1} =/ 'water') \
    /cweap Water %waterslay%;\
  /elseif ({1} =/ 'wood') \
    /cweap Wood %woodslay%;\
  /elseif ({1} =/ 'slaydemon') \
    /cweap SlayDEMON %demonslay%;\
  /elseif ({1} =/ 'slaydragon') \
    /cweap SlayDRAGON %dragonslay%;\
  /elseif ({1} =/ 'slayde' | {1} =/ 'slaydrowelf') \
    /cweap SlayDE %drowelfslay%;\
  /elseif ({1} =/ 'slaydwarf') \
    /cweap SlayDWARF %dwarfslay%;\
  /elseif ({1} =/ 'slayelemental') \
    /cweap SlayELEMENTAL %elementalslay%;\
  /elseif ({1} =/ 'slayelf') \
    /cweap SlayELF %elflay%;\
  /elseif ({1} =/ 'slaygiant') \
    /cweap SlayGIANT %giantslay%;\
  /elseif ({1} =/ 'slaygnome') \
    /cweap SlayGNOME %gnomeslay%;\
  /elseif ({1} =/ 'slaygoblin') \
    /cweap SlayGOBLIN %goblinslay%;\
  /elseif ({1} =/ 'slayhe' | {1} =/ 'slayhalfelf') \
    /cweap SlayHE %halfelfslay%;\
  /elseif ({1} =/ 'slayhobbit') \
    /cweap SlayHOBBIT %hobbitslay%;\
  /elseif ({1} =/ 'slayhuman') \
    /cweap SlayHUMAN %humanslay%;\
  /elseif ({1} =/ 'slaymythical') \
    /cweap SlayMYTHICAL %mythicalslay%;\
  /elseif ({1} =/ 'slaymagical') \
    /cweap SlayMAGICAL %magicalslay%;\
  /elseif ({1} =/ 'slayorc') \
    /cweap SlayORC %orcslay%;\
  /elseif ({1} =/ 'slayundead') \
    /cweap SlayUNDEAD %undeadslay%;\
  /elseif ({1} =/ 'slayvampire') \
    /cweap SlayVAMPIRE %vampireslay%;\
  /elseif ({1} =/ 'fireslash') \
    /cweap Fireslash %fireslash%;\
  /else \
    /eval /set _tmpweap=%%{%{1}slay}%;\
    /if (_tmpweap !~ '') \
      /cweap %{1} %_tmpweap%;\
    /elseif (slayalt1 !~ '') \
      /weapon %slayalt1 %slayalt2%;\
    /else \
      /if (weapon!~normslay) \
        /cweap Normal %normslay%;\
      /endif%;\
    /endif%;\
  /endif%;\
/endif

/def addweapon = \
  /if ({1} !~ '' & {2} !~ '') \
    /let _newdamtype=$[tolower({1})]%;\
    /eval /set %{_newdamtype}slay=%{2}%;\
    /ecko Added:%htxt2 %_newdamtype%ntxt To use it type%htxt2 /w %_newdamtype%;\
  /else \
    /uecko Usage: /addweapon <type> <weapon-name>%;\
  /endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;Mob/Room name triggs;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/def -mglob -t'A gorm {mage|priestess|warrior}*' cweap1 = \
	/weapon acid poison fire%;/d fire

/def -mglob -t'A huge, ancient tree towers above you.' cweap2 = \
	/weapon acid%;/d backstab murder energy unlife

/def -F -mglob -t'*{A soulcrusher lurks in the shadows here.|The soulcrusher glances at you with fear.|A blurred figure stands here.}*' cweap3 = \
	/weapon iron%;/d backstab murder light pure ice

/def -F -mglob -t'*{A great soulcrusher stands here.|A Long Hallway in the Twisted Laboratory}*' cweap4 = \
	/weapon iron%;/d backstab murder light pure ice


/def -F -mglob -t'{Walking through DragonSpyre|The star spawn|The deep one|The hunting horror}*' cweap6 = \
        /weapon%;/d backstab murder energy ice unlife

/def -F -mglob -t'*rubs the*' cweap7 = \
	/weapon%;/d normal backstab murder
	
/def -mglob -t'{Entrance to the City of Antiriad.|Outside Ye Olde Shoppe.}*' cweap8 = \
	/weapon fire%;/d fire backstab murder

/def -mglob -t'The abandoned shop.' cweap9 = \
        /weapon energy%;/d energy backstab murder

/def -mglob -t'{a Black Troll of Tumuz Orgmeen stands here.|a whitish skinned Troll of Tumuz Orgmeen stands here.}*' cweap10 = \
        /weapon fire%;/d fire

/def -mglob -t'{A worn out guard stands watch here.|A skinny man hides in the shadows.|A big guard stands watch here.}*' cweap11 = \
	/weapon fire%;/d fire

/def -mglob -t'{The Gatehouse of the Citadel|A large man dressed in half plate stands here|A guard is here patrolling the courtyard.}*' cweap12 =\
	/weapon unlife dark iron%;/d unlife energy

/def -p100 -F -mglob -t'{The Flaming Corpse}*' cweap13 = \
	/weapon unlife magic%;/d unlife

/def -mglob -t'{An elven ranger scouts the surrounding hinterland}*' cweap14 =\
	/weapon unlife iron dark%;/d backstab murder unlife energy

/def -mglob -t'The Entrance To EarthSea' cweap15 = \
	/weapon unlife magic%;/d unlife backstab murder energy fire

/def -mglob -t'{The entrance to the great Dwarven kingdom, Inglestone\
|A dwarven champion is here blocking your way east|a Dwarven warrior priest stands here\
|a Dwarven high champion patrols the hall looking for intruders}*' cweap16 =\
        /weapon water magic%;/d backstab energy unlife

/def -mglob -t'The Gatekeeper of the stronghold stands here proudly' cweap17 = \
	/weapon unlife iron dark%;/d murder backstab pwp ice

/def -mregexp -t'{A guard of Alterac defends the sanctity of his homelands here\
|A member of the Alterac high command opposes you\
|A hero of the Alliance stands on full alert\
|An adventurer of the realm is killing some time here\
|A soldier of fortune waits here for direction\
|A merchant has stopped here briefly to trade|A lieutenant of the high command oversees proceedings\
|A healthy peasant toils for the Alliance here\
|A member of the Alterac high command opposes you}' cweap18 = \
	/weapon unlife iron dark%;/d murder backstab ice

;/def -mglob -t'A skeleton is here lying in a coffin.' cweap19 = \
;	/weapon silver%;/d energy fire backstab murder

/def -mglob -t'You {*} The Skeleton with your *' cweap19 = \
	/weapon silver%;/d energy fire backstab murder

/def -mglob -p2 -F -t'A Ni\'hachbin warrior*' cweap20 = \
	/weapon unlife%;/d unlife energy backstab murder

/def -mglob -t'The upper seatings' cweap21 =\
        /weapon iron light%;/d pwp pure backstab murder

/def -mglob -t'{A huge red dragon lies on a huge hoard of treasures, sleeping.}*' cweap22 = \
        /weapon slaydragon normal%;/d normal

/def -mglob -t'The Temple of Olympus' cweap23 = \
        /weapon normal%;/d backstab

/def -mglob -t'South Fountain Square' cweap24 =\
        /weapon normal%;/d normal


/def -mglob -t'Leviathan is here, looking at you with a quizzical expresion.' cweap25 = \
        /weapon unlife%;/d unlife

/def -mglob -t'You {*} The Mist with your *' cweap26 = \
        /weapon energy%;/d energy backstab murder

/def -mglob -t'An ugly orc stands here.' cweap27 =\
        /weapon slayorc fire%;/d backstab murder fire

/def -mregexp -F -t'You ([a-z]+) (Grolim warrior priest|Fanatic Grolim priest) with your ([^ ]*)' cweap28 =\
	/weapon iron light%;/d pwp pure backstab murder

/def -mregexp -F -t'You ([a-z]+) Grolim high priest with your ([^ ]*)' cweap29 =\
	/weapon energy%;/d energy backstab murder ice

/def -mregexp -F -t'^You ([a-z]+) An Elven waywatcher with ([^ ]*)' cweap30= \
	 /weapon unlife dark iron%;/d unlife energy ice

/def -mregexp -F -t'^You ([a-z]+) (An Ofcol mercenary|A Brettonian Guard|A lieutenant of the Brettonian High Command\
|A captain of the Brettonian High Command) with your ([^ ]*).' cweap31=\
	/weapon unlife dark iron%;/d energy backstab murder ice 

/def -mregexp -F -t'^The den of the Black Dragon' cweap32 = \
	/weapon slaydragon ice%;/d ice energy unlife

/def -mregexp -F -t'^You ([a-z]+) (The beast|The monster|A big guard) with your ([^ ]*)' cweap33 =\
	/weapon fire%;/d fire backstab murder

/def -mregexp -F -t'^You ([a-z]+) The Gatekeeper of Myrridon with your ([^ ]*)' cweap34 = \
        /weapon%;/d energy normal

/def -mregexp -F -t'^You ([a-z]+) The Lord of Sundhaven with your ([^ ]*)' cweap35 = \
	/weapon fire%;/d fire


/def -mregexp -F -t'^You ([a-z]+) A hydra with twelve heads with ([^ ]*)' cweap36 =\
        /weapon%;/d energy backstab murder normal

/def -mregexp -F -t'^You ([a-z]+) The tarrasque with ([^ ]*)' cweap37 =\
	/weapon%;/d energy backstab murder normal

/def -mregexp -F -t'^You ([a-z]+) The Ancient Green Dragon with ([^ ]*)' cweap38 =\
	/weapon slaydragon%;/d energy normal backstab murder

/def -mregexp -F -t'^You ([a-z]+) A Fateguard with ([^ ]*)' cweap39 =\
	/weapon energy%;/d energy backstab murder

/def -mregexp -t'^You ([a-z]+) The huge redwood tree with ([^ ]*)' cweap40 = \
	/weapon acid poison fire%;/d backstab murder energy

/def -mregexp -t'^You ([a-z]+) (The mithril golem|The laen golem) with ([^ ]*)' cweap41 = \
	/weapon normal%;/d backstab murder

/def -mregexp -t'Korr, the Overlord of Chaos stands here grinning wickedly.\
|A Chaos Knight Sergeant stands here pondering the boulders situation' cweap42 = \
	/weapon%;/d normal

/def -mregexp -F -t'^You ([a-z]+) A lugroki prisoner with ([^ ]*)' cweap43 = \
	/weapon unlife dark iron%;/d backstab murder energy ice

/def -mregexp -F -t'^You ([a-z]+) The Draconian with your ([^ ]*)' cweap44 = \
	/weapon unlife magical%;/d unlife energy%;\

/def -mregexp -F -t'^You ([a-z]+) The Bodyguard with your ([^ ]*)' cweap45 = \
	/weapon unlife magical%;/d unlife energy

/def -mregexp -F -t'^You ([a-z]+) Pred Yrric with your ([^ ]*)' cweap46 = \
	/weapon%;/d backstab murder

/def -mregexp -F -t'^You ([a-z]+) A Prison guard with your ([^ ]*)' cweap47 = \
	/weapon stun superlarge%;/d backstab murder

/def -mregexp -F -t'^You ([a-z]+) A huge, ancient tree with your ([^ ]*)' cweap48 =\
	/weapon acid%;/d backstab murder energy fire

/def -mregexp -F -t'^You ([a-z]+) A Champion of Alterac with your ([^ ]*)' cweap49 =\
	/weapon fire fireslash%;/d lordfire fire

/def -F -mregexp -t'The Grand Hallway.' cweap50 =\
	/weapon unlife dark iron%;/d unlife energy

/def -F -mregexp -t'Kings Road' cweap51 =\
	/weapon%;/d normal pwp backstab murder

/def -F -mregexp -t'Entrance to the King\'s Castle' cweap52 =\
	/weapon%;/d normal pwpw backstab murder

/def -F -mglob -t'You feel a sensation as you travel through the essence flows.' cweap53 = \
	/weapon%;/d normal backstab murder


/def -mregexp -t'You ([^ ]+) (The greater skorn|The skorn) with ([^ ]*)' cweap54 = \
	/weapon fire%;/d fire backstab murder

