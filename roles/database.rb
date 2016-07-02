name 'database'
description 'A role for database servers'

run_list 'recipe[apt-update]', 'recipe[database]'
