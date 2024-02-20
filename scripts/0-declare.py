import argparse
import subprocess


def main():
    parser = argparse.ArgumentParser(
        description='Execute sncast command with parameters.')
    parser.add_argument(
        '--profile',
        type=str,
        required=True,
        help='Profile name'
    )
    parser.add_argument(
        '--contract-name',
        type=str,
        required=True,
        help='Contract name'
    )

    args = parser.parse_args()

    command = [
        'sncast',
        '--profile',
        args.profile,
        '--wait',
        'declare',
        '--contract-name',
        args.contract_name,
    ]

    process = subprocess.Popen(
        command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    for line in iter(process.stdout.readline, b''):
        print(line.decode(), end='')


if __name__ == "__main__":
    main()
