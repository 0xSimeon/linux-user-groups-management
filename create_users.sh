#!/bin/bash

# Check if the script is run as root
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Check if exactly one argument is passed and it is not empty
if [[ $# -ne 1 ]] && [[ -z "$1" ]]; then
    echo "Usage: $0 <name-of-text-file>"
    exit 1
fi

# Assigning file paths to variables
INPUT_FILE="$1"
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"

# Ensure the /var/secure directory exists with appropriate permissions
if [[ ! -d "/var/secure" ]]; then
    mkdir -p /var/secure
    chown root:root /var/secure
    chmod 700 /var/secure
fi

# Create or clear the log and password files, and set appropriate permissions
touch "$LOG_FILE" "$PASSWORD_FILE"
chmod 600 "$PASSWORD_FILE"

# Function to log messages
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

# Function to generate random passwords
generate_password() {
    tr -dc 'A-Za-z0-9!@#$%^&*()_+=-[]{}|;:<>,.?/~' </dev/urandom | head -c 16
}

# Process the input file
while IFS=";" read -r user groups; do
    # Remove whitespace from user and groups
    user=$(echo "$user" | xargs)
    groups=$(echo "$groups" | xargs)

    # Check for a valid username
    if [[ -z "$user" ]]; then
        log_message "Invalid username. Skipping user creation."
        continue
    fi

    # Create a personal group for the user
    if ! getent group "$user" >/dev/null; then
        groupadd "$user"
        log_message "Group $user created."
    fi

    # Create the user and add to their personal group
    if ! id "$user" >/dev/null 2>&1; then
        useradd -m -g "$user" "$user"
        log_message "User $user created with home directory and added to group $user."
    else
        log_message "User $user already exists. Skipping user creation."
        continue
    fi

    # Generate a password for the user
    password=$(generate_password)
    echo "$user:$password" | chpasswd
    log_message "Password set for user $user."

    # Save the password to the password file
    echo "$user:$password" >> "$PASSWORD_FILE"

    # Add user to specified groups
    IFS=',' read -ra group_list <<< "$groups"
    for group in "${group_list[@]}"; do
        group=$(echo "$group" | xargs)
        if [[ -n "$group" ]]; then
            if ! getent group "$group" >/dev/null; then
                groupadd "$group"
                log_message "Group $group created."
            fi
            usermod -aG "$group" "$user"
            log_message "User $user added to group $group."
        fi
    done

done < "$INPUT_FILE"

log_message "User and group creation completed successfully."
echo "User and group creation completed successfully."
