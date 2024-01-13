# systemutil

`systemutil` is a custom Linux command-line utility designed to provide various system-related functionalities. It is a versatile script that allows users to retrieve information about the CPU, memory, manage users, and obtain details about files.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Options](#options)


## Features

- Display CPU information using `lscpu`.
- Display memory information using `free -h`.
- Create new users and remove existing users.
- List all regular users or those with sudo permissions.
- Retrieve file information including size, permissions, owner, and last modification time.

## Installation

1. Clone the repository & run the following commands:
 ```bash
   git clone https://github.com/JaskiratAnand/systemutil
   cd systemutil_package
   ./install.sh
```
OR
2. Download .tar.gz package & run the following commands
```bash
  wget "https://github.com/JaskiratAnand/systemutil/blob/main/systemutil_package.tar.gz"
  tar -xzvf systemutil_package.tar.gz
  cd systemutil_package
  ./install.sh
```

## Usage 

* Display the version.
```bash
  systemutil -v
```
* Display CPU information.
```bash
  systemutil cpu getinfo
```
* Create a new user.
```bash
  systemutil user create <username>
```
* Show user list
```bash
  systemutil user list
  systemutil user list --sudo-only
```
* Remove a user
```bash
  systemutil user remove <username>
```
* Get detailed information about a file.
```bash
  systemutil file getinfo -s -p -o -m <file-name>
```

## Options

* -h, --help: Display help message.
* -v, --version: Display the version.
