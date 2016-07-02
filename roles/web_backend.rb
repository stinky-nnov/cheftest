name 'web_backend'
description 'A role for web backend servers'

run_list 'recipe[apt-update]', 'recipe[backend]'
