name 'web'
description 'Web Server'

run_list(
         "recipe[essential]",
         "recipe[users]"
         )
