# Recycle-and-Restore
This project aims to address the problem of the lack of a recycle bin functionality in UNIX command line systems. When a file or directory is deleted using the `rm` command, it is permanently removed and cannot be easily restored. The goal of this project is to create a recycle script and a restore script that provide users with a safe and convenient way to delete and restore files.

## Basic Functionality

### recycle Script
The `recycle` script mimics the `rm` command by moving files to a recycle bin instead of permanently deleting them. The script follows these specifications:

1. Script Name: `recycle`
   - The script should be stored in the directory `$HOME/project`.

2. Recycle Bin Directory: `$HOME/recyclebin`
   - The script should create this directory if it does not exist.

3. Command Line Argument:
   - The script should accept the name of a file as a command line argument, similar to `rm`.
   - The script should be executed as follows: `bash recycle fileName`

4. Error Conditions:
   - The script must handle the following error conditions and display appropriate error messages, similar to `rm`:
     - No filename provided: Display an error message if no filename is provided as an argument and set an error exit status.
     - File does not exist: Display an error message if the specified file does not exist and terminate the script.
     - Directory name provided: Display an error message if a directory name is provided instead of a filename and terminate the script.
     - Prevent deletion of the recycle script: Test if the file being deleted is the `recycle` script itself. If it is, display the error message "Attempting to delete recycle – operation aborted" and terminate the script. Ensure you create a hard link to your script before testing this functionality.

5. File Naming in the Recycle Bin:
   - Files in the recycle bin should follow the format: `fileName_inode`
   - For example, if a file named `f1` with inode `1234` is recycled, the file in the recycle bin should be named `f1_1234`.
   - This naming convention prevents conflicts when deleting files with the same name.
   - The recycle bin should only contain files, not directories.

6. Restore Information:
   - Create a hidden file called `.restore.info` in `$HOME`.
   - Each line of this file should contain the name of the file in the recycle bin, followed by a colon, and then the original absolute path of the file.
   - For example, if a file called `f1` with inode `1234` was recycled from the directory `/home/trainee1`, the `.restore.info` file should contain:
     ```
     f1_1234:/home/trainee1/f1
     ```
   - If another file named `f1` with inode `5432` was recycled from the directory `/home/trainee1/testing`, the `.restore.info` file should contain:
     ```
     f1_1234:/home/trainee1/f1
     f1_5432:/home/trainee1/testing/f1
     ```
     
Multiple Files, Wildcards, and Option Flags


1. Handling Multiple Files and Wildcards:
   - The script should be able to recycle multiple files, even if some of the files provided do not exist.
   - Wildcards should work, similar to the behavior of `rm`.

2. Interactive Mode (-i Option):
   - The script should allow the user to use the `-i` option.
   - If the option is used, the script should prompt the user for confirmation, similar to `rm -i`.
   - A response beginning with 'y' or 'Y' should indicate confirmation (yes), while all other responses should indicate cancellation (no).

3. Verbose Mode (-v Option):
   - The script should allow the user to use the `-v` option.
   - If the option is used, the script should display a message confirming the deletion, similar to `rm -v`.

4. Option Order:
   - The script should work correctly regardless of the order of the options.
   - Both `-i` and `-v` options should function correctly when used together or separately.
   - For example, both `recycle -iv` and `recycle -vi` should work as expected.

5. Invalid Option Handling:
   - If an invalid option is passed into the script, the script should display an error message showing the offending option value and terminate with a non-zero exit status, similar to `rm`.


### restore Script
The `restore` script is responsible for restoring individual files back to their original location. The script should adhere to the following specifications:

1. Script Name: `restore`
   - The script should be stored in the directory `$HOME/project`.

2. Command Line Argument:
   - The script should accept the name of a file in the recycle bin as a command line argument.
   - The script should be executed as follows: `bash restore f1_1234`
   - The argument represents the name of the file in `$HOME/recyclebin` that

 needs to be restored.

3. Restoring Files:
   - The script should restore the file to its original location using the pathname stored in the `.restore.info` file.

4. Error Conditions:
   - The script must handle the following error conditions and display appropriate error messages, similar to `rm`:
     - No filename provided: Display an error message if no file is provided as an argument and set an error exit status.
     - File does not exist: Display an error message if the specified file does not exist and terminate the script.

5. File Overwrite:
   - The script should check if the file being restored already exists in the target directory.
   - If the file exists, the user should be asked: "Do you want to overwrite? y/n"
   - The script should restore the file if the user types 'y', 'Y', or any word beginning with 'y' or 'Y' as a response to this prompt.
   - If any other response is provided, the file should not be restored.

6. `.restore.info` Updates:
   - After successfully restoring the file, the entry in the `.restore.info` file should be deleted.
