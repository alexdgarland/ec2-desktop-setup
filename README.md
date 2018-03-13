# EC2 Desktop Setup

Automation to get a Linux desktop on AWS that you can RDP to from Windows. All setup can also be done from a Windows environment (hence why not using Ansible!) provided the prerequisites below are followed.

## Prerequisites

- Working AWS account!
- You have an EC2 key-pair created in AWS and the private key downloaded and saved off to ~/.ssh/$keypair_name.pem
- [Git Bash](https://gitforwindows.org) (or a similar Bash/SSH-on-Windows solution) installed.
- [Terraform](https://www.terraform.io) installed.
- A Github account, with at least one SSH key-pair set up and the private key stored under ~/.ssh on your local machine.

## Steps (Bash CLI)

1) Move to the "terraform" directory and run `terraform apply`. You will need to set variable "ec2-keypair-name", either from the command line or using a terraform.tfvars file (which will be gitignore'd if placed in the "terraform" folder). You can also set "instance-type" if you don't want to use the default (t2.micro).

This will create the Ubuntu EC2 instance (with required security group) and automatically write entries into your local ~/.ssh/config. **Please note that it will currently fully overwrite this file, so if you don't want that, back up your existing SSH config first and manually restore any additional entries you need!**

2) Run the deploy.sh script, with required arguments (in format key=value):
    - "-p" / "--password" - the password you want to set for the EC2 instance
    - "-k" / "--github-private-key" - the name of a private key file (assumed to be stored locally under ~/.ssh), the paired public key for which is registered with your Github account
    - "-c" / "--gitconfig" - the location of a Git (global) config file to use on the remote desktop

The script will execute remotely on the EC2 instance, installing packages and changing settings, and will reboot the machine when done.

3) Once the reboot is complete, open an SSH session using `ssh ec2-desktop-portforward` so it will pick up the SSH config (including port-forwarding). **This session will need to be open for the RDP connection to work.**

4) Open Remote Desktop Connection and connect to localhost:3388 - this will port-forward to XRDP on the EC2 instance. You can then login with username "ubuntu" and the password you selected in step 2. Ensure that port is set to "-1".

**NB:** If you want to SSH separately to the instance while port-forwarding is running, use `ssh ec2-desktop`.

## Cloning Github repos

A simple Ruby script is provided to quickly clone all repos a given from GitHub account (which needs to be the same account as the private key is set up for above, otherwise the cloning won't work). This will be automatically installed under ~/github-utils/clone-all-repos.rb on the remote machine and when run, repos will be added under ~/git.

The script needs to be run manually to provide username and password - usage is as follows:

```
Usage: clone-all-repos.rb [options]
    -u, --user USER                  GitHub username
    -p, --password PASSWORD          GitHub password
```
