# Dockerfile para build do Neutralino.js
FROM node:18-bullseye

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Criar diretório de trabalho
WORKDIR /app

# Instalar Neutralino CLI
RUN npm install -g @neutralinojs/neu

# Copiar arquivos de configuração primeiro
COPY neutralino.config.json ./

# Inicializar projeto se necessário
RUN neu update

# Copiar recursos
COPY resources/ ./resources/

# Fazer build
RUN neu build

# Garantir que o arquivo seja copiado para dist/
RUN cp bin/* dist/ || true