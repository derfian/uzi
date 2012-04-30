;;;;;;;;;; Average Damage Calculator by orange -98
;;;;;;;;;; Updated by Solias -04

/alias avdam /avdam %{*}
/def avdam = \
/test avdam:=(%{1}.0 * (%{2}.0+1)/2)+%{3}.0%;\
/test maxdam:=(%{1}.0 * (%{2}.0))+%{3}.0%;\
/test mindam:=(%{1}.0 * (1)) + %{3}.0%;\
/echo -a -p @{BCred}*** @{Cyellow}Avdam @{Cred}***%;\
/echo -a -p @{BCblack} Dice:   @{Ccyan}%{1}@{Cwhite}D@{Ccyan}%{2}%;\
/echo -a -p @{BCblack} Avdam:  @{Ccyan}%{avdam}%;\
/echo -a -p @{BCblack} Maxdam: @{Ccyan}%{maxdam}%;\
/echo -a -p @{BCblack} Mindam: @{Ccyan}%{mindam}%;\
/echo -a -p @{BCred}*************
