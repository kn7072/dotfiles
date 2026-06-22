### 🛠 Как установить Zsh и плагины в Linux

#### Шаг 1. Установка самого Zsh

Откройте текущий терминал и установите Zsh через пакетный менеджер вашего дистрибутива:

- **Ubuntu / Debian / Mint:**

```bash
sudo apt update && sudo apt install zsh
```

- **Fedora:**

```bash
 sudo dnf install zsh
```

- **Arch Linux / Manjaro:**

```bash
 sudo pacman -S zsh
```

**Сделать Zsh оболочкой по умолчанию:**

```bash
chsh -s $(which zsh)
```

_(После этого нужно выйти из системы и зайти снова, либо перезагрузить ПК, чтобы изменения вступили в силу)._

#### Шаг 2. Установка Oh My Zsh

Запустите официальный скрипт установки (потребуется `curl` или `wget`):

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

После установки ваш терминал изменится, и появится папка `~/.oh-my-zsh`.

#### Шаг 3. Установка внешних плагинов

Встроенные плагины (вроде `git`, `extract`, `z`) уже лежат в папке OMZ. Но самые популярные (`autosuggestions` и `syntax-highlighting`, `fzf-tab`) нужно скачать отдельно.

Выполните эти команды в терминале, чтобы скачать их в папку пользовательских плагинов OMZ:

Можно зайти в директорию `~/.oh-my-zsh/custom/plugins/` и склонировать интересующие репозитории, либо выполнить команды ниже.

```bash
# Скачиваем автодополнение из истории
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Скачиваем подсветку синтаксиса
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Для работы с **`fzf-tab`** необходимо добавить в файл `~/.zshrc`
`autoload -U compinit; compinit`
`source ~/.oh-my-zsh/custom/plugins/fzf-tab/fzf-tab.plugin.zsh`

#### Шаг 4. Активация плагинов

Теперь нужно сказать Zsh, что мы хотим их использовать. Откройте конфигурационный файл в любом текстовом редакторе (например, в `nano`):

```bash
nano ~/.zshrc
```

Найдите строку, которая начинается с `plugins=(...)`. По умолчанию там написано только `plugins=(git)`. Замените её на следующий набор (это оптимальный минимум для комфортной работы):

```bash
plugins=(
  # fzf-tab должен быть в начале списка
  fzf-tab
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
  # fzf должен быть в конце списка
  fzf
)
```

_Сохраните файл (в nano: `Ctrl+O`, `Enter`, затем `Ctrl+X`)._

#### Шаг 5. Применение настроек

Чтобы не перезапускать терминал, просто выполните:

```bash
source ~/.zshrc
```

Готово! Теперь при вводе команд вы увидите предложения из истории, а правильные команды будут подсвечиваться зеленым.

---

### 🎨 Бонус: Установка темы Powerlevel10k

Если вы хотите красивый промпт (строку ввода), сделайте следующее:

1. Скачайте тему:

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

- Откройте `~/.zshrc` и найдите строку `ZSH_THEME="robbyrussell"`.
- Замените её на:

```bash
    ZSH_THEME="powerlevel10k/powerlevel10k"
```

2. Сохраните файл и выполните `source ~/.zshrc`.
3. Автоматически запустится мастер настройки (`p10k configure`), который в пошаговом режиме спросит, какие иконки и разделители вам нравятся, и сгенерирует идеальный конфиг.

_(Важно: для корректного отображения иконок в p10k вам потребуется установить в систему шрифт **Nerd Font**, например, `MesloLGS NF`, и указать его в настройках вашего терминала)._

---

### ⚠️ Важное предостережение

Не добавляйте в `plugins=(...)` всё подряд! Zsh читает плагины при каждом открытии новой вкладки терминала. Если вы подключите 30 тяжелых плагинов, терминал будет открываться с задержкой в 1-2 секунды. Используйте только то, чем реально пользуетесь.

