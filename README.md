# ec2-desktop-setup

To get a Linux desktop that you can RDP to from Windows:

1) Install [Git Bash](https://gitforwindows.org) (or a similar Bash/SSH-on-Windows solution).

2) Spin up an Ubuntu instance in AWS, making sure you take a note of the URL for it and have saved off the private key (PEM) that you need to connect to your local ~/.ssh directory. We will use port-forwarding to connect RDP, so the only port that needs to be enabled on the Security Group is 22 (default SSH).

There is a [Terraform](https://www.terraform.io) script provided that will create the AWS resources (security group, EC2 instance) as long as a key pair already exists and you set the Terraform variable "ec2-keypair-name" to match it.

3) Use the ssh-config-template.txt file, copying the entry into your ~/.ssh/config file (create it if it doesn't exist) and adding the details of the EC2 URL and key file name noted in step 2.

4) Through Git Bash on your Windows machine, run the deploy_over_ssh.sh script, passing the password you want to set for the EC2 instance as the first argument. The script will execute remotely on the EC2 instance, installing packages and changing settings, and will reboot the machine will done.

5) Once the reboot is complete, open an SSH session (again through Git Bash), simply using "ssh ec2-desktop" so it will pick up the SSH config (including port-forwarding) we set up in step 3. **This session will need to be open for the RDP connection to work.**

6) Open Remote Desktop Connection and connect to 127.0.0.1:3388 - this will port-forward to XRDP on the EC2 instance. You can then login with username "ubuntu" and the password you selected in step 4. Ensure that port is set to "-1".
