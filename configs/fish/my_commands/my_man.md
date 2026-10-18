# 🐧 Linux CLI Cheat Sheet

# Command Reference

- `pwd` – Print Working Directory - Shows exactly where you are.
- `ls` – List - Lists files and directories.
- `ls -la` – List All - Shows detailed info including hidden files.
- `cd /path` – Change Directory - Move to a specific path.
- `cd ..` – Go Up - Move to the parent directory.
- `cd ~` – Home - Jump to your home directory.
- `cd -` – Toggle - Switch back to the previous directory.
- `mkdir folder` – Make Directory - Create a new folder.
- `mkdir -p a/b/c` – Recursive Mkdir - Create nested directories in one go.

## 📄 Working with Files

### Operations:
- `touch file.txt` – Create an empty file.
- `cp src dest` – Copy files; use -r for directories.
- `mv old new` – Rename or move files.
- `rm file` – Delete a file.
- `rm -rf folder` – Caution: Forcefully and recursively delete a directory.

### Viewing Content:
- `cat file.txt` – Print the entire file content to the terminal.
- `less file.txt` – Interactive view (scrollable).
- `head -n 10 file` – View the first 10 lines.
- `tail -n 20 file` – View the last 20 lines.
- `tail -f log.log` – Follow updates in real-time (perfect for debugging).

## 🔍 Text Processing & Searching

- `grep "pattern" file` – Search for text inside a file.
- `grep -r "pattern" .` – Search recursively in all files in the current folder.
- `sort file.txt` – Sort lines alphabetically.
- `uniq file.txt` – Remove duplicate consecutive lines.
- `wc file.txt` – Word count (lines, words, characters).

## 🔐 File Permissions

Permissions are structured as: `drwxr-xr-x` (d=directory, r=read(4), w=write(2), x=execute(1)).

- `chmod 755 script.sh` – Typical permissions for executable scripts.
- `chmod +x script.sh` – Grant execution permission.
- `chown user:group file` – Change file ownership.

## ⚙️ Process Management

- `ps aux` – List every running process on the system.
- `top` / `htop` – Interactive real-time process monitoring.
- `kill PID` – Terminate a process by ID.
- `kill -9 PID` – Force kill a process (use as a last resort).
- `pkill name` – Kill process by its name.
- `bg` / `fg` – Move jobs to background or foreground.

## 🌐 Networking & System Info

- `ip addr` – Show network interfaces and IP addresses.
- `ping host` – Check connectivity.
- `netstat -tulpn` – View open ports and active connections.
- `df -h` – Disk space usage (human-readable).
- `free -h` – Memory (RAM) usage.
- `uname -a` – Kernel and system information.
- `curl -I url` – Fetch HTTP headers.

## 📦 Package Management (Ubuntu/Debian)

- `sudo apt update` – Refresh the package list.
- `sudo apt install pkg` – Install a new package.
- `sudo apt upgrade` – Upgrade all installed packages.

## 🛠️ Redirection & Pipes

- `command > file` – Overwrite file with output.
- `command >> file` – Append output to the end of the file.
- `cmd1 | cmd2` – Pipe: Pass the output of cmd1 as input to cmd2.
- `tee file` – Display output and save it to a file simultaneously.

## ⌨️ Useful Shortcuts

- `Ctrl + C` – Stop the current command.
- `Ctrl + R` – Search your command history.
- `Tab` – Auto-complete file or command names.
- `!!` – Repeat the last command.
- `!$` – Use the last argument of the previous command.

## `jq` library

### Key `jq` Operations
- `.|keys` – Get all keys from an object.
- `.[]` – Iterate through array elements or object values.
- `length` – Get the length of an array or object.
- `reverse` – Reverse an array.
- `unique` – Get unique elements from an array.
- `min`, `max` – Find minimum or maximum value.
- `add` – Sum array elements.
- `has("key")` – Check if object has a specific key.
- `to_entries`, `from_entries` – Convert between objects and key-value pairs.

### Examples
- `cat file.json | jq '.'` – Pretty-print JSON (the `.` means "the whole object").
- `cat file.json | jq '.name'` – Extract the value of the `name` field.
- `cat file.json | jq '.[] | .id'` – Iterate through array items and extract the `id` field from each.
- `cat file.json | jq 'map(.price)'` – Create an array of all `price` values.
- `cat file.json | jq 'select(.age > 30)'` – Filter objects where age is greater than 30.
- `cat file.json | jq 'group_by(.category)'` – Group objects by a specific field.
- `cat file.json | jq '.[] | select(.status == "active")'` – Filter array items by a condition.
- `curl https://api.example.com/data | jq '.results[] | {name, email}'` – Extract specific fields from API response.

