name 'shared_storage'
description 'A role for shared file storage and caching servers'

run_list 'recipe[apt-update]', 'recipe[shared_filestorage]', 'recipe[shared_cache]'
