echo "Enabling cockpit socket"
    systemctl enable cockpit.socket

echo "Enabling sshd service"  # For SSH access
    systemctl enable sshd

