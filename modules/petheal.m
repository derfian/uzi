;; Renames pets && lets uzi's healscript work with the pets as groupmembers.
;; IMPORTANT: Needs a fix in the gpr2 macro - the following:
;;
;; should be changed to:
;; 
;; in order for this to work.
;; TODO: Fill in the actual values.


;; Named pets -> Name

/def -F -p10000 -mregexp -t"([A-Z][a-z]+)'s .* named '([A-Z][a-z]+)'" PetHealRenameNamedPets = \
	/if (%{P1} =~ tank) \
		/substitute %{PL}%{P2}%{PR}%;\
	/endif

;; Fixes assist bug

/def -F -p10001 -mregexp -t"([A-Z][a-z]+)'s .* named '([A-Z][a-z]+)'\.$" PetHealRenameNamedPetsEOL = \
	/if (%{P1} =~ tank) \
		/substitute %{PL}%{P2}.%;\
	/endif

;; Rename unnamed elementals

/def -F -p9999 -mregexp -t"([A-Z][a-z]+)'s ([A-Z][a-z]+) Elemental" PetHealRenameUnnamedElemental = \
	/if (%{P1} =~ tank) \
		/substitute %{PL}%{P2}%{PR}%;\
	/endif

;; Rename Phoenix

/def -F -p9999 -mregexp -t"([A-Z][a-z]+)'s Phoenix" PetHealRenameUnnamedPhoenix = \
	/if (%{P1} =~ tank) \
		/substitute %{PL}Phoenix%{PR}%;\
	/endif


; Rename Ceng

/def -F -p9999 -mregexp -t"Ceng, the friend of Eowaran" PetHealRenameCeng = \
        /substitute %{PL}Ceng%{PR}


;; Fix group list outpost

/def -F -p9998 -mregexp -t"Mob \] ([A-Z][a-z]+) \[" PetHealFixGroupList = \
	/substitute %{PL}Mob ] $[pad(%P1,-15)] [%{PR}

;; Fix autoheal triggers

/undef gpr2

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


/undef reglist

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
	