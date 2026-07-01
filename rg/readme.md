ln -s -f $(pwd)/.ripgreprc /home/stepan/.ripgreprc

1. файл `.ripgreprc` должен находится в корневой директории пользователя.
2. Добавить переменную окружения в свой .bashrc или .zshrc:
   export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
3. сделать `source ~/.ripgreprc`
