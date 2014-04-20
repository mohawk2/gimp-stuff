import os

env = Environment(CPPFLAGS=['-Wall','-g'])

def phtml_to_html(target, source, env):
  os.system("perl eperl {source} > {target}".format(source=source[0],
                                                    target=target[0]))

for f in env.Glob('*.phtml'):
  env.Command(str(f).replace('phtml','html'),
              [f],
              phtml_to_html)

