param([Parameter(Mandatory=$true)]$authorsName, [Parameter(Mandatory=$true)]$authorsEmail, $editor)

#$env:editor="d:/scratchpad/etc/notepad2.exe"
#or
#http://stackoverflow.com/questions/10564/how-can-i-set-up-an-editor-to-work-with-git-on-windows
#fyi: what you refer to in the config file is actually a shell (/bin/sh) script, not a DOS script.
#git config --global core.editor "'C:/Program Files/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin"

if ($editor)
{
	if (test-path $editor)
	{
		$editor = (gi $editor).Path
	}
	else
	{
		throw "$editor cannot be found"
	}
}
elseif (get-command -errorAction silentlyContinue notepad2.exe) {
    $editor = @(get-command notepad2.exe)[0].path
} else {
    $editor = @(get-command notepad)[0].path
}
$editor = $editor.Replace("\","/")

write-host -foregroundcolor green "setting editor to $editor ... pass -editor <exepath> to this script if you want something different"

git config --global core.editor $editor

#write-host -foregroundcolor green "setting core.autocrlf to global on a false to $editor ... edit setup-git.ps1 if you want something different"
#git config --global core.autocrlf false

#you get an annoying warning message about how the behavior will change in git 2.0, 'upstream' is the 2.0 default (push only the current branch)
git config --global push.default upstream

git config --global user.name  $authorsName
git config --global user.email $authorsEmail

# http://stackoverflow.com/questions/1106529/how-to-skip-loose-object-popup-when-running-git-gui
# disable git gui's warning "This repository currently has approximately XXXX loose objects."
git config --global gui.gcwarning false

#put this in your profile:
$env:term="msys"  #Supress git's "warning: terminal is not fully functional" prompt (which actually comes form it's internal use of 'less' command)

write-host -foregroundcolor green "YOU SHOULD ADD $env:term='msys' TO YOUR `$PROFILE! (or modify your computers environment variables)"

