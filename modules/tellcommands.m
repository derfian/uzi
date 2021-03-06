; -*- mode: tf -*-
;;;;;;Tell stuff

/def -mglob -p3 -F -t'{*} tells you \'summon\'' tellsummon = \
        /if (priest>0) \
                /if (currentmana>=0 & fighting=0 & position=/'stand') \
                        cast 'summon' 0.%1%;\
                        /set lastsum=%{1}%;\
                        /set sumway=tell %{1}%;\
                /elseif (fighting=1) \
                        tell %{1} Try again later, fighting for my life! (tell me squeue to get queued)%;\
                /elseif (position!/'stand') \
                        tell %{1} Try again later, resting some. (tell me squeue to get queued)%;\
                /else \
                        tell %{1} Impossible, not enough mana. (%{currentmana})%;\
                /endif%;\
        /endif%;\
        /repeat -0:00:10 1 /set lastsum=0%;\
        /repeat -0:00:10 1 /set sumway=0

/def -mglob -p3 -F -t'{*} tells you \'squeue\'' tellsummonqueue = \
        /if (priest>0) \
                /if (ismember({1}, {summonqueue}) =~ 1) \
                        tell %1 You are already queued.%;\
                /else \
                        /set summonqueue=$(/unique %summonqueue %1)%;\
                        tell %1 You are set in the summon queue as #$(/length %summonqueue)%;\
                /endif%;\
        /endif

/def -mglob -p3 -F -t'{*} tells the group, \'summon {*}' tellsummon2 = \
        /let playertosummon=$[replace('\'','',{6})]%;\
        /if (priest>0 & playertosummon!~char) \
                /if (currentmana>=0) \
                        /if (playertosummon=~'me') \
                                /set lastsum=%{1}%;\
                                /set sumway=tell %{1}%;\
                                cast 'summon' 0.%{1}%;\
                        /elseif (fighting=0 & {1}=~tank) \
                                /set lastsum=$[replace('\'', '', {6})]%;\
                                /set sumway=gt%;\
                                cast 'summon' 0.%{lastsum}%;\
                        /elseif (fighting=1 & {1}=~tank) \
                                /set lastsum=$[replace('\'', '', {6})]%;\
                                /set sumway=gt%;\
                                retreat%;cast 'summon' 0.%{lastsum}%;\
                        /endif%;\
                /else \
                        gt Sorry, not enough mana. (%{currentmana})%;\
                /endif%;\
        /endif

/def -mglob -F -p3 -t'{*} tells you \'summon *\'' tellsummon3 = \
        /let playertosummon=$[replace('\'','',{5})]%;\
        /if (priest>0 & playertosummon!~char) \
                /if (currentmana>=0) \
                        /if (playertosummon=~'me') \
                                /set lastsum=%{1}%;\
                                /set sumway=tell %{1}%;\
                                /if (fighting=0) \
                                        cast 'summon' 0.%{1}%;\
                                /else \
                                        %sumway Fighting for my life, try later.%;\
                                /endif%;\
                        /elseif (ismember({1},{gplist}) =~ 1) \
                                /set lastsum=$[replace('\'', '', {5})]%;\
                                /set sumway=tell %{1}%;\
                                /if (fighting=0) \
                                        cast 'summon' 0.%{lastsum}%;\
                                /else \
                                        %sumway In the middle of a battle, try later.%;\
                                /endif%;\
                        /elseif (fighting=1 & {1}=~tank) \
                                /set lastsum=$[replace('\'', '', {5})]%;\
                                /set sumway=tell %{1}%;\
                                retreat%;cast 'summon' 0.%{lastsum}%;\
                        /endif%;\
                /else \
                        tell %{1} Sorry, not enough mana. (%{currentmana})%;\
                /endif%;\
        /endif

/def -mglob -t'You can\'t summon creatures to a safe area!' safesummon = \
        /if (sumway!~'0' & lastsum!~'0') \
                /if (sumway=~'gt') \
                        gt %{lastsum} can't be summoned to a safe area.%;\
                /else \
                        %{sumway} Can't summon stuff to a safe area.%;\
                        /set sumway=0%;\
                        /set lastsum=0%;\
                /endif%;\
        /endif

/def -mglob -t'That person is in a safe area!' safesummon2 = \
        /if (sumway!~'0' & lastsum!~'0') \
                /if (sumway=~'gt') \
                        gt %{lastsum} is in a Safe Area!%;\
                /else \
                        %{sumway} You are in a safe area!%;\
                        /set sumway=0%;\
                        /set lastsum=0%;\
                /endif%;\
        /endif

