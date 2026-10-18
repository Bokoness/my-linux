
function restore_gnome_extensions
    # Get the library directory path from the first argument
    set library_dir $argv[1]

    # Check if the directory exists
    if not test -d $library_dir
        echo "Error: Library directory '$library_dir' does not exist."
        return
    end

    # Copy the extensions folder
    cp -r $library_dir/extensions ~/.local/share/gnome-shell/extensions

    # Print a success message
    echo "GNOME extensions restored from '$library_dir'"
end
