/def -q -p9999999 -F -mregexp -t'^You feel informed\:' SpawnIdentTrigger = \
	/set IdentingProgress=1%;\
	/set IdentTriggersAc=0%;\
	/set IdentTriggersAffects= %;\
        /set IdentTriggersDamDice=0%;\
        /set IdentTriggersDamType=None

;;;;;;;;;;
/def -q -p9999999 -F -mregexp -t"^Object \'(.*)\'\, Item type\: ([^\']*)\, Worn\: ([^\']*)" NameTypeWornIdentTriggers = \
        /if (%{IdentingProgress}=1)%;\
                /set IdentTriggersName=%{P1}%;\
                /set IdentTriggersType=%{P2}%;\
                /set IdentTriggersWorn=%{P3}%;\
        /endif
;;;;;;;;;;
/def -q -p9999999 -F -mregexp -t"^Short Description\: (.*)" ShortDescIdentTriggers = \
        /if (%{IdentingProgress}=1)%;\
                /set IdentTriggersShortDesc=%{P1}%;\
        /endif
;;;;;;;;;;
/def -q -p9999999 -F -mregexp -t'^([ ]+)(Magician|Priest|Rogue|Fighter|Warlock|Animist|Nightblade|Templar)\: (-|[0-9]+)' LvlsIdentTriggers = \
	/if (%{IdentingProgress}=1)%;\
		/if (%{P2}=~"Magician") /set IdentTriggersMage=%{P3}%;\
		/elseif (%{P2}=~"Priest") /set IdentTriggersPriest=%{P3}%;\
		/elseif (%{P2}=~"Rogue") /set IdentTriggersRogue=%{P3}%;\
		/elseif (%{P2}=~"Fighter") /set IdentTriggersFighter=%{P3}%;\
		/elseif (%{P2}=~"Warlock") /set IdentTriggersWarlock=%{P3}%;\
		/elseif (%{P2}=~"Animist") /set IdentTriggersAnimist=%{P3}%;\
		/elseif (%{P2}=~"Nightblade") /set IdentTriggersNightblade=%{P3}%;\
		/elseif (%{P2}=~"Templar") /set IdentTriggersTemplar=%{P3}%;\
		/endif%;\
	/endif
;;;;;;;;;;
/def -q -p9999999 -F -mregexp -t'^Item is\: ([^\']*)$' BitsIdentTriggers = \
        /if (%{IdentingProgress}=1)%;\
		/idrembits de %{P1}%;\
	/endif

/def -i idrembits = \
    /let _word=%1%;\
    /let _result=%;\
    /while (shift(), {#}) \
        /if (('BLESS' !~ {1})&('INVISIBLE' !~ {1})&('FORGED' !~ {1})&('DONATED' !~ {1})&('LOADED' !~ {1})) \
            /let _result=%{_result} %{1}%;\
        /endif%;\
    /done%;\
	/if ((%{_result}=~'')|(%{_result}=~' ')) /set IdentTriggersBits=NOBITS%;\
	/else /set IdentTriggersBits=%{_result}%;\
	/endif


;;;;;;;;;;
/def -q -p9999999 -F -mregexp -t'^Weight\: ([0-9\. ]+ lbs)\, Value\: ([^ ]*)' WeightValueIdentTriggers = \
        /if (%{IdentingProgress}=1)%;\
		/set IdentTriggersWeight=%{P1}%;\
        	/set IdentTriggersValue=%{P2}%;\
	/endif
;;;;;;;;;;
/def -q -p9999999 -F -mregexp -t'^Damage Dice is \'([^\']*)\'' DamDiceIdentTriggers = \
        /if (%{IdentingProgress}=1)%;\
	        /set IdentTriggersDamDice=%{P1}%;\
	/endif
/def -q -p9999999 -F -mregexp -t'^Damage type is ([^\']*) \(([^\']*) \)' DamTypeIdentTriggers = \
        /if (%{IdentingProgress}=1)%;\
        	/set IdentTriggersDamType=%{P1} %{P2}%;\
	/endif
;;;;;;;;;;
/def -q -p9999999 -F -mregexp -t'^AC-apply is ([^\']*)' AcIdentTriggers = \
        /if (%{IdentingProgress}=1)%;\
        	/set IdentTriggersAc=%{P1}%;\
	/endif
;;;;;;;;;;
/def -q -p9999999 -F -mregexp -t'^    Affects( |): ([^\']*)' AffectsIdentTriggers = \
        /if (%{IdentingProgress}=1)%;\
	        /if (%{IdentTriggersAffects}!~'') /set IdentTriggersAffects=%{IdentTriggersAffects}\@%{P2}%;\
		/else /set IdentTriggersAffects=%{P2}%;\
		/endif%;\
	/endif

/def -q -p9999999 -F -mregexp -t'^Level ([0-9]+) spells of:' SpellAffectsIdentTriggers = \
        /set IdentTriggersAffects=\(Lvl %{P1}\) %{IdentTriggersAffects}%;\
	/def -q -p9999999 -F -mregexp -t'^([^\\']*)$$' IdentTriggersSpellAffections = \
		/if (%%{*}=~'a scroll of identify dissolves.') /purge IdentTriggersSpellAffections%%;/break%%;/endif%%;\
                /if (%%{*}=~'Can affect you as :') /purge IdentTriggersSpellAffections%%;/break%%;/endif%%;\
                /if (%%{IdentTriggersAffects}!~'') \
			/set IdentTriggersAffects=%%{IdentTriggersAffects}\@%%{*}%%;\
                /else \
			/set IdentTriggersAffects=%%{*}%%;\
	        /endif

/def -q -p9999999 -F -mregexp -t'^Item has magical abilities:$' SpellAffectsIdentTriggers2 = \
        /def -q -p9999999 -F -mregexp -t'^([^\\']*)$$' IdentTriggersSpellAffections2 = \
                /if (%%{*}=~'a scroll of identify dissolves.') /purge IdentTriggersSpellAffections2%%;/break%%;/endif%%;\
                /if (%%{IdentTriggersAffects}!~'') \
                        /set IdentTriggersAffects=%%{IdentTriggersAffects}\@%%{*}%%;\
                /else \
                        /set IdentTriggersAffects=%%{*}%%;\
                /endif

/def -q -p9999999 -F -mregexp -t'^Has ([0-9]+) charges, with ([0-9]+) charges left.' SpellAffectsIdentTriggers3x = \
        /set IdentTriggerWandStaffAffects=%{P1}
 
/def -q -p9999999 -F -mregexp -t'^Level ([0-9]+) spell of:' SpellAffectsIdentTriggers3 = \
        /set IdentTriggersAffects=\(Lvl %{P1}\) %{IdentTriggerWandStaffAffects} charges of %{IdentTriggersAffects}%;\
        /set IdentTriggerWandStaffAffects=%;\
        /def -q -p9999999 -F -mregexp -t'^([^\\']*)$$' IdentTriggersSpellAffections3 = \
                /if (%%{*}=~'a scroll of identify dissolves.') /purge IdentTriggersSpellAffections3%%;/break%%;/endif%%;\
                /if (%%{*}=~'Can affect you as :') /purge IdentTriggersSpellAffections3%%;/break%%;/endif%%;\
                /if (%%{IdentTriggersAffects}!~'') \
                        /set IdentTriggersAffects=%%{IdentTriggersAffects}\@%%{*}%%;\
                /else \
                        /set IdentTriggersAffects=%%{*}%%;\
                /endif

;;;;;;;;;;
/def -q -p19999999 -F -mregexp -t'^([0-9]+)\(([0-9]+)\)H (|-)([0-9]+)\(([0-9]+)\)M ([0-9]+)\(([0-9]+)\)V >' PrtIdentTrigger = \
	/purge IdentTriggersSpellAffections%;\
        /purge IdentTriggersSpellAffections2%;\
	/purge IdentTriggersSpellsAffections3%;\
        /if (%{IdentingProgress}=1)%;\
		/set IdentingProgress=0%;\
		/IdentTriggersWrite%;\
	/endif

/def -q -p19999999 -F -h"PROMPT *Not playing >*" PrtIdentTrigger_not = \
        /purge IdentTriggersSpellAffections%;\
        /purge IdentTriggersSpellAffections2%;\
        /purge IdentTriggersSpellAffections3%;\
        /if (%{IdentingProgress}=1)%;\
                /set IdentingProgress=0%;\
                /IdentTriggersWrite%;\
        /endif

;;;;;;;;;;
/def IdentTriggersWrite = \
/set IdentTriggersWrite=%{IdentTriggersName}\@%{IdentTriggersShortDesc}\@%{IdentTriggersType}\@%{IdentTriggersWorn}\@\
%{IdentTriggersMage}\@%{IdentTriggersPriest}\@%{IdentTriggersRogue}\@%{IdentTriggersFighter}\@%{IdentTriggersWarlock}\@\
%{IdentTriggersAnimist}\@%{IdentTriggersNightblade}\@%{IdentTriggersTemplar}\@%{IdentTriggersBits}\@%{IdentTriggersWeight}\@\
%{IdentTriggersValue}\@%{IdentTriggersDamDice}\@%{IdentTriggersDamType}\@%{IdentTriggersAc}\@%{IdentTriggersAffects}%;\
/let writedir=%{uzidirectory}/addons/id.items%;\
/set IdentTriggersWriteState=$[fwrite({writedir},{IdentTriggersWrite})]%;\
/if ({IdentTriggersWriteState}=1) /ecko Write sucessful.%;/undupeid1%;\
/else /ecko ERROR %{IdentTriggersWrite} ERROR!!!%;/endif

/def unloadident = /purge *IdentTrigger*%;/purge unloadident
	
/def undupeid1 = \
	/sys sort %{uzidirectory}/addons/id.items > id.temp%;\
	/sys uniq id.temp > %{uzidirectory}/addons/id.items%;\
	/sys rm id.temp

/def undupeid = \
	/idbackup %*%;\
	/sys sort %{uzidirectory}/addons/id.items > id.temp%;\
	/sys uniq id.temp > %{uzidirectory}/addons/id.items%;\
	/sys rm id.temp%;\
        /if ({1} =~ '') \
	  /ecko Removing dupeidents from id.items!%;\
        /endif

/def idbackup = \
        /if ({1} =~ '') \
  	  /ecko Backing up idents to id.backup\-$[ftime("%y%m%d_%H:%M:%S",time())] from id.items%;\
        /endif%;\
	/eval /sys cp %{uzidirectory}/addons/id.items %{uzidirectory}/addons/id.backup\-$[ftime("%y%m%d_%H:%M:%S",time())]

/def idreset = \
	/set IdentTriggersWrite=%;\
	/set IdentTriggersName=%;\
	/set IdentTriggersShortDesc=%;\
	/set IdentTriggersType=%;\
	/set IdentTriggersWorn=%;\
	/set IdentTriggersMage=%;\
	/set IdentTriggersPriest=%;\
	/set IdentTriggersRogue=%;\
	/set IdentTriggersFighter=%;\
	/set IdentTriggersWarlock=%;\
	/set IdentTriggersAnimist=%;\
	/set IdentTriggersNightblade=%;\
	/set IdentTriggersTemplar=%;\
	/set IdentTriggersBits=%;\
	/set IdentTriggersWeight=%;\
	/set IdentTriggersValue=%;\
	/set IdentTriggersDamDice=%;\
	/set IdentTriggersDamType=%;\
	/set IdentTriggersAc=%;\
	/set IdentTriggersAffects=%;\

/def IDeq = \
	/set IDparsed=0%;\
	/quote -S /IdentTriggersParser !grep -i \"%{*}\" %{uzidirectory}/addons/id.items%;\
	/if (%{IDparsed}=0) \
	/IDecko ***-*--*---*----*-----*--- -  -   -     -       -       -%;\
	/IDecko No eq found matching \'@{Ccyan}%{*}@{Cgreen}\'%;\
	/endif

/def IdentTriggersParser = \
	/set IDparsed=1%;\
	/idreset%;\
	/let OrgString=%{*}%;\
	/set Identlabel=0%;\
	/let CurrentPos=$[strchr(%{OrgString},"@")]%;\
        /let CurrentString=$[substr(%{OrgString},"0",%{CurrentPos})]%;\
        /set IdentTriggersName=%{CurrentString}%;\
        /while (%{CurrentPos}>0) \
		/set Identlabel=$[{Identlabel} + 1]%;\
        	/let OrgString=$[substr(%{OrgString},$[CurrentPos + 1])]%;\
	        /let CurrentPos=$[strchr(%{OrgString},"@")]%;\
        	/let CurrentString=$[substr(%{OrgString},"0",%{CurrentPos})]%;\
		/if (Identlabel=1) /set IdentTriggersShortDesc=%{CurrentString}%;\
		/elseif (Identlabel=2) /set IdentTriggersType=%{CurrentString}%;\
		/elseif (Identlabel=3) /set IdentTriggersWorn=%{CurrentString}%;\
		/elseif (Identlabel=4) /set IdentTriggersMage=%{CurrentString}%;\
		/elseif (Identlabel=5) /set IdentTriggersPriest=%{CurrentString}%;\
		/elseif (Identlabel=6) /set IdentTriggersRogue=%{CurrentString}%;\
		/elseif (Identlabel=7) /set IdentTriggersFighter=%{CurrentString}%;\
		/elseif (Identlabel=8) /set IdentTriggersWarlock=%{CurrentString}%;\
		/elseif (Identlabel=9) /set IdentTriggersAnimist=%{CurrentString}%;\
		/elseif (Identlabel=10) /set IdentTriggersNightblade=%{CurrentString}%;\
		/elseif (Identlabel=11) /set IdentTriggersTemplar=%{CurrentString}%;\
		/elseif (Identlabel=12) /set IdentTriggersBits=%{CurrentString}%;\
		/elseif (Identlabel=13) /set IdentTriggersWeight=%{CurrentString}%;\
		/elseif (Identlabel=14) /set IdentTriggersValue=%{CurrentString}%;\
		/elseif (Identlabel=15) /set IdentTriggersDamDice=%{CurrentString}%;\
		/elseif (Identlabel=16) /set IdentTriggersDamType=%{CurrentString}%;\
		/elseif (Identlabel=17) /set IdentTriggersAc=%{CurrentString}%;\
		/elseif (Identlabel=18) /break%;\
		/endif%;\
        /done%;\
	/set IdentTriggersAffects=$[replace("@",", ",%{OrgString})]%;\
/IDecko ***-*--*---*----*-----*--- -  -   -     -       -       -%;\
/IDecko Name:@{Cyellow} %{IdentTriggersName}@{Ccyan}\,@{Cyellow} %{IdentTriggersType}@{Ccyan}\,@{Cyellow} %{IdentTriggersWorn}%;\
/IDecko Short Description:@{Cyellow} %{IdentTriggersShortDesc}%;\
/IDecko Levels;@{Ccyan} Ma:@{Cyellow} %{IdentTriggersMage}@{Ccyan}\, Pr:@{Cyellow} %{IdentTriggersPriest}@{Ccyan}\, Ro:@{Cyellow} %{IdentTriggersRogue}@{Ccyan}\, \
Fi:@{Cyellow} %{IdentTriggersFighter}@{Ccyan}\, Wl:@{Cyellow} %{IdentTriggersWarlock}@{Ccyan}\, An:@{Cyellow} %{IdentTriggersAnimist}@{Ccyan}\, \
Nb:@{Cyellow} %{IdentTriggersNightblade}@{Ccyan}\, Te:@{Cyellow} %{IdentTriggersTemplar}%;\
/IDecko Bits:@{Cyellow} %{IdentTriggersBits}@{Ccyan}\, Weight:@{Cyellow} %{IdentTriggersWeight}@{Ccyan}\, Value:@{Cyellow} %{IdentTriggersValue}@{Ccyan}%;\
/IDecko @{Cblack}.      @{Ccyan}Damage:@{Cyellow} %{IdentTriggersDamDice}@{Ccyan}\,@{Cyellow} %{IdentTriggersDamType}@{Ccyan}\, Ac:@{Cyellow} %{IdentTriggersAc}%;\
/IDecko Affects:@{Cyellow} %{IdentTriggersAffects}

/def showid = \
	/set IdentTriggersAffects=$[replace("@",", ",%{IdentTriggersAffects})]%;\
/send %{*} &+gName:&+y %{IdentTriggersName}\, %{IdentTriggersType}\, %{IdentTriggersWorn}%;\
/send %{*} &+gShort Description:&+y %{IdentTriggersShortDesc}%;\
/send %{*} &+gLevels;&+c Ma:&+y %{IdentTriggersMage}&+c\, Pr:&+y %{IdentTriggersPriest}&+c\, Ro:&+y %{IdentTriggersRogue}&+c\, \
 Fi:&+y %{IdentTriggersFighter}&+c\, Wl:&+y %{IdentTriggersWarlock}&+c\, An:&+y %{IdentTriggersAnimist}&+c\, \
 Nb:&+y %{IdentTriggersNightblade}&+c\, Te:&+y %{IdentTriggersTemplar}%;\
/send %{*} &+gBits:&+y %{IdentTriggersBits}&+c\, Weight:&+y %{IdentTriggersWeight}&+c\, Value:&+y %{IdentTriggersValue}&+c%;\
/send %{*} &+b      &+cDamDice:&+y %{IdentTriggersDamDice}&+c\, DamType:&+y %{IdentTriggersDamType}&+c\, Ac:&+y %{IdentTriggersAc}%;\
/if (%{IdentTriggersAffects} !~ '') /send %{*} &+gAffects:&+y %{IdentTriggersAffects}%;/endif

/def IDecko = /echo -aCred -p >>* @{Cgreen}%{*}

/def idhelp = \
/IDecko ***-*--*---*----*-----*--- -  -   -     -       -       -%;\
/IDecko                 IdentInfo Database Help%;\
/IDecko      Commands:%;\
/IDecko           /eq [string to find] <--- finds eq%;\
/IDecko           /showid [command]    <--- display last item found with /eq%;\
/IDecko           /idbackup            <--- backup current id.items file%;\
/IDecko           /undupeid            <--- remove duped entries from id.items%;\
/IDecko           /unloadident         <--- unloads the script

/def eq = \
	/if (%{*} !~ '') \
        /set IDparsed=0%;\
	/sys cp %{uzidirectory}/addons/id.items %{uzidirectory}/addons/id.search%;\
	/IDecko Searchin for: %{*}%;\
	/while ({#}) \
		/sys grep -i '%{1}' %{uzidirectory}/addons/id.search > id.temp%;\
		/sys mv id.temp %{uzidirectory}/addons/id.search%;\
		/shift%;\
	/done%;\
        /quote -S /IdentTriggersParser !cat %{uzidirectory}/addons/id.search%;\
	/if (%{IDparsed}=0) \
        	/IDecko ***-*--*---*----*-----*--- -  -   -     -       -       -%;\
	        /IDecko No eq found matching \'@{Ccyan}%{*}@{Cgreen}\'%;\
	/else \
		/IDecko ***-*--*---*----*-----*--- -  -   -     -       -       -%;\
		/IDecko *** End of search%;\
        /endif%;\
	/sys rm %{uzidirectory}/addons/id.search%;\
	/else /IDecko Error - syntax: /eq <string/s to find>%;\
	/endif

/def -p1 -mregexp -t'^([^ ]+) tells you \'findeq: ([^\']*)\'' IDtelldofind = \
	/set IDtellsearchtarget=%{P1}%;\
	/set IDtellsearchstring=%{P2}%;\
	/quote -S /IDtellisfind !ls %{uzidirectory}/addons/id.search

/def IDtellisfind = \
	/if (%{*} !='ls: *id.search: No such file or directory') \
          tell %{IDtellsearchtarget} Sorry, search in progress, try again in a few seconds.%;\
	/else \
          /IDtellfind %{IDtellsearchstring}%;\
	/endif

/def IDtellfind = \
	/sys cp %{uzidirectory}/addons/id.items %{uzidirectory}/addons/id.search%;\
        /while ({#}) \
                /sys grep -i '%{1}' %{uzidirectory}/addons/id.search > %{uzidirectory}/addons/id.temp%;\
                /sys mv %{uzidirectory}/addons/id.temp %{uzidirectory}/addons/id.search%;\
                /shift%;\
        /done%;\
        /quote -S /IdentTellTriggerssearched !grep -cv '0xE0xA0x0Gx0x0xfsckYad' %{uzidirectory}/addons/id.search
	
/def IdentTellTriggerssearched = \
	/if (%{*}=1) /quote -S /IdentTellTriggersParser !cat %{uzidirectory}/addons/id.search%;\
	/elseif (%{*}=0) tell %{IDtellsearchtarget} No such items found!%;/sys rm %{uzidirectory}/addons/id.search%;\
 	/elseif ((%{*}>1)&(%{*}<6)) tell %{IDtellsearchtarget} Multiple items found; displaying names only... tell me "findeq: name" to see stats%;/quote -S /IdentTellTriggersParserName !cat %{uzidirectory}/addons/id.search%;\
	/elseif (%{*}>6) tell %{IDtellsearchtarget} Too many items found. Request ignored. Try to use a more exact match%;\
	/endif%;\
;        /sys rm %{uzidirectory}/addons/id.search
	

/def IdentTellTriggersParser = \
        /idreset%;\
        /let OrgString=%{*}%;\
        /set Identlabel=0%;\
        /let CurrentPos=$[strchr(%{OrgString},"@")]%;\
        /let CurrentString=$[substr(%{OrgString},"0",%{CurrentPos})]%;\
        /set IdentTriggersName=%{CurrentString}%;\
        /while (%{CurrentPos}>0) \
                /set Identlabel=$[{Identlabel} + 1]%;\
                /let OrgString=$[substr(%{OrgString},$[CurrentPos + 1])]%;\
                /let CurrentPos=$[strchr(%{OrgString},"@")]%;\
                /let CurrentString=$[substr(%{OrgString},"0",%{CurrentPos})]%;\
                /if (Identlabel=1) /set IdentTriggersShortDesc=%{CurrentString}%;\
                /elseif (Identlabel=2) /set IdentTriggersType=%{CurrentString}%;\
                /elseif (Identlabel=3) /set IdentTriggersWorn=%{CurrentString}%;\
                /elseif (Identlabel=4) /set IdentTriggersMage=%{CurrentString}%;\
                /elseif (Identlabel=5) /set IdentTriggersPriest=%{CurrentString}%;\
                /elseif (Identlabel=6) /set IdentTriggersRogue=%{CurrentString}%;\
                /elseif (Identlabel=7) /set IdentTriggersFighter=%{CurrentString}%;\
                /elseif (Identlabel=8) /set IdentTriggersWarlock=%{CurrentString}%;\
                /elseif (Identlabel=9) /set IdentTriggersAnimist=%{CurrentString}%;\
                /elseif (Identlabel=10) /set IdentTriggersNightblade=%{CurrentString}%;\
                /elseif (Identlabel=11) /set IdentTriggersTemplar=%{CurrentString}%;\
                /elseif (Identlabel=12) /set IdentTriggersBits=%{CurrentString}%;\
                /elseif (Identlabel=13) /set IdentTriggersWeight=%{CurrentString}%;\
                /elseif (Identlabel=14) /set IdentTriggersValue=%{CurrentString}%;\
                /elseif (Identlabel=15) /set IdentTriggersDamDice=%{CurrentString}%;\
                /elseif (Identlabel=16) /set IdentTriggersDamType=%{CurrentString}%;\
                /elseif (Identlabel=17) /set IdentTriggersAc=%{CurrentString}%;\
                /elseif (Identlabel=18) /break%;\
                /endif%;\
        /done%;\
	/sys rm %{uzidirectory}/addons/id.search%;\
        /set IdentTriggersAffects=$[replace("@",", ",%{OrgString})]%;\
        /send tell %{IDtellsearchtarget} &+gName:&+y %{IdentTriggersName}\, %{IdentTriggersType}\, %{IdentTriggersWorn}%;\
	/send tell %{IDtellsearchtarget} &+gShort Description:&+y %{IdentTriggersShortDesc}%;\
        /send tell %{IDtellsearchtarget} &+gLevels;&+c Ma:&+y %{IdentTriggersMage}&+c\, Pr:&+y %{IdentTriggersPriest}&+c\, Ro:&+y %{IdentTriggersRogue}&+c\, \
         Fi:&+y %{IdentTriggersFighter}&+c\, Wl:&+y %{IdentTriggersWarlock}&+c\, An:&+y %{IdentTriggersAnimist}&+c\, \
         Nb:&+y %{IdentTriggersNightblade}&+c\, Te:&+y %{IdentTriggersTemplar}%;\
        /send tell %{IDtellsearchtarget} &+gBits:&+y %{IdentTriggersBits}&+c\, Weight:&+y %{IdentTriggersWeight}&+c\, Value:&+y %{IdentTriggersValue}&+c%;\
        /send tell %{IDtellsearchtarget} &+b       &+cDamDice:&+y %{IdentTriggersDamDice}&+c\, DamType:&+y %{IdentTriggersDamType}&+c\, Ac:&+y %{IdentTriggersAc}%;\
        /if (%{IdentTriggersAffects} !~ '') /send tell %{IDtellsearchtarget} &+gAffects:&+y %{IdentTriggersAffects}%;/endif

/def IdentTellTriggersParserName = \
        /idreset%;\
        /let OrgString=%{*}%;\
        /set Identlabel=0%;\
        /let CurrentPos=$[strchr(%{OrgString},"@")]%;\
        /let CurrentString=$[substr(%{OrgString},"0",%{CurrentPos})]%;\
        /send tell %{IDtellsearchtarget} &+gName:&+y %{CurrentString}%;\
