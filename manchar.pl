#!/usr/bin/perl -w
#$ver = 0.5
#$author = Solias

$tiny_world_temp = "tiny.world.temp";
$tiny_world = "tiny.world";

$found_char = 0;

sub listchar {
  print "Current characters in $tiny_world\n";
  open(OLDTINY, "< $tiny_world") or die "can't open file $tiny_world: $!";
  while (defined ($userline = <OLDTINY>)) {
    chomp $userline;
    $le = length($userline);
    if ($le > 2)
    {
      if ($userline !~ m/^\;(.*)$/)
      {
	$userline =~ /^(.*)\(\"(\w+)\"(.*)\"(.*)\"\)$/;
	$worldname = $2;
	$password = $4;
	if ($worldname !~ "Burning")
	{
	  $found_char = 1;
	  print "Char: $worldname\tPass: $password\n";
	}
      }
    }
  }
  close(OLDTINY) or die "can't close file $tiny_world: $!";
  if ($found_char != 1)
  {
    print "No characters found\n";
  }
  print "\nPress Enter to continue.\n";
  $ans = <>;
  if ($ans){}
}

sub addchar {
  $found_char = 0;
  print "\nCharacter to add: ";
  chop($addname = <>);
  open(OLDTINY, "< $tiny_world") or die "can't open file $tiny_world: $!";
  while (defined ($userline = <OLDTINY>)) {
    chomp $userline;
    $le = length($userline);
    if ($le > 2)
    {
      if ($userline !~ m/^\;(.*)$/)
      {
        $userline =~ /^(.*)\(\"(\w+)\"(.*)"(.*)\"\)$/;
        $worldname = $2;
        if ($worldname !~ "Burning")
        {
          if ($worldname =~ $addname)
	  {
            $found_char = 1;
	    print "Character already exists.\n";
	  }
        }
      }
    }
  }
  close(OLDTINY) or die "can't close file $tiny_world: $!";
  if ($found_char != 1)
  {
    if ($addname !~ m/[\W#]+/) {
      print "Password for $addname: ";
      chop($addpass = <>);    
      @args = ("cp", "$tiny_world", "$tiny_world_temp");
      system(@args) == 0
       or die "system @args failed: $?";
      open(TINYTEMP, ">> $tiny_world_temp") or die "can't open file $tiny_world_temp: $!";
      print TINYTEMP "\/test addworld\(\"$addname\"\, \"diku.uzi\"\, \"burningmud.com\"\, \"4000\"\, \"$addname\"\, \"$addpass\"\)\n";
      print "Character $addname added to $tiny_world\n";
      close(TINYTEMP) or die "can't close file $tiny_world_temp: $!";
      @args = ("mv", "$tiny_world_temp", "$tiny_world");
      system(@args) == 0
       or die "system @args failed: $?";
    }
    else {
      print "Illegal character name!\n";
    }
  }


  print "\nPress Enter to continue.\n";
  $ans = <>;
  if ($ans){}
}

sub modchar {
  $found_char = 0;
  print "\nCharacter to modify: ";
  chop($modname = <>);
  open(OLDTINY, "< $tiny_world") or die "can't open file $tiny_world: $!";
  open(TINYTEMP, ">> $tiny_world_temp") or die "can't open file $tiny_world_temp: $!";
  while (defined ($userline = <OLDTINY>)) {
    chomp $userline;
    $le = length($userline);
    if ($le > 2)
    {
      if ($userline !~ m/^\;(.*)$/)
      {
        $userline =~ /^(.*)\(\"(\w+)\"(.*)"(.*)\"\)$/;
        $worldname = $2;
        $password = $4;
        if ($worldname !~ "Burning")
        {
          if ($worldname =~ $modname)
	  {
            $found_char = 1;
            print "New password for $modname: ";
            chop($modpass = <>);
            print TINYTEMP "\/test addworld\(\"$worldname\"\, \"diku\"\, \"burningmud.com\"\, \"4000\"\, \"$worldname\"\, \"$modpass\"\)\n";
	    print "Password changed.\n";
	  }
	  else {
            print TINYTEMP "$userline\n";
          }
        }
        else {
          print TINYTEMP "$userline\n";
        }
      }
      else {
	print TINYTEMP "$userline\n";
      }
    }
  }
  close(OLDTINY) or die "can't close file $tiny_world: $!";
  close(TINYTEMP) or die "can't close file $tiny_world_temp: $!";
  @args = ("mv", "$tiny_world_temp", "$tiny_world");
  system(@args) == 0
   or die "system @args failed: $?";

  if ($found_char != 1)
  {
    print "Character not found\n";
  }

  print "\nPress Enter to continue.\n";
  $ans = <>;
  if ($ans){}
}

sub delchar {
  $found_char = 0;
  print "\nCharacter to delete: ";
  chop($delname = <>);
  open(OLDTINY, "< $tiny_world") or die "can't open file $tiny_world: $!";
  open(TINYTEMP, ">> $tiny_world_temp") or die "can't open file $tiny_world_temp: $!";
  while (defined ($userline = <OLDTINY>)) {
    chomp $userline;
    $le = length($userline);
    if ($le > 2)
    {
      if ($userline !~ m/^\;(.*)$/)
      {
        $userline =~ /^(.*)\(\"(\w+)\"(.*)$/;
        $worldname = $2;
        if ($worldname !~ "Burning")
        {
          if ($worldname =~ $delname)
	  {
            $found_char = 1;
	    print "Character deleted.\n";
	  }
	  else {
            print TINYTEMP "$userline\n";
          }
        }
        else {
          print TINYTEMP "$userline\n";
        }
      }
      else {
	print TINYTEMP "$userline\n";
      }
    }
  }
  close(OLDTINY) or die "can't close file $tiny_world: $!";
  close(TINYTEMP) or die "can't close file $tiny_world_temp: $!";
  @args = ("mv", "$tiny_world_temp", "$tiny_world");
  system(@args) == 0
   or die "system @args failed: $?";

  if ($found_char != 1)
  {
    print "Character not found\n";
  }

  print "\nPress Enter to continue.\n";
  $ans = <>;
  if ($ans){}
}


sub menu {
  $answer = 9;
  system("clear");
  while ($answer != 0)
  {
    $answer = 9;
    print "\n";
    print "Menu for Uzi Character Manager v0.5 by Solias\n";
    print "All inputs are case-sensitive\n";
    print "Make your choice:\n";
    print " (1) List current characters\n";
    print " (2) Add new character\n";
    print " (3) Modify password on existing Character\n";
    print " (4) Delete character\n";
    print " (0) Exit\n";
    print "\nChoice: ";
    chop($answer = <>);
    if($answer =~ m/^[0-4]/) {
      if ($answer == 1) {
        &listchar;
      }
      elsif ($answer == 2) {
        &addchar;
      }
      elsif ($answer == 3) {
        &modchar;
      }
      elsif ($answer == 4) {
        &delchar;
      }
      elsif ($answer == 0) {
      }
    }
    else {
      print "\nNot a valid option\nPress enter to continue.\n";
      $ans = <>;
      if ($ans){}
      $answer = 9;
    }
  system("clear");
  }
}

&menu;
