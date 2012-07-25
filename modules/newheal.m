; -*- mode: tf -*-
;
;****NEWHEAL.M*******************************************************************
;										*
; This updated module will heal pets and gives warning if they are not named	*
;										*
;********************************************************************************

/def -p2 -F -mregexp -t'^([0-9][0-9])\. \[[0-9][0-9] (..|  | Mob)(\/..|   | )\] ([A-Za-z]+|[A-Za-z]+\'s (Vampire|Spectre|Ghast|Wolf|Phoenix|Earth Elemental|Air Elemental|Water Elemental)|Ceng, the friend of Eowaran|A giant sea turtle|A Seagull|.* named \'([A-Za-z]+)\')[ ]*\[(...)\%H ...\%M ...\%V\] (.*)(|\(LD\))' gpr2 = \
        /set sentgroup=0%;\
        /if (_aheal_mod=~'') \
                /set _aheal_mod=$[dynamic_mod()]%;\
                /if (_dheal_debug==1 & _aheal_mod!=0) \
                        /ecko New dHEAL modifier: %{_aheal_mod}%;\
                /endif%;\
        /endif%;\
        /if ({P4}!/'someone' & {P2}!/' Mob') \
                /set gplist=%{gplist} %{P4}%;\
                /set gpsize=%{P1}%;\
        /endif%;\
;; MIRA
        /if (aheal=1 & {P8} !~ 'NotHere' & {P8} & (priest>0 | templar>1 | animist>1)) \
                /if ({P2}=~tank) \
                        /if ({P7}<=atmhp & miratank=1) \
                                cast 'miracle' %{P4}%;\
                                /set dohealtank=1%;\
                        /elseif ({P7}<= $[atthp + _aheal_mod] & currentmana>thresh & truetank=1) \
;; Tankheal
                                /if (priest>1) \
                                        true %{P4}%;\
                                /elseif (animist>1) \
                                        burst %{P4}%;\
                                /elseif (priest == 1) \
                                        pow %{P4}%;\
                                /endif%;\
                                /if (_dheal_debug==1) \
		                        /ecko Healed with thp at $[atghp + _aheal_mod]%;\
	                        /endif%;\
                                /set dohealtank=1%;\
                        /endif%;\
                /elseif (currentmana>thresh & dohealtank=0) \
                        /if ({P7} < lowesthps) \
                                /if ({P2}=/' Mob') \
		                        /if ({P6}!/'') /set toheal=%{P6}%;\
		                        /elseif ({P4}=/'A Seagull') /set toheal=seagull%;\
		                        /elseif ({P4}=/'A giant sea turtle') /set toheal=turtle%;\
		                        /elseif ({P4}=/'Ceng, the friend of Eowaran') /set toheal=ceng%;\
		                        /else /set toheal=%{P5}%;\
		                        /endif%;\
	                        /else /set toheal=0.%{P4}%;\
	                        /endif%;\
                                /set lowesthps=%{P7}%;\
                        /endif%;\
                        /if ({P7} <= atgphp) \
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
                /elseif (lowesthps <= $[atghp + _aheal_mod] & truegroup=1 & currentmana>thresh) \
                        /if (({toheal}=/'Wolf') | ({toheal}=/'Vampire') |({toheal}=/'Spectre') |({toheal}=/'Ghast')) gtf , is truehealing unnamed pet %{toheal} - please name to ensure the wrong %{toheal} is not healed by mistake%; /endif%;\
                        /if (priest>1) \
                                true %{toheal}%;\
                        /elseif (animist>1) \
                                burst %{toheal}%;\
                        /elseif (priest>0) \
                                pow %{toheal}%;\
                        /endif%;\
                        /if (_dheal_debug==1) \
	                        /ecko Healed with ghp at $[atghp + _aheal_mod]%;\
 	                /endif%;\
                /endif%;\
                /set lowesthps=100%;\
                /set gpowcount=0%;\
                /unset _aheal_mod%;\
                /repeat -1 1 /set tickison=0%;\
        /endif

