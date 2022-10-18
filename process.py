
import sys
import os
from bs4 import BeautifulSoup

def remove_tag(txt):
  html = BeautifulSoup(txt, 'html.parser')
  return html.get_text().strip().replace('\n', ' ').replace('"', '\'').replace('\\','')

def export(file):
  type = file.split(".")[0]
  print(f"process {type} from {file}")
  result = type+'.json'
  with open(file) as input_reader, open(file = result, mode = 'w') as result_writer:
    result_writer.write('{"index":"Dictionary","records":[\n')
    is_key = True
    key, value = '',''
    for line in input_reader:
      if (is_key):
        key = line.strip()
        value=''
        is_key = False
      elif line != '</>\n':
        value += line
      else:
        is_key = True
        result_writer.write('{"1藏文":"%s","2释义":"%s","来源":"%s"},\n'%(remove_tag(key), remove_tag(value), type))
    result_writer.write('{}]}\n')
  return result

if __name__ == '__main__':
    kwargs={kw[0]:kw[1] for kw in [ar.split('=') for ar in sys.argv[1:] if ar.find('=')>0]}
    input_file = kwargs.get('input', '.')

    if input_file is None:
        print('用法: python html.py input=INPUT_FILE(原文目录）')
        print('')
        print('INPUT_FILE 是mdx文件的路径')
    else:
        try:
            for file in os.listdir(input_file):
              result = export(file)
              print('Done', result)
        except Exception as e:
            print(e)
