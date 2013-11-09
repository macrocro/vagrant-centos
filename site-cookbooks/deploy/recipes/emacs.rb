bash "install emacs" do
  code <<-EOH
  cd /tmp
  wget http://ftp.gnu.org/pub/gnu/emacs/emacs-23.3b.tar.bz2
  bzip2 -dc emacs-23.3b.tar.bz2 | tar xvf -
  cd emacs-23.3
  ./configure -without-x
  make
  sudo make install
  EOH
end

