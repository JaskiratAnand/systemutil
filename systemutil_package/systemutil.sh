#!/bin/bash

VERSION="v0.1.0"

show_help() {
    echo "systemutil - Custom Linux Command"
    echo "Version: $VERSION"
    echo
    echo "Usage: systemutil [options]"
    echo
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -v, --version   Display the version"
    echo "  cpu getinfo     Display CPU information"
    echo "  memory getinfo  Display memory information"
    echo "  user create     Create a new user"
    echo "  user list       List all regular users"
    echo "  user list --sudo-only  List users with sudo permissions"
    echo "  user remove     Remove a user"
    echo "  file getinfo [options] <file-name>"
    echo "    Options:"
    echo "      --size, -s             Print file size"
    echo "      --permissions, -p     Print file permissions"
    echo "      --owner, -o            Print file owner"
    echo "      --last-modified, -m   Print last modification time"
    echo
    echo "Examples:"
    echo "  systemutil -v"
    echo "  systemutil cpu getinfo"
    echo "  systemutil memory getinfo"
    echo "  systemutil user create <username>"
    echo "  systemutil user list"
    echo "  systemutil user list --sudo-only"
    echo "  systemutil user remove <username>"
    echo "  systemutil file getinfo -s <file-name>"
    echo "  systemutil file getinfo -p -o -m <file-name>"
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

