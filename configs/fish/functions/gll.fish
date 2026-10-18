function gll
    # Set a flag to track when we're in the [alias] section
    set in_alias_section 0

    # Read the .gitconfig file line by line
    cat ~/.gitconfig | while read line
        # If we find the [alias] section, mark that we're in it
        if string match "[alias]" $line
            set in_alias_section 1
            continue
        end

        # If we find another section (e.g., [user]), stop processing the aliases
        if string match "\[*\]" $line
            set in_alias_section 0
        end

        # If we're in the alias section, print the alias lines
        if test $in_alias_section -eq 1
            echo $line
        end
    end
end
