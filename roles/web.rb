name 'web'
description 'Web Server'

run_list(
         "recipe[yum]",
         "recipe[yum::epel]",
         "recipe[yum::remi]",
         "recipe[essential]",
         "recipe[users]",
         "recipe[rbenv::system]",
         "recipe[ruby_build]"
         )


default_attributes(
                   "rbenv" => {
                     "rubies" => "2.0.0-p247"
                   })
