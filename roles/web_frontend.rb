name 'web_frontend'
description 'A role for front-line web servers'

run_list 'recipe[apt-update]', 'recipe[frontend]'
