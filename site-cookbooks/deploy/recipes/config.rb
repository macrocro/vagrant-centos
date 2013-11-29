bash "git clone .emacs.d" do
  code <<-EOH
    cd /home/kuroda/
    git clone git@github.com:macrocro/config
    mv config .config
    rm -rf .emacs.d
    rm -f .zshrc
    ln -s .config/.emacs.d .emacs.d
    ln -s .config/.zshrc .zshrc
    chmod -R 755 .emacs.d
    chown -R kuroda:kuroda .emacs.d
    chmod 755 .zshrc
    chown kuroda:kuroda .zshrc
  EOH
end

# chmod -R 755 /home/kuroda/.emacs.d
# chmod 755 /home/kuroda/.zshrc
# chown -R kuroda:kuroda /home/kuroda
