dot = $(shell pwd)

default:
	# tmux
	ln -sfv $(dot)/tmux/.tmux.conf ~/.tmux.conf

  # vim
	ln -sfv $(dot)/vim/.vimrc ~/.vimrc
	ln -sfv $(dot)/vim ~/.vim

	# neovim
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	ln -sfv $(dot)/vim/.vimrc $(dot)/nvim/init.vim

	# haskell
	ln -sfv $(dot)/haskell/.ghci ~/.ghci

	# ssh
	ln -sfv $(dot)/ssh ~/.ssh

	# other
	ln -sfv $(dot)/home/.netrc ~/.netrc
	ln -sfv $(dot)/home/.npmrc ~/.npmrc
	ln -sfv $(dot)/home/.dockercfg ~/.dockercfg
