## Command history configuration
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=100000
SAVEHIST=20000

# Show history
case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

# If this is set, zsh sessions will append their history list to the history file, rather than
# replace it. Thus, multiple parallel zsh sessions will all have the new entries from their history
# lists added to the history file, in the order that they exit. The file will still be periodically
# re-written to trim it when the number of lines grows 20% beyond the value specified by $SAVEHIST
# (see also the HIST_SAVE_BY_COPY option).
setopt append_history

# Save each command’s beginning timestamp (in seconds since the epoch) and the duration
# (in seconds) to the history file. The format of this prefixed data is:
# ': <beginning time>:<elapsed seconds>;<command>'
# setopt extended_history

# If the internal history needs to be trimmed to add the current command line, setting this option
# will cause the oldest history event that has a duplicate to be lost before losing a unique event
# from the list. You should be sure to set the value of HISTSIZE to a larger number than SAVEHIST
# in order to give you some room for the duplicated events, otherwise this option will behave just
# like HIST_IGNORE_ALL_DUPS once the history fills up with unique events.
setopt hist_expire_dups_first

# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt hist_ignore_dups

# Remove command lines from the history list when the first character on the line is a space, or
# when one of the expanded aliases contains a leading space. Only normal aliases (not global or
# suffix aliases) have this behaviour. Note that the command lingers in the internal history until
# the next command is entered before it vanishes, allowing you to briefly reuse or edit the line.
# If you want to make it vanish right away without entering another command, type a space and press
# return.
setopt hist_ignore_space

# Whenever the user enters a line with history expansion, don’t execute the line directly; instead,
# perform history expansion and reload the line into the editing buffer.
setopt hist_verify

# This option both imports new commands from the history file, and also causes your typed commands
# to be appended to the history file (the latter is like specifying INC_APPEND_HISTORY, which
# should be turned off if this option is in effect). The history lines are also output with
# timestamps ala EXTENDED_HISTORY (which makes it easier to find the spot where we left off reading
# the file after it gets re-written).
# By default, history movement commands visit the imported lines as well as the local lines, but
# you can toggle this on and off with the set-local-history zle binding. It is also possible to
# create a zle widget that will make some commands ignore imported commands, and some include them.
# If you find that you want more control over when commands get imported, you may wish to turn
# SHARE_HISTORY off, INC_APPEND_HISTORY or INC_APPEND_HISTORY_TIME (see above) on, and then
# manually import commands whenever you need them using ‘fc -RI’.
setopt share_history

# When the history file is re-written, we normally write out a copy of the file named $HISTFILE.new
# and then rename it over the old one. However, if this option is unset, we instead truncate the
# old history file and write out the new version in-place. If one of the history-appending options
# is enabled, this option only has an effect when the enlarged history file needs to be re-written
# to trim it down to size. Disable this only if you have special needs, as doing so makes it
# possible to lose history entries if zsh gets interrupted during the save.
# When writing out a copy of the history file, zsh preserves the old file’s permissions and group
# information, but will refuse to write out a new file if it would change the history file’s owner.
setopt hist_save_by_copy
