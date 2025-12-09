#!/bin/bash
# Criado por Hudson Albuquerque hudsonalbuquerque97-sys
# Versão corrigida com tratamento de erros e dependências corretas

set -e

echo "============================================="
echo "  Instalador PyRadio + CAVA"
echo "============================================="
echo ""

# Função para verificar se comando existe
command_exists() {
    command -v "$1" &> /dev/null
}

# Função para instalar PyRadio via pip (método alternativo)
install_pyradio_pip() {
    echo "==> Tentando instalar PyRadio via pip..."
    
    # Instala dependências necessárias (incluindo mplayer)
    sudo apt update
    sudo apt install -y python3-pip python3-dev python3-setuptools \
        mplayer mpv git curl
    
    # Instala PyRadio via pip do usuário
    pip3 install --user pyradio
    
    # Adiciona ~/.local/bin ao PATH se não estiver
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
}

# Função para instalar PyRadio via pipx
install_pyradio_pipx() {
    echo "==> Tentando instalar PyRadio via pipx..."
    
    # Instala pipx, dependências e MPLAYER (importante!)
    sudo apt update
    sudo apt install -y pipx python3-venv mplayer mpv
    
    # Configura pipx
    pipx ensurepath
    export PATH="$HOME/.local/bin:$PATH"
    
    # Instala PyRadio
    pipx install pyradio
}

# Função para instalar PyRadio via git (método mais confiável)
install_pyradio_git() {
    echo "==> Instalando PyRadio via código-fonte (git)..."
    
    # Instala dependências (incluindo mplayer)
    sudo apt update
    sudo apt install -y python3 python3-pip python3-setuptools \
        mplayer mpv git curl python3-requests python3-dnspython \
        python3-psutil python3-rich
    
    # Remove instalação anterior se existir
    rm -rf /tmp/pyradio
    
    # Clona repositório
    git clone https://github.com/coderholic/pyradio.git /tmp/pyradio
    cd /tmp/pyradio
    
    # Instala
    python3 setup.py install --user
    
    # Volta ao diretório anterior
    cd - > /dev/null
    
    # Adiciona ao PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
}

# Tenta instalar PyRadio (ordem de preferência)
echo "==> Verificando instalação do PyRadio..."

PYRADIO_INSTALLED=false

if command_exists pyradio; then
    echo "✓ PyRadio já está instalado!"
    PYRADIO_INSTALLED=true
else
    echo "PyRadio não encontrado. Tentando instalar..."
    
    # Tenta método 1: pipx
    if install_pyradio_pipx 2>/dev/null; then
        echo "✓ PyRadio instalado via pipx!"
        PYRADIO_INSTALLED=true
        INSTALL_METHOD="pipx"
    # Tenta método 2: pip
    elif install_pyradio_pip 2>/dev/null; then
        echo "✓ PyRadio instalado via pip!"
        PYRADIO_INSTALLED=true
        INSTALL_METHOD="pip"
    # Tenta método 3: git (mais confiável)
    elif install_pyradio_git 2>/dev/null; then
        echo "✓ PyRadio instalado via código-fonte!"
        PYRADIO_INSTALLED=true
        INSTALL_METHOD="git"
    else
        echo "❌ ERRO: Não foi possível instalar o PyRadio."
        echo "Tente instalar manualmente com:"
        echo "  sudo apt install -y python3-pip mplayer mpv"
        echo "  pip3 install --user pyradio"
        exit 1
    fi
fi

# Verifica se mplayer está instalado
echo ""
echo "==> Verificando dependência MPLAYER..."
if command_exists mplayer; then
    echo "✓ MPlayer já está instalado!"
else
    echo "==> Instalando MPlayer (necessário para PyRadio)..."
    sudo apt install -y mplayer
    echo "✓ MPlayer instalado!"
fi

# Instala CAVA
echo ""
echo "==> Instalando CAVA (visualizador de áudio)..."
if command_exists cava; then
    echo "✓ CAVA já está instalado!"
else
    sudo apt install -y cava || {
        echo "⚠ Aviso: Não foi possível instalar CAVA via apt."
        echo "Você pode instalá-lo manualmente depois."
    }
fi

# Configura CAVA
echo ""
echo "==> Configurando CAVA..."
CAVA_DIR="$HOME/.config/cava"
mkdir -p "$CAVA_DIR"

cat > "$CAVA_DIR/config" << 'EOF'
[general]
bars = 80
framerate = 60
autosens = 1

[input]
method = pulse
source = auto

[output]
method = ncurses
character = "■"

[color]
gradient = 1
gradient_color_1 = '#00ff00'   ; verde
#gradient_color_2 = '#ffff00'   ; amarelo
#gradient_color_3 = '#ff0000'   ; vermelho
background = '#000000'         ; preto
EOF

echo "✓ Configuração do CAVA criada em: $CAVA_DIR/config"

# Configura PyRadio e stations.csv
echo ""
echo "==> Configurando PyRadio..."

# Cria arquivo temporário com as estações
TEMP_STATIONS=$(mktemp)
cat > "$TEMP_STATIONS" << 'EOF'
# Find lots more stations at http://www.iheard.com
#HUNTER RÁDIOS
Rádio Hunter Rock FM,http://live.hunter.fm/rock_high
Rádio Hunter Pop FM,http://live.hunter.fm/pop_normal
Rádio Hunter 80s FM,http://live.hunter.fm/80s_normal
Rádio Hunter Tropical FM,http://live.hunter.fm/tropical_normal
Rádio Hunter Hits FM,http://live.hunter.fm/hitsbrasil_normal
Rádio Hunter FM Sertanejo,http://live.hunter.fm/sertanejo_high
Rádio Hunter FM MPB,http://live.hunter.fm/mpb_high
#OUTRAS WEB RÁDIOS
Classic FM,http://media-ice.musicradio.com/ClassicFMMP3
Radio Paradise,http://stream.radioparadise.com/mp3-128
Radio Ankh,http://s08.maxcast.com.br:8622/live
Party Web Rádio,http://sv14.hdradios.net:7808/stream
Somente Acústico Web,http://server02.ouvir.radio.br:8100/stream
Rádio America FM,http://stm5.brsrv.xyz:7032/stream
Rádio Americana Web,http://stm1.xradios.com.br:7072/live
#RÁDIOS AMAPÁ
Rádio 90's AP,http://sv14.hdradios.net:8750/stream
Rádio Diário 90.9 FM AP,http://5a57bda70564a.streamlock.net/diariomacapa/diariomacapa.stream/playlist.m3u8
Rádio CBN 93.3 FM AP,http://stream2.cbnamazonia.com.br/cbn-mcp
Rádio Equatorial 94.5 FM AP,http://sv14.hdradios.net:7344/
Cidade 096 FM AP,http://server11.srvsh.com.br:7060/
Rádio Equinócio 99.1 FM AP,http://s13.maxcast.com.br:8260/live
Rádio Forte 99.9 FM AP,http://servidor20.brlogic.com:8250/live
Rádio 101 FM AP,http://s3.smghosting.com.br:7514/stream
Rádio 102 FM AP,http://servidor21.brlogic.com:7754/live
#RÁDIOS RIO DE JANEIRO
Rádio Hits 98.9 Goytacazes,http://wz7.servidoresbrasil.com:8162/stream
Rádio Hits 106.9 Macaé,http://wz7.servidoresbrasil.com:9984/stream
JOVEM PAN 101.9 SC,http://wz7.servidoresbrasil.com:9052/stream
Rádio Transamérica 100.1 FM SP,http://24373.live.streamtheworld.com/RT_SP.mp3
Rádio Love Live NY EUA,http://streaming.radiostreamlive.com/radiolovelive_devices
Anos 80 Web Rádio MG,http://live8.livemus.com.br:27444/live
Love Music FM MG,http://stm1.streaminghd.net.br:7324/
Adoro Flashback Web,http://server01.ouvir.radio.br:8018/stream
BandNews FM,http://playerservices.streamtheworld.com/api/livestream-redirect/BANDNEWSFM_SP.mp3
Hunter FM Pop,http://live.hunter.fm/pop_high
EOF

# Copia stations.csv para o diretório correto
# 1. Diretório de configuração do usuário
PYRADIO_CONFIG_DIR="$HOME/.config/pyradio"
mkdir -p "$PYRADIO_CONFIG_DIR"
cp "$TEMP_STATIONS" "$PYRADIO_CONFIG_DIR/stations.csv"
echo "✓ stations.csv criado em: $PYRADIO_CONFIG_DIR/stations.csv"

# 2. Detecta e copia para o diretório do pipx (se instalado via pipx)
PIPX_PYRADIO_DIRS=$(find "$HOME/.local/share/pipx/venvs/pyradio/lib/" -type d -name "pyradio" 2>/dev/null || true)

if [ -n "$PIPX_PYRADIO_DIRS" ]; then
    echo "==> Detectado PyRadio instalado via pipx, copiando stations.csv..."
    while IFS= read -r dir; do
        if [ -f "$dir/stations.csv" ]; then
            # Faz backup do original
            cp "$dir/stations.csv" "$dir/stations.csv.backup"
            # Copia o novo
            cp "$TEMP_STATIONS" "$dir/stations.csv"
            echo "✓ stations.csv copiado para: $dir/stations.csv"
            echo "  (backup salvo em: $dir/stations.csv.backup)"
        fi
    done <<< "$PIPX_PYRADIO_DIRS"
fi

# 3. Também copia para possíveis localizações do pip
PIP_PYRADIO_DIRS=$(find "$HOME/.local/lib/" -type d -name "pyradio" 2>/dev/null || true)

if [ -n "$PIP_PYRADIO_DIRS" ]; then
    echo "==> Detectado PyRadio instalado via pip, copiando stations.csv..."
    while IFS= read -r dir; do
        if [ -f "$dir/stations.csv" ]; then
            # Faz backup do original
            cp "$dir/stations.csv" "$dir/stations.csv.backup"
            # Copia o novo
            cp "$TEMP_STATIONS" "$dir/stations.csv"
            echo "✓ stations.csv copiado para: $dir/stations.csv"
            echo "  (backup salvo em: $dir/stations.csv.backup)"
        fi
    done <<< "$PIP_PYRADIO_DIRS"
fi

# Remove arquivo temporário
rm -f "$TEMP_STATIONS"

# Cria atalhos no menu
echo ""
echo "==> Criando atalhos no menu de aplicativos..."
mkdir -p "$HOME/.local/share/applications"

# Atalho PyRadio
cat > "$HOME/.local/share/applications/pyradio.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=PyRadio
Comment=Reprodutor de rádio no terminal
Exec=x-terminal-emulator -e bash -c 'export PATH="\$HOME/.local/bin:\$PATH"; pyradio; read -p "Pressione ENTER para fechar..."'
Icon=radio
Terminal=false
Categories=AudioVideo;Audio;Player;
Keywords=radio;music;streaming;
EOF

# Atalho PyRadio + CAVA
cat > "$HOME/.local/share/applications/pyradio-cava.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=PyRadio + CAVA
Comment=Reprodutor de rádio com visualizador de áudio
Exec=bash -c 'export PATH="\$HOME/.local/bin:\$PATH"; x-terminal-emulator -e pyradio & sleep 3 && x-terminal-emulator -e cava'
Icon=audio-spectrum-analyzer
Terminal=false
Categories=AudioVideo;Audio;Player;
Keywords=radio;music;streaming;visualizer;
EOF

# Atalho CAVA
cat > "$HOME/.local/share/applications/cava.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=CAVA
Comment=Visualizador de áudio no terminal
Exec=x-terminal-emulator -e cava
Icon=audio-spectrum-analyzer
Terminal=false
Categories=AudioVideo;Audio;
Keywords=audio;visualizer;spectrum;
EOF

# Torna os atalhos executáveis
chmod +x "$HOME/.local/share/applications/"*.desktop

# Atualiza cache de aplicativos
if command_exists update-desktop-database; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
fi

echo ""
echo "============================================="
echo "  ✓ INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
echo "============================================="
echo ""
echo "📦 Dependências instaladas:"
echo "   • PyRadio"
echo "   • MPlayer (player de áudio)"
echo "   • MPV (player alternativo)"
echo "   • CAVA (visualizador)"
echo ""
echo "📁 Arquivos de configuração:"
echo "   • PyRadio: $PYRADIO_CONFIG_DIR/stations.csv"
echo "   • CAVA: $CAVA_DIR/config"
echo ""
echo "🎵 Total de estações: $(grep -c '^[^#]' "$PYRADIO_CONFIG_DIR/stations.csv" || echo "35+")"
echo ""
echo "🚀 Para iniciar via terminal:"
echo "   pyradio          # Player de rádio"
echo "   cava             # Visualizador de áudio"
echo ""
echo "📱 Ou procure no menu de aplicativos:"
echo "   • PyRadio (apenas rádio)"
echo "   • PyRadio + CAVA (rádio + visualizador)"
echo "   • CAVA (apenas visualizador)"
echo ""
echo "🎨 Configuração do CAVA:"
echo "   • 80 barras"
echo "   • 60 FPS"
echo "   • Gradiente verde"
echo "   • Auto-sense ativado"
echo ""
echo "⚠️  IMPORTANTE: Feche e abra o terminal novamente"
echo "   para atualizar o PATH antes de usar."
echo ""
echo "💡 DICA: Dentro do PyRadio pressione '?' para ajuda"
echo ""
echo "============================================="
