# PyRadio + CAVA: Rádio Online com Visualizador Espectral
# PyRadio + CAVA: Terminal Radio with Audio Visualizer

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Status](https://img.shields.io/badge/status-stable-green)
![Platform](https://img.shields.io/badge/platform-linux-lightgrey)
![Ubuntu](https://img.shields.io/badge/ubuntu-compatible-orange)
![Linux Mint](https://img.shields.io/badge/linux%20mint-compatible-green)
![Bash](https://img.shields.io/badge/bash-script-black)
![Automation](https://img.shields.io/badge/automated-installer-ff69b4)
![Radio](https://img.shields.io/badge/online-radio-red)
![Stations](https://img.shields.io/badge/50%2B-stations-brightgreen)

[🇧🇷 Português](#português) | [🇺🇸 English](#english)

---

## Português

# 📻 Instalador PyRadio + CAVA

Script automatizado para instalação e configuração do PyRadio com visualizador de áudio CAVA no Linux Mint; Ubuntu; e derivados.

## 🎯 O que o script faz?

- ✅ Instala **pipx** e **python3-venv** (se necessário)
- ✅ Instala **PyRadio** via pipx
- ✅ Instala **CAVA** (visualizador de áudio com barras)
- ✅ Substitui o arquivo `stations.csv` com lista personalizada de rádios brasileiras
- ✅ Cria **3 atalhos** no menu de aplicativos:
  - PyRadio (apenas rádio)
  - PyRadio + CAVA (rádio + visualizador)
  - CAVA (apenas visualizador)

## 🚀 Como usar

### 1. Dar permissão de execução
```bash
chmod +x install_pyradio_full.sh
```

### 2. Executar o script
```bash
./install_pyradio_full.sh
```

### 3. Iniciar o PyRadio

**Via menu de aplicativos:**
- Procure por "PyRadio" no menu
- Escolha entre as 3 opções disponíveis

**Via terminal:**
```bash
pyradio              # Apenas rádio
cava                 # Apenas visualizador
```

**Abrir os dois juntos (manualmente):**
```bash
# Terminal 1
pyradio

# Terminal 2 (nova janela)
cava
```

## 📂 Arquivos criados

- `~/.config/pyradio/stations.csv` - Lista de estações
- `~/.local/share/applications/pyradio.desktop` - Atalho PyRadio
- `~/.local/share/applications/pyradio-cava.desktop` - Atalho PyRadio + CAVA
- `~/.local/share/applications/cava.desktop` - Atalho CAVA

## 🎵 Estações incluídas

- **Hunter Rádios** (Rock, Pop, 80s, Tropical, Sertanejo, MPB)
- **Rádios do Amapá** (CBN, Equatorial, Cidade, Equinócio, etc)
- **Rádios do Rio de Janeiro**
- **Web Rádios** (Classic FM, Radio Paradise, Flashback, etc)

## ⚙️ Requisitos

- Sistema baseado em Debian/Ubuntu (usa `apt`)
- Conexão com a internet
- Permissões de `sudo`

## 🔧 Atalhos do PyRadio

- `↑` / `↓` - Navegar entre estações
- `Enter` - Reproduzir estação selecionada
- `Space` - Pausar/Retomar
- `+` / `-` - Volume
- `q` - Sair

## 📝 Notas

- Pode ser necessário reiniciar o terminal após a instalação
- Se o CAVA não capturar o áudio, configure em `~/.config/cava/config`
- Para adicionar mais estações, edite `~/.config/pyradio/stations.csv`

---

## English

# 📻 PyRadio + CAVA Installer

Automated script to install and configure PyRadio with CAVA audio visualizer on Linux Mint, Ubuntu, and derivatives.

## 🎯 What the script does

- ✅ Installs **pipx** and **python3-venv** (if needed)
- ✅ Installs **PyRadio** via pipx
- ✅ Installs **CAVA** (bar-based audio visualizer)
- ✅ Replaces the `stations.csv` file with a custom list of Brazilian radio stations
- ✅ Creates **3 application menu shortcuts**:
  - PyRadio (radio only)
  - PyRadio + CAVA (radio + visualizer)
  - CAVA (visualizer only)

## 🚀 How to use

### 1. Give execution permission

```bash
chmod +x install_pyradio_full.sh
```
2. Run the script

```bash
./install_pyradio_full.sh
```

3. Start PyRadio

**Via application menu:**

    Search for "PyRadio" in the menu

    Choose between the 3 available options

**Via terminal:**
```bash
pyradio              # Radio only
cava                 # Visualizer only
```
**Open both together (manually):**
```bash
# Terminal 1
pyradio

# Terminal 2 (new window)
cava
```
## 📂 Created files

- `~/.config/pyradio/stations.csv` - Station list
- `~/.local/share/applications/pyradio.desktop` - PyRadio shortcut
- `~/.local/share/applications/pyradio-cava.desktop` - PyRadio + CAVA shortcut
- `~/.local/share/applications/cava.desktop` - CAVA shortcut

## 🎵 Included stations

    Hunter Rádios (Rock, Pop, 80s, Tropical, Sertanejo, MPB)
    Rádios from Amapá (CBN, Equatorial, Cidade, Equinócio, etc)
    Rádios from Rio de Janeiro
    Web Rádios (Classic FM, Radio Paradise, Flashback, etc)

## ⚙️ Requirements

- Debian/Ubuntu-based system (uses `apt`)
- Internet connection
- `sudo` permissions

## 🔧 PyRadio shortcuts

    ↑ / ↓ - Navigate between stations
    Enter - Play selected station
    Space - Pause/Resume
    + / - - Volume
    q - Quit

## 📝 Notes

    You may need to restart the terminal after installation
    If CAVA doesn't capture audio, configure it in `~/.config/cava/config`
    To add more stations, edit `~/.config/pyradio/stations.csv`
