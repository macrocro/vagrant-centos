name 'web'
description 'Web Server'

run_list(
         # "recipe[yum]",
         # "recipe[yum::epel]",
         # "recipe[yum::remi]",
         # "recipe[essential]",
         # "recipe[users]",
         # "recipe[ruby_build]",
         # "recipe[rbenv::system]"
         "recipe[apache]",
         "recipe[mysql]",
         "recipe[php]",
         "recipe[phpmyadmin]",
         "recipe[ssh]",
         "recipe[ufw::install]",
         "recipe[ufw::init]"

         #####################
         # "recipe[nginx]",
         #####################
         # "recipe[webdicom]"
         #####################

         )

default_attributes(
                   "rbenv" => {
                     "rubies" => "2.0.0-p247"
                   },
                   "ssh" => {
                     "port" => 22
                   }
                   )
