import argparse
import subprocess


def main():
    parser = argparse.ArgumentParser(
        description='Execute sncast command with parameters.')
    parser.add_argument(
        '--profile',
        type=str,
        required=True,
        help='Profile for the sncast command'
    )
    parser.add_argument(
        '--contract-address',
        type=str,
        required=True,
        help='Class hash for the deploy command'
    )
    parser.add_argument(
        '--function',
        type=str,
        required=True,
        help='Class hash for the deploy command'
    )
    parser.add_argument(
        '--calldata',
        type=str,
        nargs='+',
        help='Constructor calldata for the deploy command'
    )

    args = parser.parse_args()

    command = [
        'sncast',
        '--profile',
        args.profile,
        '--wait',
        'invoke',
        '--contract-address',
        args.contract_address,
        "--function",
        args.function,
        * (['--calldata', *args.calldata] if args.calldata else [])
    ]

    process = subprocess.Popen(
        command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    for line in iter(process.stdout.readline, b''):
        print(line.decode(), end='')


if __name__ == "__main__":
    main()
