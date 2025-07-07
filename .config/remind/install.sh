#!/bin/bash

# install shell script:

cd ~
mkdir -p ~/.config/remind
echo 'SET remind_dir getenv("HOME") + "/.config/remind/"' >~/.config/remind/reminders.rem
# if you want to use INCLUDE
ln -s .config/remind/reminders.rem ~/.reminders
# if you want to glob
ln -s .config/remind/ ~/.reminders
touch ~/.config/remind/helpers.rem

echo "IF !defined(\"HaveHelpers\")
SET HaveHelpers 1
# make sure this IF guard gets closed at the bottom


# all my helpers go here
ENDIF # HaveHelpers
" >~/.config/remind/helpers.rem

for f in ushol birthdays anniversaries work bills; do
  # only if you’re using INCLUDE

  echo "INCLUDE [filedir()]/helpers.rem" >~/.config/remind/${f}.rem
  echo "INCLUDE [remind_dir]/${f}.rem" >>~/.config/remind/reminders.rem
done

# a few ideas for the list of files:
# - an individual file for myself
# - one for my wife
# - one for each kid
# - one for each kid's school calendar
# - birthdays + anniversaries (+ notice in advance to send a card)
# - family events
# - household chores
# - finances
# - church events
# - religious calendar
# - one for each place I volunteer
# - US/FR/AR holidays
# - events at our local library
# - work
# - medecine schedule (pickups and orders)
# - vacation starts (including when to search for flights, when to stop mail deliveries)
# - workout schedules
# - concerts and events in town
# - auctions
# - car registration
# - maturing bonds (and stocks deadlines?)
# - credit report requests
# - garbage days
