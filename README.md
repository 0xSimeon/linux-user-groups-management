Sure, here's a simple README for your GitHub repository:

---

# User and Group Management Script

This script automates the creation of users and groups on a Linux system based on input from a text file. It generates random passwords for the users, sets up their home directories, and logs all actions taken. Additionally, it ensures secure storage of the generated passwords.

## Features

- Create users and their home directories.
- Create groups and assign users to them.
- Generate random passwords for users.
- Log all actions to a log file.
- Store passwords securely.

## Prerequisites

To successfully run this script, you need the following:
- A Linux machine with root privileges.
- Basic knowledge of Bash commands and scripting.
- A text editor of choice (vi, nano, vim, etc).

## Usage

1. Clone the repository:
    ```bash
    git clone git@github.com:0xSimeon/linux-user-groups-management.git
    cd linux-user-groups-management
    ```

2. Ensure the script has execute permissions:
    ```bash
    chmod +x create_users.sh
    ```

3. Prepare your input file (`users.txt`) with the following format:
    ```plaintext
    username;group1,group2,...
    ```
    Example:
    ```plaintext
    nelson;cloudeng,sre
    victor;backend
    john;qa
    jane;dev,manager
    robert;marketing
    emily;design,research
    michael;devops
    olivia;design,research
    william;support
    sophia;content,marketing
    daniel;devops,sre
    ava;dev,qa
    ```

4. Run the script:
    ```bash
    sudo ./create_users.sh users.txt
    ```

## Log File

The script logs its actions to `/var/log/user_management.log`.

## Password Storage

The generated passwords are stored securely in `/var/secure/user_passwords.txt`. Ensure this file is protected and accessible only by root.

## Technical Article

For a detailed explanation of the script, its features, and how it works, please refer to the technical article [here](https://dev.to/simeon4real/automating-user-and-group-management-with-bash-scripting-51jg).

## License

This project is licensed under the MIT License.

