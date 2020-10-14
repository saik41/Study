### Introduction to ansible
* we will get introduced to what Ansible is. If you're a systems engineer IT administrator just anybody working in IT, you're probably involved in doing a lot of repetitive tasks in your environment.
* Whether it be sizing creating new hosts virtual machines every day, find configurations on them, patching on hundreds of servers, migrations, deploying applications, even performing security compliance audits.
* All of these very repetitive tasks involve execution of hundreds of commands on hundreds of different servers while maintaining the right sequence of events, with system reboots whatnot in between. 
* Some people develop scripts to automate this task that requires coding skills and regular maintenance of these scripts, and a lot of time to put these scripts together on the first place. 
*  That's where Ansible helps. Ansible is a powerful IT automation tool that you can learn quickly.It's simple enough for everyone in IT, yet powerful enough to automate even the most complex deployments.In the past, something that took developing a complex script now takes just a few lines of instruction in an Ansible automation playbook.
- Whether you want to make that happen on your localhost on all of your database servers all of your web servers on cloud or just the ones on your DR environment, all it takes is modifying one line.
- 

### Ansible Inventory
* Ansible can work with one or multiple systems in your infrastructure at the same time.\
* In order to work with multiple servers, Ansible needs to establish connectivity to those servers.
* This is done using SSH for Linux and PowerShell remoting for windows. That's what makes Ansible agentless.
* Agentless means that you don't need to install any additional software on the target machines to be able to work with Ansible. A simple SSH connectivity would suffice Ansible's needs.
* One of the major disadvantages of most other orchestration tools is that you are required to configure an agent on the target systems before you can invoke any kind of automation.
* Now, information about these target systems is stored in an inventory file.If you don’t create a new inventory file,Ansible uses the default inventory file located at etc/ansible/host location.
* The inventory file is in an INI-like format. It's simply a number of servers listed one after the other. 
    eg: 
        34.56.678.34
        56.88.65.76
* You can also group different servers together.
   eg:
        [db]
        34.56.678.345
        56.88.65.76
* by defining it like this. Enter the name of the group within square brackets and define the list of servers part of that group in the lines below.
* You can have multiple groups defined in a single inventory file.
* For example, I have a list of servers named from one to four.However, I would like to refer to these servers in Ansible using an alias such as web server or database server.
* I could do this by adding an alias for each server at the beginning of the line and assigning the address of that server to ansible_host parameter.

web ansible_host=56.88.65.76
db  ansible_host= 34.56.678.34
mail ansible_host= 56.76.87.98
web2 ansible_host= 13.46.86.72

* Ansible_host is an inventory parameter used to specify the FQDN or IP Address of a server.
* Inverntory Parameters
- ansible_connection - ssh/winrm/localhost 
- ansible_port - 22/5986
- ansible_user - root/administrator
- ansible_ssh_pass - <Password>
- ansible_host - <IP/HOSTNAME>

## Ansible_connection
* Ansible connects to the target server. As we discussed in the previous slide, is this a SSH connection to a Linux server or a WinRM connection to a Windows server. This is how we define if the target host we wish to connect to is a Linux or a Windows host.

## Ansible_host
* It defines,how Ansible connects to the target server.As we discussed in the previous slide, is this a SSH connection to a Linux server or a WinRM connection to a Windows server.

- This is how we define if the target host we wish to connect to is a Linux or a Windows host.

- You could also set it to localhost to indicate that we would like to work with the localhost and not connect to any remote hosts.If you don’t have multiple servers to play around with, you could simply start with a localhost in your inventory file.

## Ansible_Port
* It defines which port to connect to. By default, it is set to port 22 for SSH, but if you need to change you can set it differently using Ansible_port parameter.

## Ansible_user
* Ansible_user defines the user used to make remote connections.By default, this is set to root for Linux machines.If you need to change this,define it as shown here.

## Ansible _SSH_Pass
* Ansible_SSH_pass defines the SSH password for Linux. Note that storing passwords in plain text format like this may not be very ideal. The best practice is to set up SSH key-based passwordless authentication between the servers, and you should definitely do that in your production or corporate environments. For now, we want to start with the absolute basics of Ansible without getting too much into security or other topics. To begin with, we'll start with a really basic setup with a username and password.


### YAML
* 




### Ansible Playbook
* We are going to see two ways of running Ansible. First, using the Ansible command and then using the Ansible playbook command.
* Sometimes you may want to use Ansible for a one-off task such as to test connectivity between the Ansible controller and the targets or to run the command, say for example,to shut down a set of servers. In that case, you can get away without writing a playbook by running the Ansible command followed by the host and the command to reboot the host.

eg: ansible <hosts> -a <command>
    ansible all -a "sbin/reboot"
    ansible <hosts> -m <module>
    ansible target1 -m ping

* This is an imperative style of execution. There are no playbooks involved. You're running separate Ansible commands for each operation. This is not an ideal use case of Ansible unless you wish to use it for exceptional cases. The real usage of Ansible is with playbooks.
* Ping to hosts without playbook:
    ansible all -m ping -i inventory.txt

* 
