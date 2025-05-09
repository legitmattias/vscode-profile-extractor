# VS Code Profile Extension Extractor

A Bash script for extracting and listing installed extensions from `.code-profile` files exported from Visual Studio Code. The script supports basic, verbose, and debug output modes, making it useful for quick summaries or deeper inspection of extension metadata.

## Features

* Lists installed extensions from a `.code-profile` file
* Displays profile metadata (name and icon)
* `--verbose`: Shows each extension’s ID and UUID
* `--debug`: Outputs full raw data from the profile for troubleshooting

## Usage

```bash
./parse-profile.sh <profile-file> [--verbose] [--debug]
```

> **_NOTE:_** Before running the script, ensure it has execution permissions: `chmod +x parse-profile.sh`

### Arguments

* `<profile-file>`: Path to the `.code-profile` file you want to inspect.
* `--verbose`: (Optional) Show extended extension metadata: extension ID and UUID.
* `--debug`: (Optional) Show raw JSON metadata from the profile.

You can combine `--verbose` and `--debug`:

```bash
./parse-profile.sh ./MyProfile.code-profile --verbose --debug
```

## Requirements

* `jq`: Command-line JSON processor
* Bash-compatible shell

## Examples

### Default Output

```bash
./parse-profile.sh ./IoT.code-profile
```

**Output:**

```
Profile Metadata:
Profile Name: IoT
Profile Icon: robot

Installed Extensions:
Docker Explorer
GitHub Copilot
GitHub Copilot Chat
REST Client
Monokai Pro
No Display Name found. Identificational name: moozzyk.arduino
Docker
Python Debugger
Python
Pylance
Dev Containers
Remote - SSH
Remote - SSH: Editing Configuration Files
WSL
Remote Development
C/C++
Remote Explorer
Remote - Tunnels
Serial Monitor
MicroPico
PlatformIO IDE
YAML
```

### Verbose Output

```bash
./parse-profile.sh ./IoT.code-profile --verbose
```

**Output (excerpt):**

```
Profile Metadata:
Profile Name: IoT
Profile Icon: robot

Installed Extensions:
ID: formulahendry.docker-explorer, Name: Docker Explorer, UUID: 96c69be9-5b09-4a18-8c82-4d30ab145017
ID: github.copilot, Name: GitHub Copilot, UUID: 23c4aeee-f844-43cd-b53e-1113e483f1a6
ID: github.copilot-chat, Name: GitHub Copilot Chat, UUID: 7ec7d6e6-b89e-4cc5-a59b-d6c4d238246f
...
```

### Debug Output

```bash
./parse-profile.sh ./IoT.code-profile --debug
```

Appends full parsed JSON content to the output, useful for troubleshooting or inspecting profile format changes.

## License

MIT License