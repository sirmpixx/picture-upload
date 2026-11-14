# picture-upload

Screenshot capture and automatic upload to a web server with clipboard link.

## Description

A bash script that opens KDE Spectacle in region-capture mode, saves the screenshot locally, uploads it to a web server via SCP, and copies the public URL directly to your clipboard — ready to share instantly.

## Getting Started

### Dependencies

* Linux with KDE Plasma (Wayland or X11)
* `spectacle` — KDE screenshot tool
* `wl-clipboard` — Wayland clipboard support (`wl-copy`)
* `openssh` — for `scp` file transfer

```
sudo pacman -S spectacle wl-clipboard xclip libnotify openssh
```

### Setup

* Clone or download this repository
* Copy the example config to your config directory (kept outside the repo, so no personal data is ever committed):

```
mkdir -p ~/.config/picture-upload
cp config.example ~/.config/picture-upload/config
```

* Edit `~/.config/picture-upload/config` (a different path can be set via `PICTURE_UPLOAD_CONFIG`):

```bash
SFTP_HOST="example.com"
SFTP_USER="your_user"
SFTP_REMOTE_PATH="/var/www/html/screenshots"
BASE_URL="https://example.com/screenshots"
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
SFTP_KEY=""   # optional: path to a non-default SSH key
```

* Make the script executable:
```
chmod +x upload.sh
```

### Running Script

* Run from terminal or bind to a keyboard shortcut in KDE System Settings → Shortcuts → Custom Shortcuts
* Step-by-step:
  1. Script launches Spectacle in region-capture mode
  2. Draw your selection and confirm the screenshot
  3. File is saved as `YYYY-MM-DD-HH-MM-SS.jpg` to your configured directory
  4. File is uploaded to your web server via SCP
  5. Public URL is copied to clipboard and a notification appears

```
bash upload.sh
```

## Help

Make sure the remote directory exists on your server before the first run:
```
ssh user@example.com "mkdir -p /var/www/html/screenshots"
```

## Authors

[@sirmpixx](https://github.com/sirmpixx)

## Version History

* Version 1.0: First Creation
* Version 1.1: Configuration moved to an external config file

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Acknowledgments

* [README-Template](https://gist.github.com/DomPizzie/7a5ff55ffa9081f2de27c315f5018afc)
