# Shell Scripts

Welcome to my shell (Bash and KornShell) scripts repository! 
This repository collects scripts for automating various system and administration tasks.

## Contents

The repository contains the following scripts:

1. **Script Bash (bash)**
   - `geolocip.bash`: Script that uses ip-api.com to detect information about a specific ip.
   - `rclone_sftp.bash`: Script that uses rclone to be able to mount remote resources.

2. **Script KornShell (ksh)**
   - `restic_backup.ksh`: Script that uses restic and rclone to make system backups.
   - `nfs_mount.ksh`: Script that mount a nfs resource.

## Requirements

To run these scripts, you must have installed:

- Bash (version 5.2.21 or higher) for `.bash` scripts OR KornShell (version 5.2.14) for `.ksh` scripts.
- Other programs required by each script, I recommend to read the script file for more information.

## Installation.

1. Clone the repository:
    ```bash
    git clone https://github.com/rmbagnato/shell.git
    cd shell
    ```

2. Make sure the scripts have execution permissions:
    ```bash
    chmod +x *.bash *.ksh
    ```

## Usage

Each script has its own method of execution. For more details i recommend to read the script file.

## License

This project is distributed under the BSD license. See the [LICENSE](https://github.com/rmbagnato/shell/blob/main/LICENSE) file for more details.

## Contacts.

If you have any questions or suggestions, you can contact me at [software@rmbagnato.eu](mailto:software@rmbagnato.eu).
