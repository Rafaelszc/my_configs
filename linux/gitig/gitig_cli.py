import click
from glob import glob
import sys
from os import system

@click.command()
@click.option("-l", help="Language compatible to gitignore")
def get_file(l: str):
    l = l.title().strip()

    templates_path = sys.argv[0].replace("gitig_cli.py", "templates")

    file = glob(f"{templates_path}/{l}*.gitignore")

    if file != []:
        file = file[0]
    else:
        return click.echo("Invalid lang")

    with open(file, "r") as file:
        gitignore = file.read()

        with open(".gitignore", "w") as gitig:
            gitig.write(gitignore)

if __name__=="__main__":
    get_file()