-------------------------------------------------
For WSL Users
-------------------------------------------------

1. Open Windows Task Scheduler
2. Create a basic task and name it
3. Set a suitable trigger (i.e. on startup or on logon)
4. Set action to "Start a Program"
5. Set the program/script to be "bash" (must be in your PATH)
6. Add arguments "~/dotfiles/git-sync/pull.sh"
7. Start in
"C:\Windows\Users\$WINDOWS_USER$\AppData\Local\lxss\home\$BASH_USER$\dotfiles\git-sync"
