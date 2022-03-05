# WSL2 install scripts
* wsl_install_script.ps1 --> Script to install WSL2 and fonts.
* install_script.sh --> Script to install the essentials tools in a wsl2 ubuntu machine.

# Instructions
## Powershell script
### Basic usage
1. Copy the wsl_script.ps1 in your desktop directory.
2. Execute the script with powershell.
3. The script will be executed with admin privileges.
4. Select your choice.

### Known bugs 🐛

* **Permission denied**.

**Description**: The powershell script window is closed after be opened.

**Solution**:

Execute the next command as administrator:

```ps
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
```

**Undo solution**:

Execute the next command as administrator:

```ps
Set-ExecutionPolicy -ExecutionPolicy Undefined
```

## Bash script
### Basic usage
1. Copy the install_script.sh in your home directory.
2. Run the following command to allow the execution of the script.
```bash
chmod u+x install_script.sh
```
3. Run the script with the following command.
```
./install_script.sh
```
4. Select your choice (The first one install every other one).

### Known bugs 🐛

* **apt_pkg error**.

**Description**: Executing an unknown command in the terminal gives an apt_pkg error

**Solution**: Execute the penultimate option of the script "Fix APT PKG".
