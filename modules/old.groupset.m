;;;;;;;;;;;;;;;;;;;;;;;
;Groupset
;;;;;;;;;;;;;;;;;;;;;;

/def set_z = \
  alias z assist %{tank}; %{damage}

/def t = \
	/set tank=%{1}%;\
        /set leader=%{1}%;\
        /set amigrouped=1%;\
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
    /undead

/def -mglob -t'{*} is the new leader\!' newleader2 = \
    /if (leaderdied=1) \
      /set newtank=%{1}%;\
    /endif

;;;;;;;;;;;;;;;;;;;;;
;Position Functions ;
;;;;;;;;;;;;;;;;;;;;;

/set position=stand

/def onstand = \
  /resetdamage%;\
  /if (onstandcweap !~ '') \
    /weapon %onstandcweap%;\
    /set onstandcweap=%;\
  /endif%;\
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
/def -p1 -mglob -t'{*} tells the group, \'wake\'' com1=/if ({1}=/{leader}) wake%;/endif
/def -p1 -mglob -t'{*} tells the group, \'stand\'' com2=/if ({1}=/{leader} | {1}=~'someone') stand%;/endif
/def -p1 -mglob -t'{*} tells the group, \'sleep\'' com3=/if ({1}=/{leader}) sleep%;/endif
/def -p1 -mglob -t'{*} tells the group, \'rest\'' com4=/if ({1}=/{leader}) rest%;/endif
/def -p1 -mglob -t'{*} tells the group, \'sit\'' com5=/if ({1}=/{leader}) sit%;/endif

/def -p1 -F -mglob -t'You sit down and rest your tired bones.' restspell1=aff%;/set position=rest
/def -p1 -F -mglob -t'You stop resting, and stand up.' restspell2=\
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

/def -F -mregexp -t"^([A-z]+) tells .* 'build ([A-z]+)'" buildoutpost = \
  /if ((%{P1} =~ %leader) & fighter>0) \
    build %P2%;\
  /endif

/def -p1 -F -mregexp -t"^([A-z]+) tells .* '(D|d)(RINK WELL|rink well)'" drinkwell = \
  /if (%{P1} =~ %leader) \
    drink well%;\
  /endif

/def -p1 -F -mregexp -t"^([A-z]+) tells .* '(E|e)(NTER TREE|nter tree)'" entertree = \
  /if (%{P1} =~ %leader) \
    enter tree%;\
  /endif

/def -p1 -F -mregexp -t'^([A-Za-z]+) tells the group, \'([A-Za-z]+) (leave|enter) (tipi|wooden|stone)\'' enteroutpost = \
  /enterx %P1 %P2 %P3 %P4
/def -p1 -F -mregexp -t'^([A-Za-z]+) tells the group, \'(enter|leave) (tipi|wooden|stone) ([A-Za-z]+)\'' enteroutpost2 = \
  /if (inoutpost=1) \
    /enterx %P1 %P4 %P2 %P3%;\
  /endif

/def -p1 -F -mregexp -t'^([A-Za-z]+) tells the group, \'leave (tipi|wooden|stone)\'' leaveoutpost = \
  /if (inoutpost=1) \
    /enterx %P1 %char leave %P2%;\
  /endif

/def enterx = \
    /if ({3} =/ 'leave' | {3} =/ 'enter') \
      /if ({4} =/ 'tipi' | {4} =/ 'wooden' | {4} =/ 'stone') \
	/if ({1} =~ leader & {2} =/ char) \
	  /if (position =~ 'rest' | position =~ 'sit') \
	    stand%;\
	  /elseif (position =~ 'sleep') \
	    wake%;\
	  /endif%;\
	  %3 %4%;\
          /if ({3} =/ 'enter') \
            /set inoutpost=1%;\
	    rest%;\
	  /else \
            /set inoutpost=0%;\
          /endif%;\
        /endif%;\
      /endif%;\
    /endif

/def astate=/set leader%;/set tank%;/set assist%;/set groupass%;/set gplist


/def -mglob -t'*Your group consists of:*' gpr=\
    /set sentgroup=0%;\
    /set theirhps=100%;\
    /set count=0%;\
    /set gplist= 

/def -p1 -F -mregexp -t'^([0-9][0-9])\. \[[^\.]*\] ([A-Za-z]*) [ ]+ \[(...)\%H ...\%M ...\%V\] (.*)(|\(LD\))' gpr2 = \
        /set sentgroup=0%;\
	/if ({P2}!/'someone') \
          /set gplist=%{gplist} %{P2}%;\
          /set gpsize=%{P1}%;\
        /endif%;\
        /if (aheal=1 & {P4} !~ 'NotHere' & {P4} & (priest>1 | templar>1)) \
          /if ({P2}=~tank) \
            /if ({P3}<=atmhp & miratank=1) \
              cast 'miracle' %{P2}%;\
              /set dohealtank=1%;\
            /elseif ({P3}<=atthp & currentmana>thresh & truetank=1) \
              true %{P2}%;\
              /set dohealtank=1%;\
            /endif%;\
          /elseif (currentmana>thresh & dohealtank=0) \
            /if ({P3} < lowesthps) \
              /set toheal=%{P2}%;\
              /set lowesthps=%{P3}%;\
            /endif%;\
            /if ({P3} <= atgphp) \
              /set gpowcount=$[gpowcount + 1]%;\
            /endif%;\
          /endif%;\
        /endif

/def -F -mglob -aCred -t'*Present:*' reglist = \
        /set gplist=$(/unique %{gplist})%;\
        /set dohealtank=0%;\
        /set sentgroup=0%;\
	/if (aheal=1) \
          /if (gpowcount>maxgpowcount & gpowgroup=1 & currentmana>thresh) \
            cast 'grouppowerheal'%;\
          /elseif (lowesthps <= atghp & truegroup=1 & currentmana>thresh) \
            cast 'trueheal' %{toheal}%;\
          /endif%;\
	  /set lowesthps=100%;\
	  /set gpowcount=0%;\
	  /repeat -1 1 /set tickison=0%;\
	/endif
