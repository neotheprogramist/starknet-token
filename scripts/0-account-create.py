import argparse
import subprocess


def main():
    parser = argparse.ArgumentParser(
        description='Execute sncast command with parameters.')
    parser.add_argument(
        '--url',
        type=str,
        default="https://starknet-testnet.public.blastapi.io/rpc/v0_6",
        help='URL for the sncast command'
    )
    parser.add_argument(
        '--name',
        type=str,
        required=True,
        help='Name for the account creation'
    )
    parser.add_argument(
        '--disable-add-profile',
        action='store_true',
        help='Disable add profile flag'
    )

    args = parser.parse_args()

    command = [
        'sncast',
        '--url',
        args.url,
        'account',
        'create',
        *(['--add-profile'] if not args.disable_add_profile else []),
        '--name',
        args.name,
    ]

    process = subprocess.Popen(
        command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    for line in iter(process.stdout.readline, b''):
        print(line.decode(), end='')


if __name__ == "__main__":
    main()
