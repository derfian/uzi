; -*- mode: tf -*-
;================================
;   Anonymous Hoppers Support
;================================
/def ahop = \
    /if (hopping=1) \
      /set hopping=0%;/ecko AutoHopping is now turned: %{htxt2}OFF%; \
    /else \
      /set hopping=1%;/ecko AutoHopping is now turned: %{htxt2}ON%; \
    /endif

/def -mregexp -t'^\(([a-z]+)\)([A-z]+) starts hopping up and down on you.  You just wish (he|it|she) would STOP!' hopping = \
    /if (hopping=1 & {P1}=~'tell') \
      tf %{P2} hop %{P2}%;tf %{P2} high self%;\
    /endif

/def -mregexp -t'^(\(|\[)([^ ]+)(\)|\])As ([A-z]+) hops up and down on ([A-z]+), you hear' hopping2 = \
    /if (hopping=1 & {P2}=~'group') \
      gtf hop %{P5}%;gtf highfive %{P4}%;\
    /elseif (hopping=1 & {P2}=~'[QUEST]') \
      qf hop %{P5}%;qf highfive %{P4}%;\
    /endif

