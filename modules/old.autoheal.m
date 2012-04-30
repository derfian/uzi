;=============================
;   Basic Autoheal Script
;=============================

;;;Fix variables by default.
/lood modules/autohealvalues.m

;;;Group Thingie
/def gg = \
    /if (sentgroup=0 & aheal=1) \
;      /ecko Group %{groupinterval}%;\
      /debug GROUP tickison=%tickison groupass=%groupass%;\
      group %{groupinterval}%;\
      /set sentgroup=1%;\
    /else \
;     /repeat -0:00:02 1 /gg%;\
;     /ecko Not sending group (already sent?)%;\
    /endif

;;;Main Script
/def status= \
    /if (priest>1 | templar>1) \
      /if (aheal=1) \
	/if (miratank=1) \
	  /set st1=mhp: %{atmhp}\% %;\
        /else \
          /set st1=mhp: off %;\
        /endif%;\
	/if (truetank=1) \
	  /set st1=%{st1} thp: %{atthp}\% %;\
        /elseif (priest>1) \
          /set st1=%{st1} thp: off %;\
        /endif%;\
        /if (truegroup=1) \
	  /set st1=%{st1} ghp: %{atghp}\% %;\
        /elseif (priest>1) \
          /set st1=%{st1} ghp: off %;\
        /endif%;\
	/if (gpowgroup=1) \
	  /set st1=%{st1} gphp: %{atgphp}\%(%{maxgpowcount}) %;\
        /elseif (priest>1) \
          /set st1=%{st1} gphp: off %;\
        /endif%;\
      /else \
        /set st1=all autohealing is disabled.%;\
      /endif%;\
      gtf , is set to, 'Tank: %{tank}, %{st1}' (uzi %uziversion)%;\
    /endif

/def th=/set thresh %{1}%;/ecko Thresh: %{htxt2}%{1}

/def hstate=\
	/if (miratank=1) /set atmira%; /endif%; \
	/set thresh

/def mhp=/set atmhp=%1%;/ecko Miracling %{tank} at %{atmhp}.
/def thp=/set atthp=%1%;/ecko Truehealing %{tank} at %{atthp}.
/def ghp=/set atghp=%1%;/ecko Truehealing Group at %{atghp}.
/def gphp=/set atgphp=%1%;/ecko Grouppowerheal at %{atmhp}.


/def wildmagic=/set miratank=0%;/set truetank=0%;/set truegroup=0%;/set autogpow=1%;/echo -aBCred Now using GPOWS forhealing ONLY! No singletarget spells
/def area=/wildmagic
/def single=/set miratank=1%:/set truetank=1%;/set truegroup=1%;/set autogpow=1%;/echo -aBCred Now using singletarget spells again!
/def noarea=/single
/def gh=/status
/def gth=/status

/def -mregexp -t'^([A-Za-z]+) tells you \'mhp ([0-9]+)\'' cmhp = \
     /if (priest>1 & {P1}=~tank) \
        /mhp %{P2}%; /status%;\
     /endif

/def -mregexp -t'^([A-Za-z]+) tells you \'thp ([0-9]+)\'' cthp = \
     /if ((priest>1 | templar>1) & {P1}=~tank) \
        /thp %{P2}%; /status%;\
     /endif

/def -F -q -mregexp -t'^([A-Za-z]+) tells you \'gphp ([0-9]+)\'' cgphp = \
     /if ((priest>1 | templar>1) & {P1}=~tank) \
        /gphp %{P2}%; /status%;\
     /endif
/def -F -q -mregexp -t'^([A-Za-z]+) tells you \'ghp ([0-9]+)\'' cghp = \
     /if (priest>1) \
        /ghp %{P2}%; /status%;\
     /endif

/def -F -mregexp -p999999 -t'^([A-Za-z]+) tells you \'(aholy|sanc|autoholy|holy)(| on| off)\'' asancself = \
  /if ({1}=~tank) \
    /if (autoholy=1) \
      /if (templar>1) \
        /set autoholy=0%;\
        /set sanctype=sanc%;\
        tell %1 Autosanc self &+RDeactivated.%;\
      /elseif (priest>0) \
        /set autoholy=0%;\
        /set sanctype=holy%;\
        tell %1 Autoholy &+RDeactived.%;\
      /endif%;\
    /else \
      /if (templar>1) \
        /set autoholy=1%;\
        /set sanctype=sanc%;\
        tell %1 Autosanc self &+GActivated.%;\
      /elseif (priest>0) \
        /set autoholy=1%;\
        /set sanctype=holy%;\
        tell %1 Autoholy &+GActivated.%;\
      /endif%;\
    /endif%;\
  /endif

/def ah = \
  /if (aheal=0) \
    /ecko Autohealing: %{htxt2}ON%; \
    /set aheal=1%; \
  /else \
    /ecko Autohealing: %{htxt2}OFF%; \
    /set aheal=0%; \
  /endif


/def autorem = /mapcar /autoperson %{gplist}
/def autoperson = /if (%{askperson}=/%1) /set remit=1%; /endif

/def bless = \
	/if (blessme=0) \
	  /set blessme=1%;\
          /if (priest>1) \
  	    /ecko You think this gang needs blessings, groupblessings coming up.%;\
  	    /set groupbless=1%;\
          /else \
            /ecko Casting bless on urself.%;\
            /set groupbless=0%;\
          /endif%;\
	/else \
	  /set blessme=0%;\
	  /ecko You will bless on request.%;\
	  /set groupbless=0%;\
	/endif

/set aregen=0
/def autoregen = \
        /if (aregen=0) \
                /set aregen=1%; \
                /echo -aCred You will regen anyone in group.%; \
        /else \
                /set aregen=0%; \
                /echo -aCred You will let them regen thierselfs.%; \
        /endif

/def -mregexp -t'[^ ] suddenly shivers slightly.' regend = \
	/if (aregen=1) \
		/set remit=0%;/set askperson=%{1}%; \
		/autorem %{askperson} %;\
		/if (remit=1) regen %{askperson}%;/set lspell= regen %{askperson}%;/endif%;\
/endif


/set arm=0
/def garm = \
	/if (arm=0) \
		/set arm=1 %; \
		    /echo -aCred You will auto Armor the group.%; \
		/alias ar garm%; \
	/else \
		/set arm=0 %; \
		    /echo -aCred You will let them cast thier own Armor spells!%; \
		/alias ar arm%; \
	/endif

/set abless=0
/def autobless = \
	/if (abless=0) \
		/set abless=1%; \
			/echo -aCred You will bless ppl when they lose they way.%; \
	/else \
		/set abless=0%; \
			/echo -aCred You don't think ppl deserve to be blessed without asking.%; \
	/endif

/set ablind=3
/def autoblind = \
        /if (ablind=0) \
                /set ablind=1%; \
                        /echo -aCred You will cure anyone who's blinded.%; \
        /else \
                /set ablind=0%; \
                        /echo -aCred You will leave those blinded to suffer.%; \
        /endif

/def -p1 -aBCred -mregexp -t'[^ ] seems to be blinded.*' blindd = \
	/if (ablind=1) \
		/set remit=0%;/set askperson=%{1}%; \
		/autorem %{askperson} %;\
		/if (remit=1) heal %{askperson}%;/set lspell= heal %{askperson}%;/endif%;\
	/elsef ((ablind=3)&({1} =/ {tank})) \
		/set remit=0%;/set askperson=%{1}%; \
		/autorem %{askperson} %;\
		/if (remit=1) heal %{askperson}%;/set lspell= heal %{askperson}%;/endif%;\
/endif

;; Wound-bleed.
/def -p1 -aBCred -mglob -t'You bleed from your wounds.' acurebleed = \
  /if (priest|templar|animist>0) \
    cast 'Cure Critic' self%;\
  /elseif (askpr!~'') \
    ask %askpr cc%;\
  /endif


/set acurse=0
/def autocurse = \
	/if (acurse=0) \
		/set acurse=1%; \
		/echo -aCred You will autocure those cursed.%; \
	/else \
		/set acurse=0%; \
		/echo -aCred You think those cursed will have to ask you.%; \
	/endif


/def -mregexp -aCbgmagenta -t'[^ ] briefly reveal a red aura!' cursd = \
	/if (acurse=1) \
		/set remit=0%;/set askperson=%{1}%; \
		/autorem %{askperson} %;\
		/if (remit=1) rc %{askperson}%;/set lspell= rc %{askperson}%;/endif%;\
/endif

/set awithered=3

/def -mregexp -aBCcyan -t'[^ ] appears brittle.' witherd = \
	/if (awithered=1) \
		/set remit=0%;/set askperson=%{1}%; \
		/autorem %{askperson} %;\
		/if (remit=1) pow %{askperson}%;/set lspell= pow %{askperson}%;/endif%;\
	/elseif ((awithered=3)&(%{1}=/{tank})) \
                /set remit=0%;/set askperson=%{1}%;\
                /autorem %{askperson}%;\
                /if (remit=1) pow %{askperson}%;/set lspell= pow %{askperson}%;/endif%;\
/endif

/def -mglob -aBCred -t'You are blind!' cureblindself = \
	/if (templar>0 | priest>0 | animist>0) \
          cast 'heal' self%;\
        /endif


;*********************** Utilities *********************;

/def -p999 -F -mglob -aCmagenta -t'You join the fight!*' joinedfdf = \
		/if (tickison=0) /set tickison=1%; gg%; /endif

/def -F -p999 -mregexp -t'assists|rushes to attack|is here, fighting|heroically rescues' assasdf4 = \
        /if (tickison=0) /set tickison=1%; gg%; /endif

/def -F -p999 -mregexp -t'No way\! You are fighting for your life' ass1asdf = \
    /if (tickison=0) /set tickison=1%; gg%; /endif


/def -p99 -F -q -mregexp -t'([^ ]*) (misses|hits|pounds|crushes|tickles|pierces|cuts|blasts|slashes\
  |massacres|obliterates|annihilates|vaporizes|pulverizes|atomizes|ultraslays\
  |\*\*\*ULTRASLAYS\*\*\*) ([^ ]*)' autoassist1asdf = \
        /set who1=%{P1}%; /set who2=%{P3}%; \
        /if (tickison=0 & aheal=1) /set tickison=1%; gg%; /endif

/set groupass=1
/set assist=1
/def -mregexp -t'No way\! You are fighting for your life' ass1 = /set groupass=0
/def -mregexp -t'([^ ]*) tells you \'gimp\'' priestmir=mira %{P1}
;/def -mregexp -F -t'You receive|Whom do you wish to assist|is not fighting anybody|and attempts to flee' ass2 = /set groupass=1

/def -mregexp -t'tells the group, \'status\'' gtstatus=/status
/def -mregexp -t'tells you \'status\'' tellonstatus=/status

/def -mregexp -t'tells you \'vis\'' leadervis = \
  /if ({1}=~leader) \
    visible%;\
  /endif

