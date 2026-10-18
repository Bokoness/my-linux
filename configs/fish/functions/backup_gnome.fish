
function backup_gnome_extensions
    # Remove the old backup
    # rm -Rm ~/Documents/backup/gnome_extentions
    # Create the backup directory if it doesn't exist
    mkdir -p ~/Documents/backup/gnome

    # Copy the extensions folder
    cp -r ~/.local/share/gnome-shell/extensions ~/Documents/backup/gnome

    # Print a success message
    echo "GNOME extensions backed up to ~/Documents/backup/gnome"
end
