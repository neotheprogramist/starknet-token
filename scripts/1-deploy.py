import argparse
import subprocess


def parse_string_variant(string: str) -> str:
    if string.isdecimal():
        try:
            value = int(string)
            return f"{value:#x}"
        except ValueError:
            pass
    if string.startswith("0x"):
        try:
            value = int(string, 16)
            return f"{value:#x}"
        except ValueError:
            pass
    return f"0x{bytes(string, "ascii").hex()}"


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
        '--class-hash',
        type=str,
        required=True,
        help='Class hash for the deploy command'
    )
    parser.add_argument(
        '--constructor-calldata',
        type=str,
        nargs='+',
        required=True,
        help='Constructor calldata for the deploy command'
    )

    args = parser.parse_args()

    command = [
        'sncast',
        '--profile',
        args.profile,
        '--wait',
        'deploy',
        '--class-hash',
        args.class_hash,
        *(['--constructor-calldata', *[parse_string_variant(s) for s in args.constructor_calldata]] if args.constructor_calldata else [])
    ]

    process = subprocess.Popen(
        command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    for line in iter(process.stdout.readline, b''):
        print(line.decode(), end='')


if __name__ == "__main__":
    main()
