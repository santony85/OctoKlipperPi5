import yaml

with open("config.yaml") as f:
	y = yaml.safe_load(f)
	y['plugins']['classicwebcam']['snapshot'] = 'http://127.0.0.1:8080/?action=snapshot'
	y['plugins']['classicwebcam']['stream'] = '/webcam/?action=stream'
	y["server"]['commands']= {}
	y['server']['commands']['serverRestartCommand'] = 'sudo service octoprint restart'
	y['server']['commands']['systemRestartCommand'] = 'sudo shutdown -r now'
	y['server']['commands']['systemShutdownCommand'] = 'sudo shutdown -h now'
 
	print(yaml.dump(y, default_flow_style=False, sort_keys=False))
	with open('new.yaml','w') as out_yamlfile:
         yaml.safe_dump(y, out_yamlfile)
         print(yaml.dump(y, default_flow_style=False, sort_keys=False))
     