name 'web'
description 'Web Server'

run_list(
         "recipe[yum]",
         "recipe[yum::epel]",
         "recipe[yum::remi]",
         "recipe[essential]",
         "recipe[users]",
         "recipe[rbenv]"
         )
