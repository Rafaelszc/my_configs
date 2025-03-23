import click
from glob import glob
import sys

@click.command()
@click.option("-l", type=str, default=None, help="Language compatible to gitignore")
@click.argument("lang", type=str, required=False)
def get_file(l: str, lang: str):
    l = l.title().strip() if l != None else lang.title().strip()

    templates_path = sys.argv[0].replace("gitig_cli.py", "templates")

    file = glob(f"{templates_path}/{l}*.gitignore")

    if file != []:
        file = file[0]
    else:
        return click.echo("Invalid lang")

    with open(file, "r") as file:
        gitignore = file.read()

        with open(".gitignore", "a") as gitig:
            gitig.write(gitignore)

if __name__=="__main__":
    get_file()