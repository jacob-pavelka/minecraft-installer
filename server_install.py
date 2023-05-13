import json
import os
import wget

file_path = os.path.realpath(__file__)
project_dir = os.path.dirname(file_path)
server_dir = os.path.dirname(project_dir)

json_path = os.path.join(project_dir,'new-mods.json')

def get_world_name(server_dir):
    prop_path = os.path.join(server_dir,'server.properties')
    props = {}
    with open(prop_path,'r') as f:
        for line in f.readlines():
            vals = line.split('=')
            props[vals[0]]=vals[1]
    return props['level-name']

with open(json_path,'r') as f:
    mods = json.load(f)

for mod in mods['mods']:
    if mod['server'] == True:
        try:
            out_path = os.path.join(server_dir,"mods",f"{mod['name']}.jar")
            if os.path.exists(out_path):
                continue
            jar = wget.download(mod['19.2']['url'], out=f"{server_dir}/mods/{mod['name']}.jar")
        except KeyError:
            print(f'this mod ({mod["name"]}) is not supported on the current version')
for dp in mods['datapacks']:
    if dp['server'] == True:
        try:
            if os.path.exists(out_path):
                continue
            out_path = os.path.join(server_dir,get_world_name(server_dir),"datapacks",f"{dp['name']}.jar")
            jar = wget.download(dp['19.2']['url'], out=out_path)
        except KeyError:
            print(f'this datapack ({dp["name"]}) is not supported on the current version')

