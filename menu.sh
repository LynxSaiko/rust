#!/bin/bash

# Script to set up and configure a custom application menu in LFS like Dracos
# It will use GTK for the menu, update desktop directory, and icons (Papirus theme)

# Define Directories
MENU_DIR="/home/leakos/.local/share/menus"
DESKTOP_DIRECTORY_DIR="/home/leakos/.local/share/desktop-directories"
ICON_THEME_DIR="$HOME/.icons/Papirus"

# Create necessary directories if they don't exist
mkdir -p "$MENU_DIR" "$DESKTOP_DIRECTORY_DIR"

# Function to create directory file
create_directory_file() {
  cat << EOF > "$DESKTOP_DIRECTORY_DIR/$1.directory"
[Desktop Entry]
Version=1.0
Name=$2
Comment=$3
Icon=$4
Type=Directory
EOF
}

# Create the menu file (dracos-applications.menu)
cat << 'EOF' > "$MENU_DIR/dracos-applications.menu"
<?xml version="1.0"?>
<!DOCTYPE menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN" "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">
<menu>
  <name>Applications</name>

  <submenu>
    <name>Dracos Penetration Testing</name>
    <directory>Dracos.directory</directory>
    <layout>
      <menuname>Intelligent Scanning</menuname>
      <menuname>Vulnerability Assessment</menuname>
      <menuname>Penetration Testing</menuname>
      <menuname>Information Gathering</menuname>
      <menuname>Exploitation Tools</menuname>
      <separator/>
      <menuname>Web Application Analysis</menuname>
      <menuname>Password Cracking</menuname>
      <menuname>Forensics Tools</menuname>
      <menuname>Reverse Engineering</menuname>
      <menuname>Social Engineering</menuname>
      <separator/>
      <menuname>Sniffing & Spoofing</menuname>
      <menuname>Network Analysis</menuname>
      <menuname>Forensic Tools</menuname>
      <menuname>Automotive</menuname>
    </layout>

    <!-- Submenu for Vulnerability Assessment -->
    <menu>
      <name>Vulnerability Assessment</name>
      <directory>vuln-assess.directory</directory>
      <include>
        <and>
          <category>vulnerability-assessment</category>
        </and>
      </include>
    </menu>

    <!-- Submenu for Information Gathering -->
    <menu>
      <name>Information Gathering</name>
      <directory>info-gathering.directory</directory>
      <include>
        <and>
          <category>info-gathering</category>
        </and>
      </include>
    </menu>

    <!-- Submenu for Web Application Analysis -->
    <menu>
      <name>Web Application Analysis</name>
      <directory>webapp-analysis.directory</directory>
      <include>
        <and>
          <category>webapp-analysis</category>
        </and>
      </include>
    </menu>

    <!-- Additional submenus can be added here -->
  </submenu>

</menu>
EOF

echo "Menu file 'dracos-applications.menu' created."

# Create .directory files for each category
create_directory_file "Dracos" "Dracos Penetration Testing" "Penetration Testing Tools Suite" "dracos-icon"
create_directory_file "vuln-assess" "Vulnerability Assessment" "Tools for Vulnerability Assessment" "security"
create_directory_file "info-gathering" "Information Gathering" "Tools for Information Gathering" "network"
create_directory_file "webapp-analysis" "Web Application Analysis" "Tools for Analyzing Web Applications" "web"
create_directory_file "exploit-tools" "Exploitation Tools" "Tools for Exploiting Vulnerabilities" "network-server"
create_directory_file "social-engineering" "Social Engineering" "Tools for Social Engineering Attacks" "people"
create_directory_file "forensics-tools" "Forensic Tools" "Forensic Investigation Tools" "accessories-calculator"
create_directory_file "sniffing-spoofing" "Sniffing & Spoofing" "Tools for Sniffing and Spoofing Networks" "network-sniffer"

echo "Directory files created."

# Install Papirus Icons theme
echo "Installing Papirus icon theme..."
mkdir -p "$HOME/.icons"
git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git "$HOME/.icons/Papirus"

# Apply Papirus Icon theme (optional step, if using a desktop environment)
echo "Applying Papirus icon theme..."
gsettings set org.gnome.desktop.interface icon-theme "Papirus" # For GNOME
# For Xfce or other environments, adjust as needed.

# Update the desktop database
echo "Updating the menu and directory..."
update-desktop-database ~/.local/share/desktop-directories/

# Display success message
echo "Setup complete. The menu and directories have been configured successfully."
