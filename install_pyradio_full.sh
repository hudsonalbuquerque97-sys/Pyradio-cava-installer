#!/bin/bash
# criado por hudson albuquerque hudsonalbuquerque97-sys 

set -e

echo "==> Verificando se pipx está instalado..."
if ! command -v pipx &> /dev/null; then
    echo "==> Instalando pipx e python3-venv..."
    sudo apt update
    sudo apt install -y pipx python3-venv
    pipx ensurepath
    # Atualiza PATH na sessão atual
    export PATH="$HOME/.local/bin:$PATH"
fi

echo "==> Instalando PyRadio via pipx..."
pipx install pyradio

echo "==> Instalando CAVA (visualizador de áudio)..."
sudo apt install -y cava

echo "==> Configurando diretório do PyRadio..."
# Cria o diretório de configuração se não existir
PYRADIO_DIR="$HOME/.config/pyradio"
mkdir -p "$PYRADIO_DIR"

echo "==> Criando arquivo stations.csv personalizado..."
cat > "$PYRADIO_DIR/stations.csv" << 'EOF'
# Find lots more stations at http://www.iheard.com
#HUNTER RÁDIOS
Rádio Hunter Rock FM,http://live.hunter.fm/rock_high
Rádio Hunter Pop FM,http://live.hunter.fm/pop_normal?1758518073013
Rádio Hunter 80s FM,http://live.hunter.fm/80s_normal?1758517977594
Rádio Hunter Tropical FM,http://live.hunter.fm/tropical_normal?1758515476894
Rádio Hunter Hits FM,http://live.hunter.fm/hitsbrasil_normal?1758515526553
Rádio Hunter FM Sertanejo,http://live.hunter.fm/sertanejo_high
Rádio Hunter FM MPB,http://live.hunter.fm/mpb_high
#OUTRAS WEB RÁDIOS
Classic FM,http://media-ice.musicradio.com/ClassicFMMP3
Radio Paradise,http://stream.radioparadise.com/mp3-1283
Radio Ankh,http://s08.maxcast.com.br:8622/live?1757574463261
party web Rádio,http://sv14.hdradios.net:7808/stream?1757576823738
Somente Acustico Web,http://server02.ouvir.radio.br:8100/stream?1758075884252
Rádio America FM,http://stm5.brsrv.xyz:7032/stream?1757610452616
Rádio Americana web,http://stm1.xradios.com.br:7072/live?1757610660671
#RÁDIOS AMAPÁ
Rádio 90's AP,http://sv14.hdradios.net:8750/stream?1757610389563
Rádio Diario 90.9 FM AP,http://5a57bda70564a.streamlock.net/diariomacapa/diariomacapa.stream/chunklist_w329982728.m3u8
Rádio CBN 93.3 FM AP,http://stream2.cbnamazonia.com.br/cbn-mcp?1757608902476
Rádio Equatorial 94.5 FM AP,http://sv14.hdradios.net:7344/;?1757609253027
Cidade 096 FM AP,http://server11.srvsh.com.br:7060/;?1757610325938
Rádio Equinócio 99.1 FM AP,http://s13.maxcast.com.br:8260/live?1757609388574
Rádio Forte 99.9 FM AP,http://servidor20.brlogic.com:8250/live?1757610188612
Rádio 101 FM AP,http://s3.smghosting.com.br:7514/stream
Rádio 102 FM AP,http://servidor21.brlogic.com:7754/live?1757608786405
#RADIOS RIO DE JANEIRO
Rario Hits 98.9 Goytacazes,http://wz7.servidoresbrasil.com:8162/stream?1757576999761
Radio Hits 106.9 Macaé,http://wz7.servidoresbrasil.com:9984/stream?1757576215831
JOVEM PAM 101.9 SC,http://wz7.servidoresbrasil.com:9052/stream?1759635330109
Rádio Transamérica 100.1 FM SP,http://24373.live.streamtheworld.com/RT_SP.mp3?1759635459259
Radio Love Live NY EUA,http://streaming.radiostreamlive.com/radiolovelive_devices?1759711927489
Anos 80 Web Rádio MG,http://live8.livemus.com.br:27444/live?1759712789982
Love Music FM MG,http://stm1.streaminghd.net.br:7324/;?1759712502070
Adoro Flashback web,http://server01.ouvir.radio.br:8018/stream?1759712595678
BandNews FM,http://playerservices.streamtheworld.com/api/livestream-redirect/BANDNEWSFM_SP.mp3
Hunter FM Pop,http://live.hunter.fm/pop_high
EOF

echo "==> Criando atalhos no menu de aplicativos..."

# Atalho para PyRadio
cat > "$HOME/.local/share/applications/pyradio.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=PyRadio
Comment=Reprodutor de rádio no terminal
Exec=x-terminal-emulator -e pyradio
Icon=radio
Terminal=false
Categories=AudioVideo;Audio;Player;
Keywords=radio;music;streaming;
EOF

# Atalho para PyRadio com CAVA
cat > "$HOME/.local/share/applications/pyradio-cava.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=PyRadio + CAVA
Comment=Reprodutor de rádio com visualizador de áudio
Exec=bash -c 'x-terminal-emulator -e pyradio & sleep 2 && x-terminal-emulator -e cava'
Icon=audio-spectrum-analyzer
Terminal=false
Categories=AudioVideo;Audio;Player;
Keywords=radio;music;streaming;visualizer;
EOF

# Atalho apenas para CAVA
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

# Atualiza o cache de aplicativos
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
fi

echo "==> Lista de estações personalizada instalada com sucesso!"
echo ""
echo "✓ Instalação concluída!"
echo "✓ Arquivo stations.csv configurado em: $PYRADIO_DIR/stations.csv"
echo "✓ Atalhos criados no menu de aplicativos:"
echo "  - PyRadio (apenas rádio)"
echo "  - PyRadio + CAVA (rádio + visualizador)"
echo "  - CAVA (apenas visualizador)"
echo ""
echo "Para iniciar via terminal, execute:"
echo "  pyradio          # Para o player de rádio"
echo "  cava             # Para o visualizador de áudio"
echo ""
echo "Ou procure por 'PyRadio' no menu de aplicativos!"
echo ""
echo "Nota: Pode ser necessário reiniciar o terminal para atualizar o PATH."
