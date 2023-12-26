from collections import defaultdict
import re

def parse_log_line(line):
    # Example log line: "Dec 26 06:46:12 overlord sshd[105736]: Accepted password for 4jai from 202.168.74.216 port 53656 ssh2"
    match = re.search(r'(?P<timestamp>\w+\s+\d+\s\d+:\d+:\d+)\s\w+\ssshd\[\d+\]:\s(?P<status>\w+)\spassword\sfor\s(?P<user>\S+)\sfrom\s(?P<ip>\S+)\sport\s\d+', line)
    if match:
        return match.group('timestamp'), match.group('status'), match.group('user'), match.group('ip')
    else:
        return None

def colorize(text, color):
    colors = {
        'green': '\033[92m',
        'red': '\033[91m',
        'end': '\033[0m',
    }
    return f"{colors[color]}{text}{colors['end']}"

def summarize_auth_log(log_path):
    success_attempts = defaultdict(int)
    fail_attempts = defaultdict(int)

    with open(log_path, 'r') as auth_log:
        for line in auth_log:
            log_info = parse_log_line(line)
            if log_info:
                timestamp, status, user, ip = log_info
                if status == 'Accepted':
                    success_attempts[(user, ip)] += 1
                elif status == 'Failed':
                    fail_attempts[(user, ip)] += 1

    print("Success Attempts:")
    for (user, ip), count in success_attempts.items():
        print(f"User: {user} | Status: {colorize('Accepted', 'green')} | IP: {colorize(ip, 'green')} | Attempts: {count}")

    print("\nFail Attempts:")
    for (user, ip), count in fail_attempts.items():
        print(f"User: {user} | Status: {colorize('Failed', 'red')} | IP: {colorize(ip, 'red')} | Attempts: {count}")

if __name__ == "__main__":
    log_path = "/var/log/auth.log"
    summarize_auth_log(log_path)
