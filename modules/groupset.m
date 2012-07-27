; -*- mode: tf -*-
;;;;;;;;;;;;;;;;;;;;;;;
;Groupset
;;;;;;;;;;;;;;;;;;;;;;

/def set_z = \
  alias z assist;

/def t = \
	/set tank=%{1}%;\
    /set leader=%{1}%;\
    /set amigrouped=1%;\
    /set leaderdied=0%;\
	/ecko Tank set to: %htxt2%{tank}\!%;\
	/set_z

/def -t'You group yourself*' set_tank0 = \
    /set tank=%{char}%;\
    /set tankhps=100%;\
	/set_z

/def -mregexp -t'^You are now a member of ([^ ^\']*)\'s group.' set_tank= \
        /if ({P1}!~{tank}) \
          group%;\
        /endif%;\
        /t %{P1}

/def -mregexp -t'^The leader is now ([^ ]*).' set_tank2= \
        /t %{P1}%;\
        group

/def -F -p2 -aB -t'You have been ditched*' endg2 = \
        /set amigrouped=0%;\
        /set gplist= %;\
        /set gpsize=1%;\
        /if (recallwhenungrouped=1) \
          tele%;\
        /endif

/def -F -p2 -aB -aCmagenta -t'*But you are not the member of a group!*' endgroup = \
        /set amigrouped=0%;\
        /set gplist=%;\
        /set gpsize=1

/def -Fq -p2 -aB -aCmagenta -mglob -t'*tells the group, \'Group is now disbanded!*' endgroup1 = \
        /if ({1}=/{tank}) \
          /set amigrouped=0%;\
          /set gplist= %;\
          /set gpsize=1%;\
          /set tank=-%;\
          /if (recallwhenungrouped=1) \
            tele%;\
          /endif%;\
        /endif

/def -q -mregexp -t'is now a member of ([^ ]*)\'s group.' set_tank1= \
	/if ({P1}=/{tank}) \
          /set gplist=%{gplist} %{1}%;\
          /set gplist=$(/unique %{gplist})%;\
	/endif

/def -mglob -t'You are the new leader\!' new_leader1 = \
    /set leading=1%;\
    /t %{char}%;\
   /beep

/def -mglob -t'{*} is the new leader\!' newleader2 = \
    /if (leaderdied=1) \
      /t %{1}%;\
    /endif
   

;;;;;;;;;;;;;;;;;;;;;
;Position Functions ;
;;;;;;;;;;;;;;;;;;;;;

/set position=stand

/def onstand = \
  /resetdamage%;\
  /if (summonqueue !~ '') \
    /summonqueue%;\
  /endif

/def summonqueue = \
    /alias summononstand cast 'summon' 0.%%*%;\
    /mapcar summononstand %summonqueue%;\
    /unalias summononstand%;\
    /set summonqueue=

/def -p3 -mglob -t'*tells you \'corpse\'*'  = di%;cr

/def -p1 -mglob -t'{*} tells the group, \'ps\'' ps1= ps
/def -p1 -mglob -t'{*} tells the group, \'wake\'' com1=/if ({1}=/{leader} | {1}=~'someone') wake%;/endif
/def -p1 -mglob -t'{*} tells the group, \'stand\'' com2=/if ({1}=/{leader} | {1}=~'someone') wake%;stand%;/endif
/def -p1 -mglob -t'{*} tells the group, \'sleep\'' com3=/if ({1}=/{leader}) sleep%;/endif
/def -p1 -mglob -t'{*} tells the group, \'rest\'' com4=/if ({1}=/{leader}) rest%;/endif
/def -p1 -mglob -t'{*} tells the group, \'sit\'' com5=/if ({1}=/{leader}) sit%;/endif

/def -p1 -F -mglob -t'You sit down and rest your tired bones.' restspell1=aff%;/set position=rest
/def -p1 -F -mglob -t'You go to sleep.' sleepspell1=aff%;/set position=sleep

/def -p1 -F -mglob -t'You stop resting, and stand up.' restspell2=\
	/if (standtocast != 1) \
	  /aftertick%;\
	  /set position=stand%;\
	  /onstand%;\
	/else \
	  /set standtocast=0%;\
	/endif

/def -p1 -F -mglob -t'You wake, and stand up.' restspell7=\
	/if (standtocast != 1) \
	  /aftertick%;\
	  /set position=stand%;\
	  /onstand%;\
	/else \
	  /set standtocast=0%;\
	/endif

/def -p1 -F -mglob -t'You sit down.' restspell3=aff%;/set position=sit
/def -p1 -F -mglob -t'You rest your tired bones.' restspell4=/set position=rest
/def -p1 -F -mglob -t'You stop resting, and sit up.' restspell5=/set position=sit
/def -p1 -F -mglob -t'You stand up.' restspell6=/set position=stand%;/onstand
/def -p1 -F -mglob -t'You are already awake...' restspell8=/set position=stand

/def -F -mregexp -t"^([A-z]+) tells .* 'build ([A-z]+)'" buildoutpost = \
  /if ((%{P1} =~ %leader) & fighter>0) \
    build %P2%;\
  /endif

;;; dd cop ;;;
/def -F -mregexp -t"^([A-z]+) tells .* 'dd cop ([A-z]+)'" ddcop = \
  /if ((%{P1} =~ %leader) & magician>0) \
    /set ddcoping=1%;\
    cast 'dimension door' %{P2}%;\
  /endif

/def -aBCmagenta -mregexp -t'You wait in vain as no dimension door appears.' ddvain = \
         /if (%{ddcoping}=1) \
                 gt Can't create dimension door. Target might be in safe.%;\
                 /set ddcoping=0%;\
         /endif


/def -F -mregexp -t'You open a door into another dimension and quickly step through it.' dddone = \
        /if (%{ddcoping}=1) \
          cast 'circle of protection'%;\
        /endif


/def -F -p12345 -mregexp -t'The ground gets covered with ancient runes of protection.' ddcop_done = \
        /if (%{ddcoping}=1) \
          gtf , has marked the spot with some runes.%;\
          /set ddcoping=0%;\
        /endif

/def -aBCmagenta -mregexp -t'You fail to inscribe new runes of protection.' ddcop_fail = \
        /if (%{ddcoping}=1) \
          gtf , has FAILED to mark the spot.%;\
          /set ddcoping=0%;\
        /endif

/def -F -p123456 -mregexp -t'You cant seem to do that here\!' ddcop_nomag = \
         /if (%{ddcoping}=1) \
                 gt Can't create dimension door. I'm possibly in NOMAG.%;\
                 /set ddcoping=0%;\
         /endif


/def -aBCmagenta -mregexp -t"([A-z]+)\'s godly aura resists your dimension door." ddcop_gods = \
        /if (%{ddcoping}=1) \
          /eval gt You can\'t dimension door to the immortals!%;\
          /set ddcoping=0%;\
        /endif


;;; Holy gater ;;;
/def -aBCmagenta -mregexp -t'([^ ]*) tells you \'gate ([^ ]*)\'' priestgate= \
         /if ((%{leader}=/%{P1})|(%{tank}=/%{P1})) \
                 /set castedholygate=1%;\
                 cast 'holy gate' %{P2}%;\
         /endif

/def -aBCmagenta -mregexp -t'You wait in vain as no dimension portal appears.' holygatevain = \
         /if (%{castedholygate}=1) \
                 gt Can't establish gate.%;\
                 /set castedholygate=0%;\
         /endif

/def -aBCmagenta -mregexp -t'You create a red field of energy.' holygatedone = \
	/set castedholygate=0%;\
	gtf , has created a nice field.

/def -aBCmagenta -mregexp -t'You can\'t concentrate enough to create a new portal\.' holygatecant = \
         /if (%{castedholygate}=1) \
                 gtf , can't create any more fields at this moment.%;\
                 /set castedholygate=0%;\
         /endif

/def -p1 -F -mregexp -t"^([A-z]+) tells .* '(D|d)(RINK WELL|rink well)'" drinkwell = \
  /if (%{P1} =~ %leader) \
    drink well%;\
  /endif

/def -p1 -F -mregexp -t"^([A-z]+) tells .* '(E|e)(NTER TREE|nter tree)'" entertree = \
  /if (%{P1} =~ %leader) \
    enter tree%;\
  /endif


;;;Outpost;;;
/def -p1 -F -mregexp -t'^([A-Za-z]+) tells the group, \'([A-Za-z]+) (leave|enter) (tipi|wooden|wood|stone|outpost)\'' enteroutpost = \
  /enterx %P1 %P2 %P3 %P4

/def -p1 -F -mregexp -t'^([A-Za-z]+) tells the group, \'(enter|leave) (tipi|wooden|wood|stone|outpost) ([A-Za-z]+)\'' enteroutpost2 = \
  /if (inoutpost=1) \
    /enterx %P1 %P4 %P2 %P3%;\
  /endif

;/def -p1 -F -mregexp -t'^([A-Za-z]+) tells the group, \'enter (tipi|wooden|wood|stone|outpost)\'' enteroutpost3 = \
;  /if (inoutpost=0 & (((magician|priest)>0)|((templar|warlock|animist)>1)) \
;    /enterx %P1 %char enter %P2%;\
;  /endif

/def -p1 -F -mregexp -t'^([A-Za-z]+) tells the group, \'enter (tipi|wooden|wood|stone|outpost)\'' enteroutpost3 = \
  /if (inoutpost=0 & (($[fighter+rogue])<2) & (($[currentmana/maxmana])<0.80)) \
    /enterx %P1 %char enter %P2%;\
  /endif

/def -p1 -F -mregexp -t'^([A-Za-z]+) tells the group, \'leave (tipi|wooden|wood|stone|outpost)\'' leaveoutpost = \
  /if (inoutpost=1) \
    /enterx %P1 %char leave %P2%;\
  /endif

/def -p1 -F -mregexp -t'^You enter a (tipi|wooden|stone) outpost.' enteroutpost4 = /set inoutpost=1%;sleep
/def -p1 -F -mregexp -t'^(You leave the outpost.|You rush out of the outpost just in time.)' leaveoutpost2 = /set inoutpost=0
          
/def enterx = \
    /if ({3} =/ 'leave' | {3} =/ 'enter') \
      /if ({4} =/ 'tipi' | {4} =/ 'wooden' | {4} =/ 'stone' | {4} =/ 'outpost' | {4} =/ 'wood') \
        /if ({1} =~ leader & {2} =/ char) \
          /if (position =~ 'rest' | position =~ 'sit') \
            stand%;\
          /elseif (position =~ 'sleep') \
            wake%;\
          /endif%;\
          %3 %4%;\
        /endif%;\
      /endif%;\
    /endif

/def astate=/set leader%;/set tank%;/set assist%;/set groupass%;/set gplist

/def -mglob -t'*Your group consists of:*' gpr=\
    /set sentgroup=0%;\
    /set theirhps=100%;\
    /set count=0%;\
    /set gplist=

/def -p1 -F -mregexp -t'^([0-9][0-9])\. \[([^\.]*)\] ([A-Za-z]*)[ ]+\[(...)\%H ...\%M ...\%V\] (.*)(|\(LD\))' gpr2 = \
    /set sentgroup=0%;\
    /if (_aheal_mod=~'') \
        /set _aheal_mod=$[dynamic_mod()]%;\
        /if (_dheal_debug==1 & _aheal_mod!=0) \
            /ecko New dHEAL modifier: %{_aheal_mod}%;\
        /endif%;\
    /endif%;\
    /if ({P3}!/'someone') \
        /set gplist=%{gplist} %{P3}%;\
        /set gpsize=%{P1}%;\
    /endif%;\
    /if (aheal=1 & {P5} !~ 'NotHere' & {P5} & (priest>1 | templar>1)) \
        /if ({P3}=~tank) \
            /if ({P4}<=atmhp & miratank=1) \
				cast 'miracle' 0.%{P3}%;\
				/set dohealtank=1%;\
            /elseif ({P4}<= $[atthp + _aheal_mod] & currentmana>thresh & truetank=1) \
				/if (priest > 1) \
					cast 'trueheal' 0.%{P3}%;\
				/elseif (animist > 1) \
					cast 'burst of life' 0.%{P3}%;\
				/endif%;\
				/if (_dheal_debug==1) \
					/ecko Healed with thp at $[atghp + _aheal_mod]%;\
				/endif%;\
				/set dohealtank=1%;\
			/endif%;\
		/elseif (currentmana>thresh & dohealtank=0) \
			/if ({P4} < lowesthps) \
				/set toheal=%{P3}%;\
				/set lowesthps=%{P4}%;\
				/set toheal_charstr=%{P2}%;\
			/endif%;\
			/if ({P4} <= atgphp) \
				/set gpowcount=$[gpowcount + 1]%;\
			/endif%;\
		/endif%;\
	/endif

/def -F -mglob -aCred -t'*Present:*' reglist = \
	/debug aheal::gpowcount=%{gpowcount}%;\
	/debug aheal::lowesthp=%{lowesthps} (%{toheal})%;\
	/set gplist=$(/unique %{gplist})%;\
    /set dohealtank=0%;\
    /set sentgroup=0%;\
    /if (aheal=1) \
		/if (gpowcount>=maxgpowcount & gpowgroup=1 & currentmana>thresh) \
			cast 'grouppowerheal'%;\
		/elseif (lowesthps <= $[atghp + _aheal_mod] & truegroup=1 & currentmana>thresh) \
			/if (priest > 1) \
				/let _aheal_spell=trueheal%;\
			/elseif (animist > 1) \
				/let _aheal_spell=burst of life%;\
			/endif%;\
			/if (regmatch("/",%toheal_charstr)) \
				/set toheal=0.%{toheal}%;\
			/endif%;\
			cast '%{_aheal_spell}' %{toheal}%;\
			/if (_dheal_debug==1) \
				/ecko Healed with ghp at $[atghp + _aheal_mod]%;\
 			/endif%;\
		/endif%;\
		/unset toheal_charstr=%;\
		/set lowesthps=100%;\
		/set gpowcount=0%;\
		/unset _aheal_mod%;\
		/repeat -1 1 /set tickison=0%;\
    /endif
