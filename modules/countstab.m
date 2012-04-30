;;;;;;;;;stabscript, abit bugged.. but who cares :P

/set countback=1
/if (lowestbs=~'') /set lowestbs=9999%;/endif
/if (tlastbs=~'') /set tlastbs=echo%;/endif
/if (ashowdl=~'') /set ashowdl=0%;/endif
/if (countback=~'') /set countback=1%;/endif

/def -mregexp -p2147483647 -F -t'^Name             Miss  Hits.*Ticks$' dlshowing = /set dlshow=1

/def -mregexp -p2147483647 -F -t'^([A-z]*)[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+([0-9]*)' countback = \
  /if (({P1}=/{char})&({P2}>0)) \
    /if (deathstab=1 & ashowdl=1) \
      /set deathstab=0%;\
      /set deathlastbs=$[%{P2}-(%{tempback}+%{deathstabdam}+%{lastbs})]%;\
      /set deathstabdam=$[%deathstabdam+%deathlastbs]%;\
      /set avgdeathstabdam=$[%deathstabdam/%deadlystabs]%;\
      /ecko The deadly stab did %{deathlastbs} (Making average on deadlystabs(%deadlystabs): %avgdeathstabdam)%;\
    /endif%;\
    /if (deadlystabs=1 & backstabs=0) \
        /set dlshow=0%;\
    /endif%;\
    /if (dlshow=1) \
      /set tempback=%{stabdam}%;\
      /set stabdam=$[%{P2}-%{deathstabdam}]%;\
      /set avgstab=$[{stabdam}/{backstabs}]%;\
    /endif%;\
    /if ((dlshow=1)&(ashowdl!=1)) \
      /ecko Avdam on %{backstabs} backstabs is: %{avgstab} (%{P2})%;\
      /set dlshow=0%;\
    /elseif ((dlshow=1)&(ashowdl=1)) \
      /set totstabs=$[backstabs+missedbs]%;\
      /set dlshow=0%;\
      /if ((lastbs>highestbs)&(lastbs<=1300)) \
        /set highestbs=%{lastbs}%;\
      /endif%;\
      /if ((lastbs<lowestbs)&(lastbs>3)) \
        /set lowestbs=%{lastbs}%;\
      /endif%;\
      /ecko @{Ccyan}Backstabs:%{totstabs}  Avdam:%{avgstab}  Missed:%missedbs  Hits:%backstabs  BestBS:%highestbs  SuckiestBS:%lowestbs  Deathstabavg:%{avgdeathstabdam} Deathstabs:%deadlystabs Lastdeath:%deathlastbs%;\
      /set dlshow=0%;\
    /endif%;\
 /endif

/def -mglob -p2147483647 -F -t'DAMLOG: Reset.' resetback= \
  /set backstabs=0%;/set tempback=-1%;/set stabdam=0%;\
  /set deathstab=0%;/set deathlastbs=0%;/set avgdeathstabdam=0%;\
  /set deathstabdam=0%;/set deadlystabs=0%;/set lastbs=0%;/set tempback=0%;\
  /set missedbs=0%;/set highestbs=0%;/set lowestbs=9999

/def tstab = \
  /if ({1}=/'auto') \
    /if ({2}!=('*echo*'|'*gt*'|'qt*'|'gos*'|'whisp*'|'say'|'off*')) /set tlastbs=tell %{2}%;/set ashowdl=1%;%{tlastbs} I will now automatically brag about my stabs for ya.%;/ecko Automatically %{tlastbs} stabdam.%;\
    /elseif ({2}=/'off') /ecko Stab tell is off.%;%{tlastbs} won't show autoshow damage on stabs.%;/set tlastbs=0%;/set ashowdl=0%;\
    /else /set tlastbs=%{2} %{3} %{4} %{5}%;/set ashowdl=1%;%{tlastbs} I will automatically show my wussy stabdam.%;/ecko Automatically %{tlastbs} - Stabdamage.%;\
    /endif%;\
  /else  \
      /set prostabs2=$[(%backstabs*100)/%totstabs]%;\
      /set prostabs=$[100-%prostabs2]%;\
      /if (missedbs=0) \
        /set prostabs=0%;\
        /set prostabs2=100%;\
      /endif%;\
    /if (ashowdl=1) \
      %{*} Stabs:%totstabs (Hits:%backstabs [%prostabs2\%], Failed:%missedbs [%prostabs\%]) Avdam:%avgstab (Max:%highestbs, Min:%lowestbs)%;\
    /else \
      %{*} Stabs:%totstabs (Hits:%backstabs [%prostabs2\%], Failed:%missedbs [%prostabs\%]) Avdam:%avgstab%;\
    /endif%;\
  /endif


