import os
import json
import paramiko
from ftplib import FTP

class Bunch(object):
    def __init__(self, adict):
        self.__dict__.update(adict)

def echo(stdout):
    for e in stdout: print(e, end='')

def main():
    config = Bunch(json.load(open('_project-SinDHS.json', 'r')))
    os.system('bundle exec jekyll build')
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(config.host, username=config.ssh["user"], password=config.ssh["password"])
    stdin, stdout, stderr = ssh.exec_command('cd ' + config.dir + '; rm -rf *.* *')
    echo(stdout)
    os.chdir('_site')
    os.system('zip _site.zip -r *.*')
    with FTP(config.host, user=config.ftp["user"], passwd=config.ftp["password"]) as ftp:
        ftp.storbinary('STOR _site.zip', open('_site.zip', 'rb'))
    stdin, stdout, stderr = ssh.exec_command('cd ' + config.dir + '; unzip _site.zip')
    echo(stdout)
    ssh.close()

if __name__ == '__main__':
    main()