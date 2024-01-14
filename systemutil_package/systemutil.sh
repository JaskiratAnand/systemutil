#!/bin/bash

VERSION="v0.1.0"

show_help() {
    cat <<EOL
systemutil - Custom Linux Command
Version: $VERSION

Usage: systemutil [options] <command> [command_options]

Options:
  -h, --help      Show this help message
  -v, --version   Display the version

Commands:
  cpu getinfo            Display CPU information
  memory getinfo         Display memory information
  user create <username> Create a new user
  user list              List all regular users
  user list --sudo-only  List users with sudo permissions
  user remove <username> Remove a user
  file getinfo [options] <file-name>
    Options:
      --size, -s             Print file size
      --permissions, -p     Print file permissions
      --owner, -o            Print file owner
      --last-modified, -m   Print last modification time

Examples:
  systemutil -v
  systemutil cpu getinfo
  systemutil memory getinfo
  systemutil user create john_doe
  systemutil user list
  systemutil user list --sudo-only
  systemutil user remove john_doe
  systemutil file getinfo -s example.txt
  systemutil file getinfo -p -o -m example.txt
EOL
}

show_version() {
    echo "systemutil version $VERSION"
}

get_cpu_info() {
    lscpu
}

get_memory_info() {
    free -h
}

create_user() {
    if [ -z "$2" ]; then
        echo "Error: Missing username. 
            Use 'systemutil user create <username>'."
        exit 1
    fi

    username=$2
    sudo useradd -m -s /bin/bash "$username"
    sudo passwd "$username"
    echo "User $username created successfully."
}

list_users() {
    getent passwd | grep -vE '/(nologin|false)$' | cut -d: -f1
}

list_sudo_users() {
    getent passwd | sudo -l | grep -E '^[a-zA-Z0-9_-]+:' | cut -d: -f1
}

remove_user() {
    if [ -z "$2" ]; then
        echo "Error: Missing username. 
            Use 'systemutil user remove <username>'."
        exit 1
    fi

    username=$2
    sudo userdel -r "$username"
    echo "User $username removed successfully."
}

file_getinfo() {
    local size_option=false
    local permissions_option=false
    local owner_option=false
    local last_modified_option=false

    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -s|--size)
                size_option=true
                shift
                ;;
            -p|--permissions)
                permissions_option=true
                shift
                ;;
            -o|--owner)
                owner_option=true
                shift
                ;;
            -m|--last-modified)
                last_modified_option=true
                shift
                ;;
            *)
                filename="$1"
                shift
                ;;
        esac
    done

    if [ -z "$filename" ]; then
        echo "Error: Missing file name. 
            Use 'systemutil file getinfo [options] <file-name>'."
        exit 1
    fi

    if [ ! -e "$filename" ]; then
        echo "Error: File '$filename' not found."
        exit 1
    fi

    echo "File: $filename"
    
    if [ "$size_option" = true ]; then
        echo "Size(B): $(stat -c %s "$filename")"
    fi

    if [ "$permissions_option" = true ]; then
        echo "Permissions: $(stat -c %A "$filename")"
    fi

    if [ "$owner_option" = true ]; then
        echo "Owner: $(stat -c %U "$filename")"
    fi

    if [ "$last_modified_option" = true ]; then
        echo "Last Modified: $(stat -c %y "$filename")"
    fi
}

# parsing command-line for agrs
case "$1" in
    -h|--help)
        show_help
        ;;
    -v|--version)
        show_version
        ;;
    cpu)
        shift
        case "$1" in
            getinfo)
                get_cpu_info
                ;;
            *)
                echo "Error: Invalid CPU command. 
                    Use 'systemutil cpu getinfo'."
                exit 1
                ;;
        esac
        ;;
    memory)
        shift
        case "$1" in
            getinfo)
                get_memory_info
                ;;
            *)
                echo "Error: Invalid memory command. 
                    Use 'systemutil memory getinfo'."
                exit 1
                ;;
        esac
        ;;
    user)
        shift
        case "$1" in
            create)
                create_user "$@"
                ;;
            list)
                list_users
                ;;
            --sudo-only)
                list_sudo_users
                ;;
            remove)
                remove_user "$@"
                ;;
            *)
                echo "Error: Invalid user command. 
                    Use 'systemutil user create <username>', 
                    'systemutil user list', 
                    'systemutil user list --sudo-only', 
                    or 'systemutil user remove <username>'."
                exit 1
                ;;
        esac
        ;;
    file)
        shift
        case "$1" in
            getinfo)
                file_getinfo "$@"
                ;;
            *)
                echo "Error: Invalid file command. 
                    Use 'systemutil file getinfo [options] <file-name>'."
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Error: Invalid command. 
            Use 'systemutil -h' for help."
        exit 1
        ;;
esac

exit 0

