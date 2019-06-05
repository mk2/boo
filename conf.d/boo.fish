function _boo_uninstall -e boo_uninstall
  for name in (set -n | command awk '/^boo_/')
    set -e "$name"
  end

  functions -e (functions -a | command awk '/^_boo_/')
end
