# MacroPad

Um controlador físico para o PC, no estilo Stream Deck, feito do zero: 12 teclas, um encoder rotativo, uma telinha colorida e uma barra de LED que mostra o volume.

Uma tecla abre ou seleciona um aplicativo, e as outras teclas mudam de função conforme a página ativa. Tudo é configurado por um aplicativo próprio, sem precisar regravar a placa.

> **Status:** em desenvolvimento. Veja o [roadmap](#roadmap) para saber em que fase o projeto está.

---

## Como funciona

```
┌──────────────┐   USB (serial)   ┌───────────────────────┐   edita   ┌────────────┐
│  MacroPad    │ ───────────────► │  Serviço Python (PC)  │ ◄──────── │  App de    │
│  YD-RP2040   │ ◄─────────────── │  páginas, ações,      │           │  config    │
│ CircuitPython│   eventos/comandos│  volume, Spotify      │           │ (JSON)     │
└──────────────┘                  └───────────────────────┘           └────────────┘
```

- **Placa → PC:** eventos do hardware, por exemplo `KEY:r,c:DOWN`, `ENC:+1`, `ENC:-1`, `ENC:PRESS`.
- **PC → placa:** comandos, por exemplo `VOL:63`, `MUTE:1`, `PAGE:home`.
- O PC decide o que acontece e o que aparece na tela. A placa só lê as teclas e desenha. Por isso, mudar a configuração nunca exige regravar a placa.
- Apertar o encoder é uma regra global: ele sempre volta uma página.

## Hardware

| Peça | Detalhe |
|---|---|
| Placa | YD-RP2040 (USB-C), programada em CircuitPython |
| Teclas | 12 (matriz 4×3) com switches mecânicos reaproveitados e um diodo 1N4148 por tecla |
| Encoder | Rotativo com clique: girar controla o volume, apertar volta uma página |
| Tela | IPS colorida 1,54" (ST7789, SPI) |
| Barra de LED | WS2812B endereçável, só para o volume (acende da direita para a esquerda) |
| Proteções | Resistor de 330 Ω no fio de dados dos LEDs e capacitor de 470 µF entre 5 V e GND |

Os pinos trabalham com **3,3 V**. Nunca ligue 5 V em um pino de sinal.

### Pinagem

Preencher conforme a montagem avançar.

| Função | Pino |
|---|---|
| Linhas da matriz | a definir |
| Colunas da matriz | a definir |
| Encoder A / B / botão | a definir |
| Dados da barra de LED | a definir |
| Tela (SCK / MOSI / CS / DC / RST) | a definir |

## Estrutura do repositório

```
macropad/
├── firmware/    # código CircuitPython que roda na placa (code.py, boot.py, lib/)
├── service/     # serviço Python no PC: serial, páginas, ações, volume, Spotify
├── app/         # aplicativo de configuração (edita o JSON de páginas e ações)
├── hardware/    # esquema de ligação, lista de peças, fotos, modelos 3D da caixa
├── docs/        # roadmap, resultados de cada fase, anotações e erros resolvidos
├── .gitignore
└── README.md
```

> O código em `firmware/` é a **fonte oficial**. A placa só recebe uma cópia dele. Edite sempre no repositório e copie para a placa, nunca o contrário.

## Tecnologias

| Parte | Tecnologia |
|---|---|
| Firmware | CircuitPython (`digitalio`, `rotaryio`, `keypad`, `neopixel`, `displayio`, `usb_cdc`) |
| Serviço no PC | Python (`pyserial`, `pycaw`, `psutil`, `pynput`, `spotipy`) |
| App de configuração | A definir: PySide6 (tudo em Python) ou HTML/CSS/JS em uma janela `pywebview` |
| Configuração | Arquivo JSON com páginas, teclas e ações |
| Ferramentas | Git, GitHub, Visual Studio Code |

## Como rodar

Esta seção será preenchida conforme as fases avançarem.

### Firmware (placa)

1. Instale o CircuitPython na placa. Baixe o `.uf2` em circuitpython.org/downloads e segure **BOOT** ao plugar o cabo para a unidade `RPI-RP2` aparecer.
2. Copie o conteúdo de `firmware/` para a unidade `CIRCUITPY`.

### Serviço (PC)

```bash
cd service
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python main.py
```

## Configuração e segredos

As páginas e ações ficam em um arquivo JSON. Exemplo simplificado:

```json
{
  "home": {
    "encoder": { "gira": "volume_master" },
    "teclas": [
      { "icone": "spotify", "acao": { "tipo": "abrir_pagina", "pagina": "spotify" } },
      { "icone": "discord", "acao": { "tipo": "mutar_app", "app": "Discord.exe" } }
    ]
  }
}
```

**Nunca suba senhas, chaves de API ou tokens** (como as credenciais do Spotify). Guarde esses dados em um arquivo `.env`, que fica no `.gitignore`.

## Roadmap

- [ ] **Fase 0: Fundamentos.** Python básico e eletrônica básica; script que lê e grava JSON; Git e repositório no GitHub
- [ ] **Fase 1: Placa e CircuitPython.** LED piscando e encoder sendo lido; matriz pequena de teclas (2×2 com diodos); stick de LEDs acendendo pelo código
- [ ] **Fase 2: Conversa entre placa e PC.** Comunicação serial; o PC imprime cada evento e a placa reage a comandos simples
- [ ] **Fase 3: Ações, volume e páginas.** Abrir apps, volume por app, barra de LED de volume, Home e página do Spotify
- [ ] **Fase 4: A telinha.** Logo e nome do app ativo; grade 4×3 de ícones
- [ ] **Fase 5: Spotify.** Título e capa do álbum na tela via API
- [ ] **Fase 6: App de configuração.** Árvore de páginas, editor de ações, biblioteca de ícones, ícone na bandeja
- [ ] **Fase 7: Hardware final.** Matriz 4×3 soldada, caixa impressa em 3D, barra de LED com difusor
- [ ] **Fase 8: Extras.** Perfis por app, macros, controle do OBS e do Discord, plugins

Os resultados de cada fase ficam em [`docs/`](docs/).

## Referências

- [Adafruit Learn](https://learn.adafruit.com): Welcome to CircuitPython e os guias do MacroPad RP2040
- [Deej](https://github.com/omriharel/deej): mixer de volume por app
- [KMK](https://github.com/KMKfw/kmk_firmware): firmware de teclados em CircuitPython
- Documentação do [pycaw](https://github.com/AndreMiras/pycaw) e do [spotipy](https://spotipy.readthedocs.io)

## Licença

A definir.
