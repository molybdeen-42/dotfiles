function shellsparce --description "Your personal shell assistant!"
    if test (count $argv) -lt 1
        echo "I am Shellsparce, your shell assistant! Please give me an argument so I can assist you."
        echo "You may also use `shellsparce help` to look at all my functionalities at once! :)"
        echo "~Shellsparce"
        return
    end

    set -l option $argv[1]

    if test "$option" = "help"
        echo "Welcome to the Shellsparce help page!"
        echo "The supported arguments are:"
        echo ""
        echo "help: Will show you this menu."
        echo ""
        echo "code: Creates a grid of three terminals in fullscreen."
        echo ""
        echo "theme"
        echo "  current: Shows the current theme."
	echo "  reload: Reload the current theme."
        echo "  themes: Shows the available themes."
        echo "  change: Allows you to change your theme."
        echo "    blindfold"
        echo "    copper"
	echo "    spooky"
	echo "    forest"
        return
    end

    if test "$option" = "theme"
        set -l functionality $argv[2]

        if test "$functionality" = "current"
            cat "$HOME/.config/themes/current_theme.txt"
            return
        end

	if test "$functionality" = "reload"
		/bin/bash "$HOME/.config/themes/change_theme.sh" $(cat "$HOME/.config/themes/current_theme.txt") -r &> /dev/null
		return
	end

        if test "$functionality" = "themes"
            echo "The currently supported themes are: blindfold, copper, spooky & forest"
            return
        end

        if test "$functionality" = "change"
            set -l theme $argv[3]

            switch "$theme"
                case "blindfold" "copper" "spooky" "forest"
                    /bin/bash "$HOME/.config/themes/change_theme.sh" $theme &> /dev/null
                    return
            end 
        end
    end

    if test "$option" = "code"
        nohup kitty --session code_grid.conf --start-as=fullscreen &> /dev/null &; disown; exit
	return
    end

    echo "Something went wrong and I was sadly not able to help."
    echo "Please consult `shellsparce help` for all my functionalities!"
    echo "~Shellsparce"
end
