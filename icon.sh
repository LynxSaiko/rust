#!/bin/bash

# Script to set up GTK 2.0 theme and icons in LFS
# This script downloads, extracts and configures GTK 2.0 themes and icons from GNOME Look

# Define Directories
THEME_DIR="/home/leakos/.themes"
ICON_DIR="/home/leakos/.icons"
GTKRC_FILE="/home/leakos/.gtkrc-2.0"

# Make sure the directories exist
mkdir -p "$THEME_DIR" "$ICON_DIR"

# Function to download and extract theme and icon
download_and_extract() {
  local url=$1
  local extract_dir=$2

  # Download the theme/icon package
  echo "Downloading theme/icon package from $url..."
  wget "$url" -O /tmp/theme-package.tar.gz

  # Extract the downloaded package
  echo "Extracting the package..."
  tar -xvzf /tmp/theme-package.tar.gz -C "$extract_dir"

  # Clean up
  rm /tmp/theme-package.tar.gz
}

# Function to create .gtkrc-2.0 file for GTK 2.0 configuration
create_gtkrc() {
  cat << EOF > "$GTKRC_FILE"
# GTK 2.0 Theme
gtk-theme-name="NamaTemaGTK2"  # Replace with the theme name
gtk-icon-theme-name="NamaIkonGTK2"  # Replace with the icon theme name
gtk-font-name="Sans 10"
gtk-toolbar-style=GTK_TOOLBAR_ICONS
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE
gtk-menu-images=1
gtk-button-images=1
EOF

  echo "GTK 2.0 configuration written to $GTKRC_FILE."
}

# Step 1: Download and extract theme and icon
# Example URLs - replace these with the actual URL you want to download from GNOME Look
THEME_URL="https://example.com/theme-package.tar.gz"  # Replace with the actual theme URL
ICON_URL="https://example.com/icon-package.tar.gz"    # Replace with the actual icon URL

# Download and extract the theme and icon package
download_and_extract "$THEME_URL" "$THEME_DIR"
download_and_extract "$ICON_URL" "$ICON_DIR"

# Step 2: Create and configure .gtkrc-2.0
create_gtkrc

# Step 3: Apply theme and icons system-wide (Optional)
# You can copy the theme and icon files to system-wide directories if you need
# sudo cp -r "$THEME_DIR/NamaTemaGTK2" /usr/share/themes/
# sudo cp -r "$ICON_DIR/NamaIkonGTK2" /usr/share/icons/

# Step 4: Restart GNOME or Xfce to apply the changes
# If you're using GNOME, you can restart GNOME Shell
# gnome-shell --replace &

# If you're using Xfce, log out and log back in to apply the changes

# Display success message
echo "GTK 2.0 theme and icon configuration completed successfully."

