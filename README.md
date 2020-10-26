# tint2tweaks
Some tint2 executors I've created/glued together.

1. **tint2_dayweather.sh**
  > This 2-line executor displays the day and date on the top line, and weather status, temperature and sunrise/sunset times on the bottom line. I've removed my API key since it's not setup for public use.
1. **tint2_hostchk.sh**
  > This multi-line executor shows you the status of the chosen hosts, as well as the logging status, so you can check if hosts are up or down with a glance. It can log either all status (up or down), down only, or nothing.
1. **tint2_keyleds.py**
  > This executor shows you the status of your keyboard lock keys: Capslock is represented by the 'a', Numlock by '1' and Scrolllock by 's'. Lower-case and normal weight is not-set, upper-case and bold is set.
1. **tint2_phone.sh**
  > This is a simple MTP wrapper that shows you if your MTP device (tested with my S9) is connected, and if so what battery percentage it has or if it's connected as a drive (not both yet, one or the other). I have it configured with a right-click action to mount my phone and left-click to unmount it.
1. **tint2_rpistatus.sh**
  > This executor is meant to parse the Raspberry Pi status code for low voltage and other system problems. Right now it only shows 0 problem or all problems, as I haven't worked out the code nor have I trigged the necessary problems to do so. Eventually.


Various code sources were used or glued together to create these, and I think I documented them all in the relevant script. I hope other folx find these as helpful as I do.
